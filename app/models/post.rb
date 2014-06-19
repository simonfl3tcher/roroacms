class Post < ActiveRecord::Base
  
    has_ancestry

    # relations, validations and scope

    belongs_to :admin
    has_many :post_abstractions
    has_many :attachments
    has_many :term_relationships, :dependent => :destroy
    has_many :terms, :through => :term_relationships
    has_many :child, :class_name => "Post", :foreign_key => "parent_id", conditions: "post_type != 'autosave'"

    validates :post_title, :post_slug, :presence => true
    validates_uniqueness_of :post_slug, :scope => [:post_type]
    validates_format_of :post_slug, :with => /\A[A-Za-z0-9-]*\z/
    validates :sort_order, :numericality => true, :allow_blank => true

    scope :from_this_year, where("post_date > ? AND post_date < ?", Time.now.beginning_of_year, Time.now.end_of_year)

    # general data that doesn't change very often

    POST_STATUS = ["Published", "Draft", "Disabled"]
    POST_TAGS ||= Term.where(term_anatomies: {taxonomy: 'tag'}).order('name asc').includes(:term_anatomy)
    POST_CATEGORIES ||= Term.where(term_anatomies: {taxonomy: 'category'}).order('name asc').includes(:term_anatomy)

    # get all the posts/pages in the system - however if there is a search parameter 
    # search the necessary fields for the given value

    def self.setup_and_search_posts(params, type)
        type = type == 'page' ? 'page' : 'post'
        posts = Post.select('*').where("disabled ='N' and post_type = ?", type).order("ancestry")
        posts
        
    end

    # get all the tags for the system

    def self.get_tags(id = nil)
        sql = Term.where(term_anatomies: {taxonomy: 'tag'})
        if !id.blank?
            sql = sql.where('terms.id != ?', id)
        end
        sql.order('name asc').includes(:term_anatomy)
    end

    # get all the categories for the system

    def self.get_cats(id = nil)
        sql = Term.where(term_anatomies: {taxonomy: 'category'})
        if !id.blank?
            sql = sql.where('terms.id != ?', id)
        end
        sql.order('name asc').includes(:term_anatomy)
    end

    # get all the records but with an offset/limit

    def self.get_records(off, type)
        Post.where(:disabled => 'N', :post_type => type).order("COALESCE(ancestry, id), ancestry IS NOT NULL, id").limit(10).offset(off)
    end

    # gets called when a post gets saved to add categories/tags against the post

    def self.deal_with_categories(post, cats, tags, delete = false) 

        @delcats = TermRelationship.where(:post_id => post.id)

        # if delete is true it will remove all relationships with that individual post

        if delete 
            if !@delcats.blank?
                @delcats.each do |f|
                    @cat = TermRelationship.find(f.id)
                    @cat.destroy
                end
            end
        end

        # if categories is not blank it will create a new relationship with that post

        if !cats.blank?
            cats.each do |val|
                TermRelationship.create(:term_id => val, :post_id => post.id)
            end
        end

        # if tags is not blank it will create a new relationship with that post

        if !tags.blank?
            tags.each do |val|
                TermRelationship.create(:term_id => val, :post_id => post.id)
            end
        end
    end

    # if the post slug is not the same as the old slug. it will update the structured url against the record

    def self.deal_with_slug_update(params, current_url)

        if current_url != params[:post][:post_slug]
            p = Post.where("(structured_url like ?)", "%#{current_url}%")
            p.each do |pst|
                pst.structured_url = pst.structured_url.gsub("/#{current_url}", "/#{params[:post][:post_slug]}")
                pst.save
            end 
        else 
            # Do nothing then
        end

    end

    # disables the post essentially putting it into the trash area

    def self.disable_post(post_id)
        post = Post.find(post_id)
        post.disabled = "Y"
        post.save
    end

    # will make sure that specific data is correctly formatted for the database

    def deal_with_abnormalaties

        # if the slug is empty it will take the title and create a slug
        if self.post_slug.blank?
            self.post_slug = self.post_title.gsub(' ', '-').downcase
        end

        # if post status is left blank it will set the status to draft
        if self.post_status.blank?
            self.post_status = 'Draft'
        end

        # if the post has a parent it will prefix the structured url with its parents url
        if self.parent_id
            self.structured_url = "#{self.parent.structured_url}/#{self.post_slug}"
        else
            self.structured_url = "/#{self.post_slug}"
        end

    end

    # filter/format the additional fields and add the data to the post_additional_data field of the record.

    def additional_data(data)

        if !data.blank?
            data.each do |key, value|
                if value.count < 2
                    data[key.to_sym] = value[0]
                end
            end
            self.post_additional_data = ActiveSupport::JSON.encode(data)
        end
    end

    # creates a revision record of the post

    def self.do_autosave(params, post)


        parent = Post.find(params[:post][:id])
        @autosave_records = Post.where("ancestry = ? AND post_type = 'autosave' AND post_status = 'Autosave'", parent.id).order("created_at DESC")
        post.post_content = params[:ck_content]

        if (remove_uncessary(post) != remove_uncessary(parent)) && (remove_uncessary(post) != remove_uncessary(@autosave_records.first))

            # if the amount of records is equal to 10 remove the last one
            if @autosave_records.length > 9
                Post.destroy(@autosave_records.last[:id])
            end

            # Do the autosave
            @cats = params[:category_ids]

            # create the settings for the revision record

            post.id = nil
            post.parent_id = parent.id

            if post.post_slug.empty?
                post.post_slug = post.post_title.gsub(' ', '-')
            end

            post.post_status = 'Autosave'
            post.post_type = 'autosave'


            # save the post and its categories/tags
            if post.save(:validate => false)
                
                @delcats = TermRelationship.where(:post_id => post.id)

                if !@delcats.blank?
                    @delcats.each do |f|
                        @cat = TermRelationship.find(f.id)
                        @cat.destroy
                    end
                end

                if !@cats.blank?
                    @cats.each do |val|
                        TermRelationship.create(:term_id => val, :post_id => post.id)
                    end
                end

                return "passed"

            else
                return "failed" 
            end

        else 
            return "nothing changed"
        end

    end

    def self.create_user_backup_record(post)

        

        post.parent_id = post.id
        post.structured_url = nil
        post.updated_at = nil
        post.created_at = nil
        post.id = nil

        if post.post_slug.empty?
            post.post_slug = post.post_title.gsub(' ', '-')
        end

        post.post_status = 'User-Autosave'
        post.post_type = 'autosave'

        Post.new(post.attributes).save({validate: false}) and return true

    end

    def self.do_update_check(post, params)

        str1 = params[:post_content] + '//' + params[:post_title] + '//' + params[:post_slug] + '//'
        str2 = post[:post_content] + '//' + post[:post_title] + '//' + post[:post_slug] + '//'

        if str1 != str2
            post
        else 
            nil
        end

    end

    # remove the unwanted keys from the hash to be able to successfully compare the hashes


    def self.remove_uncessary(obj)

        obj.post_content = obj.post_content.gsub("\n", ' ').gsub("\r", ' ').squeeze(' ')
        obj = obj.attributes
        obj.delete('id')
        obj.delete('created_at')
        obj.delete('updated_at')
        obj.delete('ancestry')
        obj.delete('structured_url')
        obj.delete('post_visible')
        obj.delete('post_status')
        obj.delete('post_type')
        obj.delete('parent_id')

        obj

    end

    # restore the given post back to the revision record data

    def self.restore(post) 

        parent = Post.find(post.parent_id)

        parent.post_content = post.post_content
        parent.post_date = post.post_date
        parent.post_slug = post.post_slug
        parent.post_title = post.post_title
        parent.disabled = post.disabled

        parent.save

        return parent

    end

    # is the bootstrap for the bulk update function. It takes in the call
    # and decides what function to call in order to get the correct output

    def self.bulk_update(params, type)

        action = params[:to_do]
        action = action.gsub(' ', '_')

        if type == 'pages'
            act = params[:pages]
        else
            act = params[:posts]
        end

        if act.nil?
            action = ""
        end

        case action.downcase 

            when "publish"
                bulk_update_publish act
                return I18n.t("models.post.bulk_update.published_successfully", type: type.capitalize)
            when "draft"
                bulk_update_draft act
                return I18n.t("models.post.bulk_update.draft_successfully", type: type.capitalize)
            when "move_to_trash"
                bulk_update_move_to_trash act
                return I18n.t("models.post.bulk_update.trash_successfully", type: type.capitalize)
            else

            respond_to do |format|
                return I18n.t("generic.nothing")
            end
        end

    end

    private 

    # update all of the given records to have a post_status of published

    def self.bulk_update_publish(params)
        params.each do |val|
            post = Post.find(val)
            post.post_status = "Published"
            post.post_date = Time.now.utc.to_s(:db)
            post.save
        end
    end

    # update all of the given records to have a post_status of draft

    def self.bulk_update_draft(params)
        params.each do |val|
            post = Post.find(val)
            post.post_status = "Draft"
            post.save
        end 
    end

    # move all of the given records into the trash

    def self.bulk_update_move_to_trash(params)
        params.each do |val|
            post = Post.find(val)
            post.disabled ="Y"
            post.save
        end
    end

end
