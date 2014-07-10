module NewViewHelper

  # The view helper contains all of the functions that the views
  # will use in order to display the contents of either the content
  # or format other data

  # GENERIC Functions #

  def obtain_children(parent_id = nil, limit = nil, orderby = 'post_title')
  	# look at ancertry gem 
  	posts = Post.where(:parent_id => parent_id.blank? ? @content.id : parent_id).order(orderby)
    posts = posts.limit(1) if !limit.blank?
    posts
  end

  # Gets the link to the post
  # Params:
  # +check+:: id of the post record that you want to return the link of

  def obtain_permalink(check = nil)

  	post = 
  		if id.blank?
  			@content
  		else
  			Post.find(id)
  		end

    article_url = Setting.get('articles_slug')
    site_url = Setting.get('site_url')

    if post.post_type == 'post'
      render :inline => "#{site_url}#{article_url}/#{post.post_slug}"
    else
      render :inline => "#{site_url}#{post.post_slug}"
    end

  end

  def obtain_excerpt(id = nil, length = 300, omission = '...')
  	
  	post =
  		if id.blank?
  			@content
  		else
  			Post.find(id.to_i)
  		end
  	render :inline => truncate(post.post_content.to_s.gsub(/<[^>]*>/ui,'').html_safe, :omission => omission, :length => length)
  
  end

  def obtain_cover_image(id = nil)
  	post =
  		if id.blank?
  			@content
  		else
  			Post.find(id.to_i)
  		end
  	post.post_image
  end


  # Display the date of the current post or the given post via the ID
  # Params:
  # +id+:: article or page id
  # +format+:: the date format that you want the date to be provided in
  # PREVIOUSLY: get_the_date

  def obtain_the_date(id = nil, format = "%d-%m-%Y")
  	post = 
  		if id.blank?
  			@content
  		else
  			Post.find(id.to_i)
  		end
  	render :inline => post.post_date.strftime(format)
  end

  def has_cover_image?(id = nil)
  	post = 
  		if id.blank?
  			@content
  		else
  			Post.find(id.to_i)
  		end
  	post.post_image.blank?
  end

  # CATEGORY functions #

  # TODO: get by post if id is not nil
  def obtain_all_category_ids(article_id = nil)
    if article_id.blank?
      terms = Term.includes(:term_anatomy).where(term_anatomies: { taxonomy: 'category' }).pluck(:id)
    else
      # get via the posts
    end
  end

  def obtain_categories
		Term::CATEGORIES
  end

  def obtain_category(check = nil)
    if check.blank?
      Term.includes(:term_anatomy).where(:structured_url => "/" +  segments.drop(2).join('/'), term_anatomies: { taxonomy: 'category' }).last
    else
      Term.includes(:term_anatomy).where("name = :p OR slug = :p2 OR id = :p3", { p: check, p2: check, p3: check.to_i }).where(term_anatomies: { taxonomy: 'category' }).first
    end
  end

  def obtain_category_title(id = nil)

  	segments = params[:slug].split('/')

    # get the taxonomy name and search the database for the record with this as its slug
    if !segments[2].blank?
      t =  Term.includes(:term_anatomy).where(:structured_url => "/" +  segments.drop(2).join('/'), term_anatomies: { taxonomy: 'category' }).last
      t.name
    else
      nil
    end

  end

  def obtain_category_link(id = nil)
    segments = params[:slug].split('/')

    # get the taxonomy name and search the database for the record with this as its slug
    if !segments[2].blank?
      t =  Term.includes(:term_anatomy).where(:structured_url => "/" +  segments.drop(2).join('/'), term_anatomies: { taxonomy: 'category' }).last
      Setting.get('articles_slug') + '/' + Setting.get('tag_slug') + t.structured_url
    else
      nil
    end
  end

  def obtain_category_description(id = nil)

  	segments = params[:slug].split('/')

    # get the taxonomy name and search the database for the record with this as its slug
    if !segments[2].blank?
      t =  Term.includes(:term_anatomy).where(:structured_url => "/" +  segments.drop(2).join('/'), term_anatomies: { taxonomy: 'category' }).last
      t.description
    else
      nil
    end

  end

  # TODO: --
  def in_category?(cat, postid = nil)
  	post =
  		if postid.blank?
  			@content.id
  		else
  			postid
  		end
  	Post.includes(:terms => :term_anatomy).where(id: post, terms: { id: cat }, term_anatomies: { taxonomy: 'category' }).count
  end

  # TAG Functions #

  # TODO: --
  def obtain_tag_link(id = nil)
    segments = params[:slug].split('/')

    # get the taxonomy name and search the database for the record with this as its slug
    if !segments[2].blank?
      t =  Term.includes(:term_anatomy).where(:structured_url => "/" +  segments.drop(2).join('/'), term_anatomies: { taxonomy: 'tag' }).last
      Setting.get('articles_slug') + '/' + Setting.get('tag_slug') + t.structured_url
    else
      nil
    end
  end

  def obtain_tags
  	Term::TAGS
  end

  # TODO: --
  def has_tag?(tag, postid = nil)
  	post =
  		if postid.blank?
  			@content.id
  		else
  			postid
  		end
  	Post.includes(:terms => :term_anatomy).where(id: post, terms: { id: tag }, term_anatomies: { taxonomy: 'tag' }).count
  end

  def obtain_tag_title(id = nil)

  	segments = params[:slug].split('/')

    # get the taxonomy name and search the database for the record with this as its slug
    if !segments[2].blank?
      t =  Term.includes(:term_anatomy).where(:structured_url => "/" +  segments.drop(2).join('/'), term_anatomies: { taxonomy: 'tag' }).last
      t.name
    else
      nil
    end

  end

  def obtain_tag_description(id = nil)

  	segments = params[:slug].split('/')

    # get the taxonomy name and search the database for the record with this as its slug
    if !segments[2].blank?
      t =  Term.includes(:term_anatomy).where(:structured_url => "/" +  segments.drop(2).join('/'), term_anatomies: { taxonomy: 'tag' }).last
      t.description
    else
      nil
    end

  end

  def obtain_tag(check = nil) 
    if check.blank?
      Term.includes(:term_anatomy).where(:structured_url => "/" +  segments.drop(2).join('/'), term_anatomies: { taxonomy: 'tag' }).last
    else
      Term.includes(:term_anatomy).where("name = :p OR slug = :p2 OR id = :p3", { p: check, p2: check, p3: check.to_i }).where(term_anatomies: { taxonomy: 'tag' }).first
    end
  end

  # ARTICLE Functions #

  # TODO: --
  def obtain_next_article(id = nil)

  end

  # TODO: --
  def obtain_next_article_link(id = nil)

  end

  # TODO: --
  def obtain_previous_article(id = nil)

  end

  # TODO: --
  def obtain_previous_article_link(id = nil)

  end

  def obtain_article(check = nil)
    if check.blank?
      @content
    else
      Post.where("(post_title = :p OR post_slug = :p2 OR id = :p3) AND post_type = 'post' ", { p: check, p2: check, p3: check.to_i} ).first
    end
  end

  # TODO: --
  def obtain_article_field(field, id = nil)

  end

  # TODO: --
  def obtain_article_status(id = nil)

  end

  # TODO: this is rubbish!!
  def obtain_articles(ids = nil)
  	return Post.where(:id => ids, :post_type => 'post') if !ids.blank?
  	@content
  end

  def obtain_archives
    @content
  end

  # PAGE functions #

  # TODO: this sql can be refactored
  def obtain_page(id = nil)
    if check.blank?
      @content
    else
      Post.where("(post_title = :p OR post_slug = :p2 OR id = :p3) AND post_type = 'page' ", { p: check, p2: check, p3: check.to_i} )
    end
  end 

  def obtain_pages(ids = nil)
    return Post.where(:id => ids, :post_type => 'post') if !ids.blank?
    @content
  end


  # TODO: --
  def obtain_page_field(field, id = nil)

  end

  # CONDITIONAL functions #

  # HACK: Clean this code up
  # is_page?
  # Checks to see if given id or string is the current content record
  # Params:
  # +check+:: can be either ID, name, or slug

  def is_page?(check = nil)

    p = @content

    return true if p.post_type == 'page' && check.blank?

    check = check.to_s

    if defined? p.post_title
      if !p.blank?
        if check.nonnegative_float?
          if p.id == check.to_i
            return true
          else
            return false
          end
        else
          if p.post_title.downcase == check.downcase
            return true
          elsif p.post_slug == check
            return true
          else
            return false
          end
        end
      else
        return false
      end
    else
      return false
    end

  end


  # is_archive?
  # checks wether you are viewing an archive

  def is_archive?
    get_type_by_url == 'AR' ? true : false
  end

  # checks wether you are on the overall blog page

  def is_articles_home?
    get_type_by_url == 'C' ? true : false
  end

  # TODO: --
  def is_day_archive?
    segments = params[:slug].split('/')
    (get_type_by_url == 'AR' && !segments[3].blank?) ? true : false
  end

  # TODO: --
  def is_month_archive?
    segments = params[:slug].split('/')
    (get_type_by_url == 'AR' && !segments[2].blank? && segments[3].blank?) ? true : false
  end

  # TODO: --
  def is_year_archive?
    segments = params[:slug].split('/')
    (get_type_by_url == 'AR' && !segments[1].blank? && segments[2].blank? && segments[3].blank?) ? true : false
  end

  def obtain_archive_year
    str = ''
    segments = params[:slug].split('/')
    str = (get_date_name_by_number(segments[2].to_i) + ' ') if !segments[2].blank?
    str += segments[1]
  end
  
  # checks to see if the current page is the home page

  def is_homepage?
    return false if (!defined?(@content.length).blank? || @content.blank?)
    @content.id == Setting.get('home_page').to_i	? true : false
  end


  # is_article?
  # Params:
  # +check+:: check wether it is a certain category or not by ID, name, or slug

  def is_article?(check = nil)
    segments = params[:slug].split('/')
    if check.blank?
      Setting.get('articles_slug') == segments[0] ? true : false
    else
      if !defined?(@content.size).blank?
        return false
      end
      (Setting.get('articles_slug') == segments[0] && (@content.post_title == check || @content.id == check || @content.post_slug == check) ) ? true : false
    end
  end

  def is_search?
    (defined?(params[:search]) && !params[:search].blank?) ? true : false
  end

  # HACK: make sure this is checked the taxonomy as well
  # is_tag?
  # Params:
  # +check+:: check wether it is a certain tag or not. This is checked by the ID, name, or slug

  def is_tag?
  	segments = params[:slug].split('/')
    if check.blank?
      Setting.get('tag_slug') == segments[1] ? true : false
    else
      (Setting.get('tag_slug') == segments[1] && (Term.where(slug: segments[2]).first.name == check || Term.where(slug: segments[2]).first.id == check || Term.where(slug: segments[2]).first.slug == check) ) ? true : false
    end
  end

  # HACK: make sure this is checked the taxonomy as well
 	# is_category?
  # Params:
  # +check+:: check wether it is a certain category or not. This is checked by the ID, name, or slug

  def is_category?(check = nil)
  	segments = params[:slug].split('/')
    if check.blank?
      Setting.get('category_slug') == segments[1] ? true : false
    else
      (Setting.get('category_slug') == segments[1] && (Term.where(slug: segments[2]).first.name == check || Term.where(slug: segments[2]).first.id == check || Term.where(slug: segments[2]).first.slug == check) ) ? true : false
    end
  end


  # USER Functions #

  # TODO: --
  def obtain_user_profile(str)
    str = 
      if str.is_a?(Array)
        str
        { name: "Joe", email: "joe@example.com" }
        # hash_example = ["name = :name AND email = :email", { name: "Joe", email: "joe@example.com" }]
      else
        str.id
        check = ["id = :id", { :id => str.id }]
      end
    Admin.where(check)
  end

  # TODO: --
  def obtain_users(access = nil)
    admins = Admin.all
    admins = admins.where(:access => access) if !access.blank?

    admins
  end

	# TODO: --
  def obtain_user_field(field, id = nil)
    admins = 
      if id.blank?
        Admin.all
      else
        Admin.where(:id => id.to_i)
      end
    admins.pluck(field.to_sym)
  end

  # COMMENT Functions #

	# TODO: --
  def obtain_comment_author(comment_id)
    Comment.find_by_id(comment_id).author
  end

	# TODO: --
  def obtain_comment_date(comment_id, format = "%d-%m-%Y")
    comment = Comment.find_by_id(comment_id)
    comment = comment.submitted_on.strftime(format) if !comment.blank?
    comment
  end

	# TODO: --
  def obtain_comment_time(comment_id, format = "%H-%M-%S")
    comment = Comment.find_by_id(comment_id)
    comment = comment.submitted_on.strftime(format) if !comment.blank?
    comment
  end

  def obtain_comments(article_id = nil)

    if !article_id.nil?
      Comment.where(:post_id => article_id, :comment_approved => 'Y')
    else
      Comment.where(:post_id => @content.id, :comment_approved => 'Y')
    end

  end

  # gets the comment form from the theme folder and displays it.

  def obtain_comments_form

  	if Setting.get('article_comments') == 'Y'
      type = Setting.get('article_comment_type')
      render(:template =>"theme/#{current_theme}/comments_form." + get_theme_ext , :layout => nil, :locals => { type: type }).to_s
    end

  end

  # MISCELLANEOUS Functions #

	# TODO: what happens if content is an array?
  def obtain_id
  	@content.id
  end


  # TODO: --
  def obtain_the_author(id = nil)
    if id.blank?
    	Admin.find_by_id(@content.admin_id)
    else
    	Admin.includes(:posts).where(posts: { id: id }).first
    end
  end

	# TODO: --
  def obtain_the_authors_articles(id = nil)
  	if id.blank?
    	Post.where(:admin_id => @content.admin_id)
    else
    	Post.where(:admin_id => id)
    end
  end

  def obtain_the_content(id = nil)
  	post = 
  		if id.blank?
  			@content
  		else
  			Post.find(id.to_i)
  		end

  	render :inline => prep_content(post).html_safe
  end

  # display the title of the given post via the post parameter
  # Params:
  # +id+:: id of the post that you want to get the title for

  def obtain_the_title(id = nil)
  	post = 
  		if id.blank?
  			@content
  		else
  			Post.find(id.to_i)
  		end
  	render :inline => post.post_title
  end

  # return what type of taxonomy it is either - category or tag

  def obtain_term_type

    segments = params[:slug].split('/')

    if !segments[1].blank?
      term = TermAnatomy.where(:taxonomy => segments[1]).last
      term.taxonomy
    else
      nil
    end

  end

  def obtain_additional_data(key = nil, post = nil)
  	
  	post = 
  		if post.blank?
  			@content.post_additional_data
  		else
  			Post.find(post).post_additional_data
  		end

    data = @json.decode(post)
    if key.blank?
      data
    else
      data[key]
    end

  end

  def create_excerpt(content, length = 255, omission = '...')
    render :inline => truncate(content, :omission => omission, :length => length)
  end

  def obtain_record(check = nil)

    if check.blank?
      @content
    else
      Post.where( 'post_title = :p OR post_slug = :p2 OR id = :p3', { p: check, p2: check, p3: check.to_i} )
    end

  end

end
