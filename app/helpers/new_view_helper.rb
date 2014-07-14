module NewViewHelper

  # The view helper contains all of the functions that the views
  # will use in order to display the contents of either the content
  # or format other data

  # GENERIC Functions #

  def obtain_children(check = nil, depth = 10000000, orderby = 'post_title')
  	# look at ancertry gem 
    post = obtain_record(check)
    return {} if post.blank?
    p = post.children
    p = p.arrange(:order => orderby.to_sym) if !orderby.blank?
    p
  end

  def has_children?(check = nil)
    post = obtain_record(check)
    post.blank? ? false : post.has_children?
  end

  def has_siblings?(check = nil)
    post = obtain_record(check)
    post.blank? ? false : post.has_siblings?
  end

  # get siblings

  def obtain_siblings(check = nil, orderby = 'post_title')
    post = obtain_record(check)
    return nil if post.blank?
    p = post.siblings
    p = p.arrange(:order => orderby.to_sym) if !orderby.blank?
    p
  end

  # get ancestors

  def obtain_ancestor(check = nil)
    post = obtain_record(check)
    return nil if post.blank?
    p = post.ancestors
    p = p.arrange(:order => orderby.to_sym) if !orderby.blank?
    p
  end

  # hererrewrewrrew #

  # Gets the link to the post
  # Params:
  # +check+:: id of the post record that you want to return the link of

  def obtain_permalink(check = nil)
    site_url = Setting.get('site_url')
    post = obtain_record(check)

    return '' if post.blank?

    article_url = Setting.get('articles_slug')

    if post.post_type == 'post'
      render :inline => site_url("#{article_url}#{post.structured_url}")
    else
      render :inline => site_url("#{post.structured_url}")
    end

  end

  def obtain_excerpt(check = nil, length = 250, omission = '...')
  	
  	post = obtain_record(check)
  	render :inline => truncate(post.post_content.to_s.gsub(/<[^>]*>/ui,'').html_safe, :omission => omission, :length => length) if !post.blank?
  
  end

  def obtain_cover_image(check = nil)
  	post = obtain_record(check)
    return !post.blank? ? post.post_image : ''
  end


  # Display the date of the current post or the given post via the ID
  # Params:
  # +id+:: article or page id
  # +format+:: the date format that you want the date to be provided in
  # PREVIOUSLY: get_the_date

  def obtain_the_date(check = nil, format = "%d-%m-%Y")
  	post = obtain_record(check)
  	render :inline => post.post_date.strftime(format) if !post.blank?
  end

  def has_cover_image?(check = nil)
  	post = obtain_record(check)
  	!post.blank? && !post.post_image.blank? ? true : false
  end

  # CATEGORY functions #

  def obtain_all_category_ids(article_id = nil)
    if article_id.blank?
      Term.joins(:term_anatomy).where(term_anatomies: { taxonomy: 'category' }).pluck(:id)
    else
      # get via the posts
      Term.joins(:term_anatomy, :posts).where(posts: {id: article_id}, term_anatomies: { taxonomy: 'category' }).pluck(:id)
    end
  end

  def obtain_categories
		Term::CATEGORIES
  end

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

  def in_category?(cat, postid = nil)
  	post = obtain_record(postid)
    return false if post.blank?
  	!Post.includes(:terms => :term_anatomy).where(id: post.id, terms: { id: cat }, term_anatomies: { taxonomy: 'category' }).blank?
  end

  # TAG Functions #

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

  def obtain_tags
  	Term::TAGS
  end

  def has_tag?(tag, postid = nil)
  	post = obtain_record(postid)
    return false if post.blank?
    !Post.includes(:terms => :term_anatomy).where(id: post.id, terms: { id: tag }, term_anatomies: { taxonomy: 'tag' }).blank?
  end

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

  def obtain_tag_description(id = nil)

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

  def obtain_article(check = nil)
    if check.blank? && !@content.blank? && @content[0].blank?
      @content
    else
      Post.where("(post_title = :p OR post_slug = :p2 OR id = :p3) AND post_type = 'post' ", { p: check.to_s, p2: check.to_s, p3: check.to_i} ).first
    end
  end

  def obtain_article_field(field, check = nil)
    article = 
      if check.blank? && !@content.blank? && @content[0].blank?
        @content
      else
        Post.where("(post_title = :p OR post_slug = :p2 OR id = :p3) AND post_type = 'post' ", { p: check.to_s, p2: check.to_s, p3: check.to_i} ).first
      end
    !article.blank? && article.has_attribute?(field) ? article[field.to_sym] : nil
  end

  def obtain_article_status(check = nil)
    article = 
      if check.blank? && !@content.blank? && @content[0].blank?
        @content
      else
        Post.where("(post_title = :p OR post_slug = :p2 OR id = :p3) AND post_type = 'post' ", { p: check.to_s, p2: check.to_s, p3: check.to_i} ).first
      end
    !article.blank? && article.has_attribute?('post_status') ? article.post_status : nil
  end

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

  def obtain_archives
    @content
  end

  # PAGE functions #

  def obtain_page(check = nil)
    if check.blank? && !@content.blank? && @content[0].blank?
      @content
    else
      Post.where("(post_title = :p OR post_slug = :p2 OR id = :p3) AND post_type = 'page' ", { p: check.to_s, p2: check.to_s, p3: check.to_i} )
    end
  end 

  def obtain_pages(ids = nil, orderby = "post_title DESC")
    return Post.where(:id => ids, :post_type => 'page').order(orderby) if !ids.blank?
    return [@content] if !@content[0].blank?
    return Post.where(:post_type => 'page', :post_status => 'Published').order(orderby)
  end

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

  # HACK: Clean this code up
  # is_page?
  # Checks to see if given id or string is the current content record
  # Params:
  # +check+:: can be either ID, name, or slug

  def is_page?(check = nil)

    p = @content
    return false if @content.class == ActiveRecord::Relation || p.blank?
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

  def is_day_archive?
    segments = params[:slug].split('/')
    (get_type_by_url == 'AR' && !segments[3].blank?) ? true : false
  end

  def is_month_archive?
    segments = params[:slug].split('/')
    (get_type_by_url == 'AR' && !segments[2].blank? && segments[3].blank?) ? true : false
  end

  def is_year_archive?
    segments = params[:slug].split('/')
    (get_type_by_url == 'AR' && !segments[1].blank? && segments[2].blank? && segments[3].blank?) ? true : false
  end

  def obtain_archive_year

    if get_type_by_url == 'AR'
      segments = params[:slug].split('/')
      str = ''
      str = (get_date_name_by_number(segments[2].to_i) + ' ') if !segments[2].blank?
      str += segments[1]
    end

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

  def is_search?
    (defined?(params[:search]) && !params[:search].blank?) ? true : false
  end

  # is_tag?
  # Params:
  # +check+:: check wether it is a certain tag or not. This is checked by the ID, name, or slug

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

  # is_category?
  # Params:
  # +check+:: check wether it is a certain category or not. This is checked by the ID, name, or slug

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

  def obtain_user_profile(check)
    Admin.select('id, email, first_name, last_name, username, access_level, avatar, cover_picture, overlord').where( 'id = :p OR email = :p2 OR username = :p3', { p: check.to_i, p2: check.to_s, p3: check.to_s} ).first
  end

  def obtain_users(access = nil)
    admins = Admin.select('id, email, first_name, last_name, username, access_level, avatar, cover_picture, overlord').where('1=1')
    if access.is_a?(Array)
      admins = admins.where(:id => access) if !access.blank?
    else
      admins = admins.where(:access_level => access) if !access.blank?
    end

    admins
  end

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

  def obtain_comment_author(comment_id)
    comm = Comment.find_by_id(comment_id)
    comm.author if !comm.blank?
  end

  def obtain_comment_date(comment_id, format = "%d-%m-%Y")
    comment = Comment.find_by_id(comment_id)
    comment = comment.submitted_on.strftime(format) if !comment.blank?
    comment if !comment.blank?
  end

  def obtain_comment_time(comment_id, format = "%H:%M:%S")
    comment = Comment.find_by_id(comment_id)
    comment = comment.submitted_on.strftime(format) if !comment.blank?
    comment if !comment.blank?
  end

  def obtain_comments(check = nil)

    if check.blank? && !@content.blank? && @content[0].blank?
      Comment.where(:post_id => @content.id, :comment_approved => 'Y')
    else
      Comment.where(:post_id => check, :comment_approved => 'Y')
    end

  end

  # gets the comment form from the theme folder and displays it.

  def obtain_comments_form

  	if Setting.get('article_comments') == 'Y'
      type = Setting.get('article_comment_type')
      @new_comment = Comment.new
      render(:template =>"theme/#{current_theme}/comments_form." + get_theme_ext , :layout => nil, :locals => { type: type }).to_s
    end

  end

  # MISCELLANEOUS Functions #

  def obtain_id
  	@content.id if !@content.blank? && @content[0].blank?
  end

  def obtain_the_author(id = nil)
    if id.blank?
      return nil if @content.blank? || !@content[0].blank?
    	Admin.select('id, email, first_name, last_name, username, access_level, avatar, cover_picture, overlord').find_by_id(@content.admin_id)
    else
    	Admin.joins(:posts).select('admins.id, email, first_name, last_name, username, access_level, avatar, cover_picture, overlord').where(posts: { id: id }).first
    end
  end

  def obtain_the_authors_articles(id = nil)
  	if id.blank?
      return nil if @content.blank? || !@content[0].blank?
    	Post.where(:admin_id => @content.admin_id)
    else
    	Post.where(:admin_id => id)
    end
  end

  def obtain_the_content(check = nil)
  	post = obtain_record(check)
  	render :inline => prep_content(post).html_safe if !post.blank?
  end

  # display the title of the given post via the post parameter
  # Params:
  # +id+:: id of the post that you want to get the title for

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

  def obtain_additional_data(key = nil, post = nil)

    if post.blank?
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

  def create_excerpt(content, length = 255, omission = '...')
    render :inline => truncate(content, :omission => omission, :length => length)
  end

  def obtain_record(check = nil)

    if check.blank? 
      return nil if @content.blank? || !@content[0].blank?
      @content
    else
      Post.where( 'post_title = :p OR post_slug = :p2 OR id = :p3', { p: check.to_s, p2: check.to_s, p3: check.to_i} ).first
    end

  end

  def obtain_term(segments)
    Term.where(structured_url: ('/' + segments[2..-1].join('/')))
  end

end
