module NewViewHelper

  # Returns the url of site appended with the given string
  # Params:
  # +str+:: the string to append onto the end of the site url

  def site_url(str = nil)
    url = Setting.get('site_url')
    str = str[1..-1] if !str.blank? && str[0,1] == '/'
    url = url + '/' if !url.blank? && url[-1, 1] != '/'
    "#{url}#{str}"
  end

  # GENERIC Functions #

  # INTERNAL FUNC - returns a hash of the posts but removes the autosave records 
  # Params:
  # +hash+:: a hash of post ActiveRecord::records

  def filter_results(hash)
    return [] if hash.blank?
    h = []
    hash.each do |k,v|
      h << k if k.post_type != 'autosave'
    end
    h
  end

  # returns the children records for the post. 
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)
  # +depth+:: The nest depth that you want to children to return
  # +orderby+:: What table column you want the posts to be ordered by

  def obtain_children(check = nil, orderby = 'post_title DESC')
    post = !check.blank? ? obtain_record(check) : @content
    return {} if post.blank?
    p = post.children
    p = p.arrange(:order => orderby.to_sym) if !orderby.blank?
    filter_results(p)
  end

  # returns a boolean as to wether the post has children
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it will use the @content variable

  def has_children?(check = nil)
    post = obtain_record(check)
    post.blank? ? false : post.has_children?
  end

  # returns a boolean as to wether the post has siblings
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it will use the @content variable

  def has_siblings?(check = nil)
    post = obtain_record(check)
    post.blank? ? false : post.has_siblings?
  end

  # returns the sibling records for the given post. 
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)
  # +depth+:: The nest depth that you want to children to return
  # +orderby+:: What table column you want the posts to be ordered by

  def obtain_siblings(check = nil, orderby = 'post_title DESC')
    post = obtain_record(check)
    return nil if post.blank?
    p = post.siblings
    p = p.arrange(:order => orderby.to_sym) if !orderby.blank?
    filter_results(p)
  end

  # returns the ancestors for the given post
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)

  def obtain_ancestor(check = nil, orderby = 'post_title DESC')
    post = obtain_record(check)
    return nil if post.blank?
    p = post.ancestors
    p = p.arrange(:order => orderby.to_sym) if !orderby.blank?
    filter_results(p)
  end

  # returns the link to the given post
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)
  # +render+:: wether to render the link straight on to the page or return the link in a string

  def obtain_the_permalink(check = nil, render_inline = true)
    site_url = Setting.get('site_url')
    post = obtain_record(check)

    return '' if post.blank?

    article_url = Setting.get('articles_slug')

    url =
      if post.post_type == 'post'
         site_url("#{article_url}#{post.structured_url}")
      else
        site_url("#{post.structured_url}")
      end

    if render_inline
      render :inline => url
    else
      url
    end

  end

  # returns a short extract from the post content
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)
  # +length+:: length of the string in characters
  # +omission+:: something to represent the omission of the content

  def obtain_the_excerpt(check = nil, length = 250, omission = '...')
  	post = obtain_record(check)
  	render :inline => truncate(post.post_content.to_s.gsub(/<[^>]*>/ui,'').html_safe, :omission => omission, :length => length) if !post.blank?
  end

  # returns a boolean as to wether the post has cover image
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)

  def has_cover_image?(check = nil)
  	post = obtain_record(check)
  	!post.blank? && !post.cover_image.blank? ? true : false
  end

  # returns the cover image of the given post
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)

  def obtain_cover_image(check = nil)
    post = obtain_record(check)
    return !post.blank? ? post.cover_image : ''
  end


  # returns the date of the given post
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)
  # +render+:: wether to render the link straight on to the page or return the link in a string
  # +format+:: the date format that you want the date to be provided in

  def obtain_the_date(check = nil, render_inline = true, format = "%d-%m-%Y")
    post = obtain_record(check)
    render :inline => post.post_date.strftime(format)
  end


  # CATEGORY functions #



  # returns an array of all the ids that are either in the system or attached to the given post
  # Params:
  # +articleid+:: ID of the article you want to get all the categories for - if this is nil it will return all the categories in the system

  def obtain_all_category_ids(articleid = nil)
    if article_id.blank?
      Term.joins(:term_anatomy).where(term_anatomies: { taxonomy: 'category' }).pluck(:id)
    else
      # get via the posts
      Term.joins(:term_anatomy, :posts).where(posts: {id: articleid}, term_anatomies: { taxonomy: 'category' }).pluck(:id)
    end
  end

  # returns all the categories in the system

  def obtain_categories
		Term::CATEGORIES
  end

  # returns the data for a certain category
  # Params:
  # +check+:: ID, slug, or name of the category - if this is nil it will return the current category you are in

  def obtain_category(check = nil)
    segments = []
    if check.blank?
      return nil if  params[:slug].blank?
      segments = params[:slug].split('/')
    end

    # get the taxonomy name and search the database for the record with this as its slug
    t = obtain_term_check(check, segments, 'category')
    t if !t.blank?
  end

  # returns the title to the given category
  # Params:
  # +check+:: ID, slug, or name of the category - if this is nil it will return the current category you are in

  def obtain_category_name(check = nil)
    segments = []
    if check.blank?
      return nil if  params[:slug].blank?
      segments = params[:slug].split('/')
    end

    # get the taxonomy name and search the database for the record with this as its slug
    t = obtain_term_check(check, segments, 'category')
    t.name if !t.blank?

  end

  # returns the link to the given category
  # Params:
  # +check+:: ID, slug, or name of the category - if this is nil it will return the current category you are in

  def obtain_category_link(check = nil)
    segments = []
    if check.blank?
      return nil if  params[:slug].blank?
      segments = params[:slug].split('/')
    end

    # get the taxonomy name and search the database for the record with this as its slug
    t = obtain_term_check(check, segments, 'category')
    
    (Setting.get('articles_slug') + '/' + Setting.get('category_slug') + t.structured_url) if !t.blank?
  end

  # returns the link to the given category
  # Params:
  # +check+:: ID, slug, or name of the category - if this is nil it will return the current category you are in

  def obtain_category_description(check = nil)
    segments = []
  	if check.blank?
      return nil if  params[:slug].blank?
      segments = params[:slug].split('/')
    end

    # get the taxonomy name and search the database for the record with this as its slug
    t = obtain_term_check(check, segments, 'category')
    t.description if !t.blank?

  end

  # returns a boolean as to wether the given post is in the given category
  # Params:
  # +categoryid+:: ID of the category that you want to check
  # +postid+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)

  def in_category?(categoryid, postid = nil)
  	post = obtain_record(postid)
    return false if post.blank?
  	!Post.includes(:terms => :term_anatomy).where(id: post.id, terms: { id: categoryid }, term_anatomies: { taxonomy: 'category' }).blank?
  end

  def obtain_category_cover_image(check = nil)
    cat = obtain_term_check(check, nil, 'category')
    return !cat.blank? ? cat.cover_image : ''
  end

  # Returns a list of the categories
  # Params:
  # +sub_only+:: show only the sub categories of the current category

  def obtain_category_list(sub_only = false)

    segments = params[:slug].split('/')
    category_url = Setting.get('category_slug')
    # variables and data

    # check to see if we are on the category term type, that we just want the sub cateogries and the segments actually exist
    if segments[1] == category_url && sub_only && !segments[2].blank?

      # get the current category
      parent_term = Term.where(term_anatomies: {taxonomy: 'category'}, :structured_url => "/" +  segments.drop(2).join('/')).includes(:term_anatomy).first

      terms =
        if !parent_term.blank?
          # get all the records with the current category as its parent
          Term.where(:parent_id => parent_term.id)
        else
          []
        end

    else
      # get all the categories
      terms = Term.where(term_anatomies: {taxonomy: 'category'}, :parent_id => nil).includes(:term_anatomy)
    end

    li_loop_for_terms(terms.arrange, category_url)

  end


  # TAG Functions #


  # returns the link to the given tag
  # Params:
  # +check+:: ID, slug, or name of the tag - if this is nil it will return the current tag you are on

  def obtain_tag_link(check = nil)
    segments = []
    if check.blank?
      return nil if  params[:slug].blank?
      segments = params[:slug].split('/')
    end

    t = obtain_term_check(check, segments, 'tag')
    
    (Setting.get('articles_slug') + '/' + Setting.get('tag_slug') + t.structured_url) if !t.blank?
  end

  # returns all the tags in the system

  def obtain_tags
  	Term::TAGS
  end

  # returns a boolean as to wether the given post has the give tag attached to it
  # Params:
  # +categoryid+:: ID of the tag that you want to check
  # +postid+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)

  def has_tag?(tagid, postid = nil)
  	post = obtain_record(postid)
    return false if post.blank?
    !Post.includes(:terms => :term_anatomy).where(id: post.id, terms: { id: tagid }, term_anatomies: { taxonomy: 'tag' }).blank?
  end

  # returns the title to the given tag
  # Params:
  # +check+:: ID, slug, or name of the tag - if this is nil it will return the current tag you are on

  def obtain_tag_name(check = nil)
    segments = []
  	if check.blank?
      return nil if  params[:slug].blank?
      segments = params[:slug].split('/')
    end

    # get the taxonomy name and search the database for the record with this as its slug
    t = obtain_term_check(check, segments, 'tag')
    t.name if !t.blank?

  end

  # returns the description to the given tag
  # Params:
  # +check+:: ID, slug, or name of the tag - if this is nil it will return the current tag you are on

  def obtain_tag_description(check = nil)
    segments = []
  	if check.blank?
      return nil if  params[:slug].blank?
      segments = params[:slug].split('/')
    end

    # get the taxonomy name and search the database for the record with this as its slug
    t = obtain_term_check(check, segments, 'tag')
    t.description if !t.blank?

  end

  # returns all the data for the given tag
  # Params:
  # +check+:: ID, slug, or name of the tag - if this is nil it will return the current tag you are on

  def obtain_tag(check = nil) 
    segments = []
    if check.blank?
      return nil if params[:slug].blank?
      segments = params[:slug].split('/')
    end

    # get the taxonomy name and search the database for the record with this as its slug
    t = obtain_term_check(check, segments, 'tag')
    t if !t.blank?

  end

  # returns the cover image of the given tag
  # Params:
  # +check+:: ID, slug, or name - if this is nil it will slug to work out the tag the system is currently viewing

  def obtain_tag_cover_image(check = nil)
    tag = obtain_term_check(check, nil, 'tag')
    return !tag.blank? ? tag.cover_image : ''
  end

  # returns the array of records to display

  def obtain_category_data
    @content
  end

  # returns either a list or a tag cloud of the tags - this shows ALL of the tags
  # Params:
  # +type+:: string or list style
  # +sub_only+:: show only the sub tags of the current category

  def obtain_tag_cloud(type, sub_only = false)

    article_url = Setting.get('articles_slug')
    tag_url = Setting.get('tag_slug')
    segments = params[:slug].split('/')

    if type == 'string'

      terms = @content.terms.where(term_anatomies: {taxonomy: 'tag'}).includes(:term_anatomy)
      return terms.all.map do |u|
        url = article_url + '/' + tag_url + u.structured_url
        "<a href='#{site_url(url)}'>" + u.name + "</a>"
      end.join(', ').html_safe

    elsif type == 'list'

      # check to see if we are on the tag term type, that we just want the sub tags and the segments actually exist
      if segments[1] == tag_url && sub_only && !segments[2].blank?

        # get the current tag record
        parent_term = Term.where(term_anatomies: {taxonomy: 'tag'}, :structured_url => "/" +  segments.drop(2).join('/')).includes(:term_anatomy).first

        if !parent_term.blank?
          # get all the records with the current tag as its parent
          terms = Term.where(:parent_id => parent_term.id)
        else
          terms = []
        end

      else
        # get all the tags
        terms = Term.where(term_anatomies: {taxonomy: 'tag'}, :parent_id => nil).includes(:term_anatomy)
      end
      # if you want a list style
      li_loop_for_terms(terms.arrange, tag_url)

    end

  end


  # ARTICLE Functions #


  # returns all the data for the given article
  # Params:
  # +check+:: ID, slug, or name of the article - if this is nil it will use the @content variable (the current page)

  def obtain_article(check = nil)
    if check.blank? && !@content.blank? && @content[0].blank?
      @content
    else
      obtain_record(check, 'post')
    end
  end

  # returns the value of the given field for the given article
  # Params:
  # +field+:: admin_id, post_content, post_date, post_name, parent_id, post_slug, sort_order, post_visible, post_additional_data, post_status, post_title, cover_image, post_template, post_type, disabled, post_seo_title, post_seo_description, post_seo_keywords, post_seo_is_disabled, post_seo_no_follow, post_seo_no_index
  # +check+:: ID, slug, or name of the article - if this is nil it will use the @content variable (the current page)

  def obtain_article_field(field, check = nil)
    article = 
      if check.blank? && !@content.blank? && @content[0].blank?
        @content
      else
        obtain_record(check, 'post')
      end
    !article.blank? && article.has_attribute?(field) ? article[field.to_sym] : nil
  end

  # returns the status of the given article
  # Params:
  # +check+:: ID, slug, or name of the article - if this is nil it will use the @content variable (the current page)

  def obtain_article_status(check = nil)
    article = 
      if check.blank? && !@content.blank? && @content[0].blank?
        @content
      else
        obtain_record(check, 'page')
      end
    !article.blank? && article.has_attribute?('post_status') ? article.post_status : nil
  end

  # returns all the data of the given articles 
  # Params:
  # +ids+:: an array of article ids that you want to obtain the data for - if this is nil it will simply return the @content variable data in an array format
  # +orderby+:: What table column you want the posts to be ordered by, this is a sql string format

  def obtain_articles(ids = nil, orderby = "post_title DESC")
    return Post.where(:id => ids, :post_type => 'post').order(orderby) if !ids.blank?
    return [@content] if !@content[0].blank?
    return Post.where(:post_type => 'post', :post_status => 'Published').order(orderby)
  end

  # returns all the archive records for the archive you are currently on 

  def obtain_archive_data
    @content
  end

  # Returns a list of the archives
  # Params:
  # +type+:: has to be either Y (year) or M (month)

  def obtain_archive_list(type, blockbydate = nil)

    article_url = Setting.get('articles_slug')
    category_url = Setting.get('category_slug')
    h = {}

    # if year
    if type == 'Y'

      # variables and data
      p = Post.where(:post_type => 'post', :post_status => 'Published', :disabled => 'N').uniq.pluck("EXTRACT(year FROM post_date)")

      if !p.blank?
        p.each do |f|
          h["#{article_url}/#{f}"] = f
        end
      end

      # if month
    elsif type == 'M'

      # variables and data
      p = Post.where("(post_type = 'post' AND post_status = 'Published' AND disabled = 'N') AND post_date <= CURRENT_TIMESTAMP").uniq.pluck("EXTRACT(year FROM post_date)")
      lp = {}

      if !p.blank?
        p.each do |f|
          lp["#{f}"] = Post.where("EXTRACT(year from post_date) = #{f}  AND (post_type = 'post' AND disabled = 'N' AND post_status = 'Published' AND post_date <= CURRENT_TIMESTAMP)").uniq.pluck("EXTRACT(MONTH FROM post_date)")
        end
      end

      if !lp.blank?

        lp.each do |k, i|

          if blockbydate
            h["#{article_url}/#{k.to_i}"] = k.to_i
          end

          i.each do |nm|
            h["#{article_url}/#{k.to_i}/#{nm.to_i}"] = "#{get_date_name_by_number(nm.to_i)} - #{k.to_i}"
          end

        end

      end

    end

    li_loop(h)

  end


  # returns the lastest article. By default this is 1 but you can get more than one if you want.
  # Params:
  # +how_many+:: how many records you want to return

  def obtain_latest_article(how_many = 1)
    Post.where("post_type ='post' AND disabled = 'N' AND post_status = 'Published' AND (post_date <= CURRENT_TIMESTAMP)").order('post_date DESC').limit(how_many)
  end


  # PAGE functions #


  # returns all the data for the given page
  # Params:
  # +check+:: ID, slug, or name of the article - if this is nil it will use the @content variable (the current page)

  def obtain_page(check = nil)
    if check.blank? && !@content.blank? && @content[0].blank?
      @content
    else
      obtain_record(check, 'page')
    end
  end 

  # returns all the data of the given pages 
  # Params:
  # +ids+:: an array of article ids that you want to obtain the data for - if this is nil it will simply return the @content variable data in an array format
  # +orderby+:: What table column you want the posts to be ordered by, this is a sql string format

  def obtain_pages(ids = nil, orderby = "post_title DESC")
    return Post.where(:id => ids, :post_type => 'page').order(orderby) if !ids.blank?
    return [@content] if !@content[0].blank?
    return Post.where(:post_type => 'page', :post_status => 'Published').order(orderby)
  end

  # returns the value of the given field for the given page
  # Params:
  # +field+:: admin_id, post_content, post_date, post_name, parent_id, post_slug, sort_order, post_visible, post_additional_data, post_status, post_title, cover_image, post_template, post_type, disabled, post_seo_title, post_seo_description, post_seo_keywords, post_seo_is_disabled, post_seo_no_follow, post_seo_no_index
  # +check+:: ID, slug, or name of the article - if this is nil it will use the @content variable (the current page)

  def obtain_page_field(field, check = nil)
    page = 
      if check.blank? && !@content.blank? && @content[0].blank?
        @content
      else
        obtain_record(check, 'page')
      end
    !page.blank? && page.has_attribute?(field) ? page[field.to_sym] : nil
  end

  # CONDITIONAL functions #


  # TODO: Clean this code up
  # returns a boolean as to wether the given page/post is a page
  # Params:
  # +check+:: ID of the page

  def is_page?(check = nil)

    return false if @content.blank? || !@content[0].blank?
    return true if @content.post_type == 'page' && check.blank?
    return true if @content.id == check.to_i
    return false

  end

  # returns a boolean as to wether the current view is the blog homepage

  def is_articles_home?
    get_type_by_url == 'C' ? true : false
  end
 
  # returns a boolean as to whether the current view is an archive

  def is_archive?
    get_type_by_url == 'AR' ? true : false
  end

  # returns a boolean as to whether the current view is a day archive

  def is_day_archive?
    segments = params[:slug].split('/')
    (get_type_by_url == 'AR' && !segments[3].blank?) ? true : false
  end

  # returns a boolean as to whether the current view is a month archive

  def is_month_archive?
    segments = params[:slug].split('/')
    (get_type_by_url == 'AR' && !segments[2].blank? && segments[3].blank?) ? true : false
  end

  # returns a boolean as to whether the current view is a year archive

  def is_year_archive?
    segments = params[:slug].split('/')
    (get_type_by_url == 'AR' && !segments[1].blank? && segments[2].blank? && segments[3].blank?) ? true : false
  end

  # returns the that year/month/day of the current archive 

  def obtain_archive_year

    if get_type_by_url == 'AR'
      segments = params[:slug].split('/')
      str = ''
      str = (get_date_name_by_number(segments[2].to_i) + ' ') if !segments[2].blank?
      str += segments[1]
    end

  end
  
  # returns a boolean as to whether the current view is the homepage

  def is_homepage?
    return false if (!defined?(@content.length).blank? || @content.blank?)
    @content.id == Setting.get('home_page').to_i	? true : false
  end


  # returns a boolean as to whether the current page is either an article or whether it is the given article provided by the check variable
  # Params:
  # +check+:: ID, slug, or name of the article you want to check - if this is nil it will just return if the current view is an article or not

  def is_article?(check = nil)
    return false if params[:slug].blank?
    segments = params[:slug].split('/')
    if check.blank?
      (segments[0] == Setting.get('articles_slug') && !segments[1].blank? && segments[1] != Setting.get('tag_slug') && segments[1] != Setting.get('category_slug') && @content.class != ActiveRecord::Relation) ? true : false
    else
      if !defined?(@content.size).blank?
        return false
      end
      (Setting.get('articles_slug') == segments[0] && (@content.post_title == check || @content.id == check || @content.post_slug == check) ) ? true : false
    end
  end

  # returns a boolean as to whether the current view is a search view or not

  def is_search?
    (defined?(params[:search]) && !params[:search].blank?) ? true : false
  end

  # returns a boolean as to whether the current page is either an tag view or whether it is the given tag provided by the check variable
  # Params:
  # +check+:: ID, slug, or name of the tag - if this is nil it will just check to see if the current view is a tag view

  def is_tag?(check = nil)
    return false if params[:slug].blank?
  	segments = params[:slug].split('/')
    if check.blank?
      Setting.get('tag_slug') == segments[1] ? true : false 
    else
      term = obtain_term(segments)
      term_check('tag_slug', segments)
    end
  end

  # returns a boolean as to whether the current page is either an category view or whether it is the given category provided by the check variable
  # Params:
  # +check+:: ID, slug, or name of the category - if this is nil it will just check to see if the current view is a category view

  def is_category?(check = nil)
    return false if params[:slug].blank?
  	segments = params[:slug].split('/')
    if check.blank?
      Setting.get('category_slug') == segments[1] ? true : false
    else
      term = obtain_term(segments)
      term_check('category_slug', segments)
    end
  end


  # USER Functions #

  # returns all the data for the given user
  # Params:
  # +check+:: ID, email, or username of the user

  def obtain_user_profile(check = nil)
    return nil if check.blank?
    obtain_users(check)
  end

  # returns all the users
  # Params:
  # +access+:: restrict the returned data to show only certain access levels access level - the options can be found in the admin panel

  def obtain_users(access = nil)
    admins = obtain_users
    if access.is_a?(Array)
      admins = admins.where(:id => access) if !access.blank?
    else
      admins = admins.where(:access_level => access) if !access.blank?
    end

    admins
  end

  # returns certian field of the given user
  # Params:
  # +field+:: the field that you want to return - id, email, first_name, last_name, username, access_level, avatar, cover_picture, overlord
  # +check+:: ID, email, or username of the user - if this is nil it will user the user that wrote the current article/page

  def obtain_user_field(field, check = nil)
    admin = 
      if !check.blank?
        obtain_users(check)
      else
        return nil if @content.blank? || !@content[0].blank?
        Admin.find_by_id(@content.admin_id)
      end
    return '' if admin.blank?
    admin.has_attribute?(field) ? admin[field].to_s : ''
  end



  # COMMENT Functions #

  # returns the author name of the given comment
  # Params:
  # +comment_id+:: ID of the comment

  def obtain_comment_author(comment_id = nil)
    return nil if comment_id.blank?
    comm = Comment.find_by_id(comment_id)
    comm.author if !comm.blank?
  end

  # returns the date of the given comment
  # Params:
  # +comment_id+:: ID of the comment
  # +format+:: the format that you want the date to be returned in

  def obtain_comment_date(comment_id = nil, format = "%d-%m-%Y")
    return nil if comment_id.blank?
    comment = Comment.find_by_id(comment_id)
    comment = comment.submitted_on.strftime(format) if !comment.blank?
    comment if !comment.blank?
  end

  # returns the time of the given comment
  # Params:
  # +comment_id+:: ID of the comment
  # +format+:: the format that you want the time to be returned in

  def obtain_comment_time(comment_id = nil, format = "%H:%M:%S")
    return nil if comment_id.blank?
    comment = Comment.find_by_id(comment_id)
    comment = comment.submitted_on.strftime(format) if !comment.blank?
    comment if !comment.blank?
  end

  # returns the comments for the given article
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it return the comments for the the @content variable (the current page)

  def obtain_comments(check = nil)

    if check.blank? && !@content.blank? && @content[0].blank?
      Comment.where(:post_id => @content.id, :comment_approved => 'Y')
    else
      Comment.where(:post_id => check, :comment_approved => 'Y')
    end

  end

  # returns the comment form that is created in the theme folder. 

  def obtain_comments_form

  	if Setting.get('article_comments') == 'Y'
      type = Setting.get('article_comment_type')
      @new_comment = Comment.new
      if File.exists?("#{Rails.root}/app/views/theme/#{current_theme}/comments_form." + get_theme_ext)
        render(:template => "theme/#{current_theme}/comments_form." + get_theme_ext , :layout => nil, :locals => { type: type }).to_s
      else
        render :inline => 'comments_form.html.erb does not exist in current theme'
      end
    end

  end

  # Easy to understand function for getting the search form.
  # this is created and displayed from the theme.

  def obtain_search_form
    if File.exists?("#{Rails.root}/app/views/theme/#{current_theme}/search_form." + get_theme_ext)
      render :template => "theme/#{current_theme}/search_form." + get_theme_ext 
    else
      render :inline => 'search_form.html.erb does not exist in current theme'
    end
  end

  # MISCELLANEOUS Functions #

  # returns the ID for the current view that you are on

  def obtain_id
  	@content.id if !@content.blank? && @content[0].blank?
  end

  # returns the author of the current article/page
  # Params:
  # +postid+:: ID of the post/page that you want o obtain the author for

  def obtain_the_author(postid = nil)
    if id.blank?
      return nil if @content.blank? || !@content[0].blank?
    	obtain_users(@content.admin_id)
    else
    	Admin.joins(:posts).select(user_select_fields).where(posts: { id: postid }).first
    end
  end

  # returns all of the articles that the user has created
  # Params:
  # +id+:: ID of the user that you want to get all the records for

  def obtain_the_authors_articles(id = nil)
    return nil if id.blank? && (@content.blank? || !@content[0].blank?)
    check = 
      if id.blank?
      	@content.admin_id
      else
        id
      end
    Post.where(:admin_id => check)
  end

  # returns the content for the given post/page
  # Params:
  # +id+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)

  def obtain_the_content(check = nil)
  	post = obtain_record(check)
  	render :inline => prep_content(post).html_safe if !post.blank?
  end

  # returns the title for the given post/page
  # Params:
  # +id+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)

  def obtain_the_title(check = nil)
  	post = obtain_record(check)
  	render :inline => post.post_title if !post.blank?
  end

  # return what type of taxonomy it is either - category or tag

  def obtain_term_type
    return nil if params[:slug].blank?
    segments = params[:slug].split('/')

    if !segments[1].blank?
      term = TermAnatomy.where(:taxonomy => segments[1]).last
      term.taxonomy if !term.blank?
    else
      nil
    end

  end

  # returns the title to the given term, the differnece between obtain_tag_name/obtain_category_name is that this will return the title if you do not know what term type you are on.
  # Params:
  # +check+:: ID, slug, or name of the category - if this is nil it will return the current category you are in

  def obtain_term_title(check = nil)
    segments = []
    if check.blank?
      return nil if  params[:slug].blank?
      segments = params[:slug].split('/')
    end

    # get the taxonomy name and search the database for the record with this as its slug
    t = obtain_term_check(check, segments)
    t.name if !t.blank?

  end

  # returns the additional data record
  # Params:
  # +key+:: the key to the additional data that you want to return - if this is nil it will return all of the additional data for the given record
  # +check+:: ID, post_slug, or post_title of the post record - if this is nil it will use the @content variable (the current page)

  def obtain_additional_data(key = nil, check = nil)

    if check.blank?
      return nil if @content.blank? || !@content[0].blank?
    end
  	
  	post = 
  		if check.blank?
  			@content.post_additional_data
  		else
  			obtain_record(check).post_additional_data
  		end

    return nil if post.blank?

    data = @json.decode(post)
    if key.blank?
      data
    else
      data[key]
    end

  end

  # returns a short extract of the given content
  # Params:
  # +content+:: the content 
  # +length+:: length of the string in characters
  # +omission+:: something to represent the omission of the content

  def create_excerpt(content = '', length = 255, omission = '...')
    render :inline => truncate(content, :omission => omission, :length => length)
  end

  # returns a full post record (this is used mainly internally to retrieve the data for other functions) 
  # Params:
  # +check+:: ID, post_slug, or post_title of the post record - if this is nil it will use the @content variable (the current page)

  def obtain_record(check = nil, type = nil)
    
    return check if check.is_a?(ActiveRecord::Base)

    if check.blank? 
      return nil if @content.blank? || !@content[0].blank?
      @content
    else
      records = Post.where( 'post_title = :p OR post_slug = :p2 OR id = :p3', { p: check.to_s, p2: check.to_s, p3: check.to_i} )
      if !type.blank?
        records = records.where("post_type = :p4", {p4: type})
      end
      records.first
    end

  end

  # returns a full term record (this is used mainly internally to retrieve the data for above functions) 
  # Params:
  # +segments+:: URL segments

  def obtain_term(segments)
    Term.where(structured_url: ('/' + segments[2..-1].join('/')))
  end

  # returns a full tag record (this is used mainly internally to retrieve the data for above functions) 
  # Params:
  # +check+:: ID, slug, or name of the term record - if this is nil it will use the url to work out the current tag that you are viewing
  # +segments+:: pass in the segments of the url
  # +type+:: wether you want to check the term type against tag or category

  def obtain_term_check(check = nil, segments = nil, type = nil)
    term =
      if check.blank? && !segments.blank? && !segments[2].blank?
        Term.includes(:term_anatomy).where(:structured_url => "/" +  segments.drop(2).join('/')).first
      else
        Term.includes(:term_anatomy).where("name = :p OR slug = :p2 OR terms.id = :p3", { p: check.to_s, p2: check.to_s, p3: check.to_i })
      end

    term = term.where(term_anatomies: { taxonomy: type }) if !type.blank?

    term

  end

  # returns wether the current url is the given term type
  # Params:
  # +type+:: the type of term you want to check against
  # +segments+:: pass in the segments of the url

  def term_check(type, segments) 
    (Setting.get(type) == segments[1] && (term.first.name == check || term.first.id == check || term.first.slug == check) ) ? true : false
  end

  # returns the users (this is used mainly internally to retrieve the data for above functions) 
  # Params:
  # +check+:: ID, email, or username of the user record - if this is nil it will return all users

  def obtain_users(check = nil)
    admin = Admin.select(user_select_fields)
    admin = admin.where( 'id = :p OR email = :p2 OR username = :p3', { p: check.to_i, p2: check.to_s, p3: check.to_s} ).first if !check.blank?
    admin
  end

  # returns the fields that the user will be allowed to access when using the user functions (this is used mainly internally to retrieve the data for above functions) 

  def user_select_fields
    return 'admins.id, email, first_name, last_name, username, access_level, avatar, cover_picture, overlord'
  end

end
