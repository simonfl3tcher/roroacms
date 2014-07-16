module NewViewHelper

  # The view helper contains all of the functions that the views
  # will use in order to display the contents of either the content
  # or format other data



  # GENERIC Functions #


  # returns the children records for the post. 
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)
  # +depth+:: The nest depth that you want to children to return
  # +orderby+:: What table column you want the posts to be ordered by

  def obtain_children(check = nil, depth = 10000000, orderby = 'post_title')
    post = obtain_record(check)
    return {} if post.blank?
    p = post.children
    p = p.arrange(:order => orderby.to_sym) if !orderby.blank?
    p
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

  def obtain_siblings(check = nil, orderby = 'post_title')
    post = obtain_record(check)
    return nil if post.blank?
    p = post.siblings
    p = p.arrange(:order => orderby.to_sym) if !orderby.blank?
    p
  end

  # returns the ancestors for the given post
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)

  def obtain_ancestor(check = nil)
    post = obtain_record(check)
    return nil if post.blank?
    p = post.ancestors
    p = p.arrange(:order => orderby.to_sym) if !orderby.blank?
    p
  end

  # returns the link to the given post
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)
  # +render+:: wether to render the link straight on to the page or return the link in a string

  def obtain_permalink(check = nil, render = true)
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

    return render ? render :inline => url  : url

  end

  # returns a short extract from the post content
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)
  # +length+:: length of the string in characters
  # +omission+:: something to represent the omission of the content

  def obtain_excerpt(check = nil, length = 250, omission = '...')
  	
  	post = obtain_record(check)
  	render :inline => truncate(post.post_content.to_s.gsub(/<[^>]*>/ui,'').html_safe, :omission => omission, :length => length) if !post.blank?
  
  end

  # returns a boolean as to wether the post has cover image
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)

  def has_cover_image?(check = nil)
  	post = obtain_record(check)
  	!post.blank? && !post.post_image.blank? ? true : false
  end

  # returns the cover image of the given post
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)

  def obtain_cover_image(check = nil)
    post = obtain_record(check)
    return !post.blank? ? post.post_image : ''
  end


  # returns the date of the given post
  # Params:
  # +check+:: ID, post_slug, or post_title - if this is nil it will use the @content variable (the current page)
  # +render+:: wether to render the link straight on to the page or return the link in a string
  # +format+:: the date format that you want the date to be provided in

  def obtain_the_date(check = nil, render = true, format = "%d-%m-%Y")
    post = obtain_record(check)
    render :inline => post.post_date.strftime(format) if !post.blank?
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
    
    if check.blank?
      return nil if  params[:slug].blank?
      segments = params[:slug].split('/')
    end

    # get the taxonomy name and search the database for the record with this as its slug
    t = 
      if check.blank? && !segments[2].blank?
        Term.includes(:term_anatomy).where(:structured_url => "/" +  segments.drop(2).join('/'), term_anatomies: { taxonomy: 'category' }).last
      else
        Term.includes(:term_anatomy).where("name = :p OR slug = :p2 OR terms.id = :p3", { p: check.to_s, p2: check.to_s, p3: check.to_i }).where(term_anatomies: { taxonomy: 'category' }).first
      end
    t if !t.blank?
  end

  # returns the title to the given category
  # Params:
  # +check+:: ID, slug, or name of the category - if this is nil it will return the current category you are in

  def obtain_category_title(check = nil)
    if check.blank?
      return nil if  params[:slug].blank?
      segments = params[:slug].split('/')
    end

    # get the taxonomy name and search the database for the record with this as its slug
    t = 
      if check.blank? && !segments[2].blank?
        Term.includes(:term_anatomy).where(:structured_url => "/" +  segments.drop(2).join('/'), term_anatomies: { taxonomy: 'category' }).last
      else
        Term.includes(:term_anatomy).where("name = :p OR slug = :p2 OR terms.id = :p3", { p: check.to_s, p2: check.to_s, p3: check.to_i }).where(term_anatomies: { taxonomy: 'category' }).first
      end
    t.name if !t.blank?

  end

  # returns the link to the given category
  # Params:
  # +check+:: ID, slug, or name of the category - if this is nil it will return the current category you are in

  def obtain_category_link(check = nil)

    if check.blank?
      return nil if  params[:slug].blank?
      segments = params[:slug].split('/')
    end

    # get the taxonomy name and search the database for the record with this as its slug
    t =
      if check.blank? && !segments[2].blank?
        Term.includes(:term_anatomy).where(:structured_url => "/" +  segments.drop(2).join('/'), term_anatomies: { taxonomy: 'category' }).last
      else
        Term.includes(:term_anatomy).where("name = :p OR slug = :p2 OR terms.id = :p3", { p: check.to_s, p2: check.to_s, p3: check.to_i }).where(term_anatomies: { taxonomy: 'category' }).first
      end
    
    Setting.get('articles_slug') + '/' + Setting.get('category_slug') + t.structured_url
  end

  # returns the link to the given category
  # Params:
  # +check+:: ID, slug, or name of the category - if this is nil it will return the current category you are in

  def obtain_category_description(check = nil)

  	if check.blank?
      return nil if  params[:slug].blank?
      segments = params[:slug].split('/')
    end

    # get the taxonomy name and search the database for the record with this as its slug
    t = 
      if check.blank? && !segments[2].blank?
        Term.includes(:term_anatomy).where(:structured_url => "/" +  segments.drop(2).join('/'), term_anatomies: { taxonomy: 'category' }).last
      else
        Term.includes(:term_anatomy).where("name = :p OR slug = :p2 OR terms.id = :p3", { p: check.to_s, p2: check.to_s, p3: check.to_i }).where(term_anatomies: { taxonomy: 'category' }).first
      end
    t.description

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



  # TAG Functions #


  # returns the link to the given tag
  # Params:
  # +check+:: ID, slug, or name of the tag - if this is nil it will return the current tag you are on

  def obtain_tag_link(check = nil)
    
    if check.blank?
      return nil if  params[:slug].blank?
      segments = params[:slug].split('/')
    end

    t =
      if check.blank? && !segments[2].blank?
        Term.includes(:term_anatomy).where(:structured_url => "/" +  segments.drop(2).join('/'), term_anatomies: { taxonomy: 'tag' }).last
      else
        Term.includes(:term_anatomy).where("name = :p OR slug = :p2 OR terms.id = :p3", { p: check.to_s, p2: check.to_s, p3: check.to_i }).where(term_anatomies: { taxonomy: 'tag' }).first
      end
    
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

  def obtain_tag_title(check = nil)

  	if check.blank?
      return nil if  params[:slug].blank?
      segments = params[:slug].split('/')
    end

    # get the taxonomy name and search the database for the record with this as its slug
    t = 
      if check.blank? && !segments[2].blank?
        Term.includes(:term_anatomy).where(:structured_url => "/" +  segments.drop(2).join('/'), term_anatomies: { taxonomy: 'tag' }).last
      else
        Term.includes(:term_anatomy).where("name = :p OR slug = :p2 OR terms.id = :p3", { p: check.to_s, p2: check.to_s, p3: check.to_i }).where(term_anatomies: { taxonomy: 'tag' }).first
      end
    t.name if !t.blank?

  end

  # returns the description to the given tag
  # Params:
  # +check+:: ID, slug, or name of the tag - if this is nil it will return the current tag you are on

  def obtain_tag_description(check = nil)

  	if check.blank?
      return nil if  params[:slug].blank?
      segments = params[:slug].split('/')
    end

    # get the taxonomy name and search the database for the record with this as its slug
    t = 
      if !check.blank? && !segments[2].blank?
        Term.includes(:term_anatomy).where(:structured_url => "/" +  segments.drop(2).join('/'), term_anatomies: { taxonomy: 'tag' }).last
      else
        Term.includes(:term_anatomy).where("name = :p OR slug = :p2 OR terms.id = :p3", { p: check.to_s, p2: check.to_s, p3: check.to_i }).where(term_anatomies: { taxonomy: 'tag' }).first
      end
    t.description if !t.blank?

  end

  # returns all the data for the given tag
  # Params:
  # +check+:: ID, slug, or name of the tag - if this is nil it will return the current tag you are on

  def obtain_tag(check = nil) 

    if check.blank?
      return nil if  params[:slug].blank?
      segments = params[:slug].split('/')
    end

    # get the taxonomy name and search the database for the record with this as its slug
    t = 
      if check.blank? && !segments[2].blank?
        Term.includes(:term_anatomy).where(:structured_url => "/" +  segments.drop(2).join('/'), term_anatomies: { taxonomy: 'tag' }).last
      else
        Term.includes(:term_anatomy).where("name = :p OR slug = :p2 OR terms.id = :p3", { p: check.to_s, p2: check.to_s, p3: check.to_i }).where(term_anatomies: { taxonomy: 'tag' }).first
      end
    t if !t.blank?

  end



  # ARTICLE Functions #


  # returns all the data for the given article
  # Params:
  # +check+:: ID, slug, or name of the article - if this is nil it will use the @content variable (the current page)

  def obtain_article(check = nil)
    if check.blank? && !@content.blank? && @content[0].blank?
      @content
    else
      Post.where("(post_title = :p OR post_slug = :p2 OR id = :p3) AND post_type = 'post' ", { p: check.to_s, p2: check.to_s, p3: check.to_i} ).first
    end
  end

  # returns the value of the given field for the given article
  # Params:
  # +field+:: admin_id, post_content, post_date, post_name, parent_id, post_slug, sort_order, post_visible, post_additional_data, post_status, post_title, post_image, post_template, post_type, disabled, post_seo_title, post_seo_description, post_seo_keywords, post_seo_is_disabled, post_seo_no_follow, post_seo_no_index
  # +check+:: ID, slug, or name of the article - if this is nil it will use the @content variable (the current page)

  def obtain_article_field(field, check = nil)
    article = 
      if check.blank? && !@content.blank? && @content[0].blank?
        @content
      else
        Post.where("(post_title = :p OR post_slug = :p2 OR id = :p3) AND post_type = 'post' ", { p: check.to_s, p2: check.to_s, p3: check.to_i} ).first
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
        Post.where("(post_title = :p OR post_slug = :p2 OR id = :p3) AND post_type = 'post' ", { p: check.to_s, p2: check.to_s, p3: check.to_i} ).first
      end
    !article.blank? && article.has_attribute?('post_status') ? article.post_status : nil
  end

  # TODO: Clean this code up like the below
  # returns all the data of the given articles 
  # Params:
  # +ids+:: an array of article ids that you want to obtain the data for - if this is nil it will simply return the @content variable data in an array format
  # +orderby+:: What table column you want the posts to be ordered by, this is a sql string format

  def obtain_articles(ids = nil, orderby = "post_title DESC")
    ret = 
      if !ids.blank?
        Post.where(:id => ids, :post_type => 'post').order(orderby)
      elsif !@content[0].blank?
        [@content]
      else
        Post.where(:post_type => 'post', :post_status => 'Published').order(orderby)
      end
  	ret
  end

  # returns all the archive records for the archive you are currently on 

  def obtain_archives
    @content
  end


  # PAGE functions #


  # returns all the data for the given page
  # Params:
  # +check+:: ID, slug, or name of the article - if this is nil it will use the @content variable (the current page)

  def obtain_page(check = nil)
    if check.blank? && !@content.blank? && @content[0].blank?
      @content
    else
      Post.where("(post_title = :p OR post_slug = :p2 OR id = :p3) AND post_type = 'page' ", { p: check.to_s, p2: check.to_s, p3: check.to_i} )
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
  # +field+:: admin_id, post_content, post_date, post_name, parent_id, post_slug, sort_order, post_visible, post_additional_data, post_status, post_title, post_image, post_template, post_type, disabled, post_seo_title, post_seo_description, post_seo_keywords, post_seo_is_disabled, post_seo_no_follow, post_seo_no_index
  # +check+:: ID, slug, or name of the article - if this is nil it will use the @content variable (the current page)

  def obtain_page_field(field, check = nil)
    page = 
      if check.blank? && !@content.blank? && @content[0].blank?
        @content
      else
        Post.where("(post_title = :p OR post_slug = :p2 OR id = :p3) AND post_type = 'page' ", { p: check.to_s, p2: check.to_s, p3: check.to_i} ).first
      end
    !page.blank? && page.has_attribute?(field) ? page[field.to_sym] : nil
  end

  # CONDITIONAL functions #


  # TODO: Clean this code up
  # returns a boolean as to wether the given page/post is a page
  # Params:
  # +check+:: ID of the page

  def is_page?(check = nil)

    p = @content
    return false if @content.blank? || !@content[0].blank? || p.blank?
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
      (Setting.get('tag_slug') == segments[1] && (term.first.name == check || term.first.id == check || term.first.slug == check) ) ? true : false
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
      (Setting.get('category_slug') == segments[1] && (term.first.name == check || term.first.id == check || term.first.slug == check) ) ? true : false
    end
  end


  # USER Functions #

  # returns all the data for the given user
  # Params:
  # +check+:: ID, email, or username of the user

  def obtain_user_profile(check)
    Admin.select('id, email, first_name, last_name, username, access_level, avatar, cover_picture, overlord').where( 'id = :p OR email = :p2 OR username = :p3', { p: check.to_i, p2: check.to_s, p3: check.to_s} ).first
  end

  # returns all the users
  # Params:
  # +access+:: restrict the returned data to show only certain access levels access level - the options can be found in the admin panel

  def obtain_users(access = nil)
    admins = Admin.select('id, email, first_name, last_name, username, access_level, avatar, cover_picture, overlord').where('1=1')
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
        Admin.where( 'id = :p OR email = :p2 OR username = :p3', { p: check.to_i, p2: check.to_s, p3: check.to_s} ).first
      else
        return nil if @content.blank? || !@content[0].blank?
        Admin.find_by_id(@content.admin_id)
      end
    return '' if admin.blank?
    admin.has_attribute?(field) ? admin[field] : nil
  end



  # COMMENT Functions #

  # returns the author name of the given comment
  # Params:
  # +comment_id+:: ID of the comment

  def obtain_comment_author(comment_id)
    comm = Comment.find_by_id(comment_id)
    comm.author if !comm.blank?
  end

  # returns the date of the given comment
  # Params:
  # +comment_id+:: ID of the comment
  # +format+:: the format that you want the date to be returned in

  def obtain_comment_date(comment_id, format = "%d-%m-%Y")
    comment = Comment.find_by_id(comment_id)
    comment = comment.submitted_on.strftime(format) if !comment.blank?
    comment if !comment.blank?
  end

  # returns the time of the given comment
  # Params:
  # +comment_id+:: ID of the comment
  # +format+:: the format that you want the time to be returned in

  def obtain_comment_time(comment_id, format = "%H:%M:%S")
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
      render(:template =>"theme/#{current_theme}/comments_form." + get_theme_ext , :layout => nil, :locals => { type: type }).to_s
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
    	Admin.select('id, email, first_name, last_name, username, access_level, avatar, cover_picture, overlord').find_by_id(@content.admin_id)
    else
    	Admin.joins(:posts).select('admins.id, email, first_name, last_name, username, access_level, avatar, cover_picture, overlord').where(posts: { id: postid }).first
    end
  end

  # returns all of the articles that the user has created
  # Params:
  # +id+:: ID of the user that you want to get all the records for

  def obtain_the_authors_articles(id = nil)
  	if id.blank?
      return nil if @content.blank? || !@content[0].blank?
    	Post.where(:admin_id => @content.admin_id)
    else
    	Post.where(:admin_id => id)
    end
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

  # returns the additional data record
  # Params:
  # +key+:: the key to the additional data that you want to return - if this is nil it will return all of the additional data for the given record
  # +check+:: ID, post_slug, or post_title of the post record - if this is nil it will use the @content variable (the current page)

  def obtain_additional_data(key = nil, check = nil)

    if check.blank?
      return nil if @content.blank? || !@content[0].blank?
    end
  	
  	post = 
  		if post.blank?
  			@content.post_additional_data
  		else
  			Post.find(post).post_additional_data
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

  def create_excerpt(content, length = 255, omission = '...')
    render :inline => truncate(content, :omission => omission, :length => length)
  end

  # returns a full post record (this is used mainly internally to retrieve the data for other functions) 
  # Params:
  # +check+:: ID, post_slug, or post_title of the post record - if this is nil it will use the @content variable (the current page)

  def obtain_record(check = nil)

    if check.blank? 
      return nil if @content.blank? || !@content[0].blank?
      @content
    else
      Post.where( 'post_title = :p OR post_slug = :p2 OR id = :p3', { p: check.to_s, p2: check.to_s, p3: check.to_i} ).first
    end

  end

  # returns a full term record (this is used mainly internally to retrieve the data for other functions) 
  # Params:
  # +segments+:: URL segments

  def obtain_term(segments)
    Term.where(structured_url: ('/' + segments[2..-1].join('/')))
  end

end
