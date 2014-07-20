module ViewHelper

  # The view helper contains all of the functions that the views
  # will use in order to display the contents of either the content
  # or format other data

  # Returns a nested list of the comments
  # Params:
  # +post_id+:: id of the post that you want to get comments for

  def display_comments_loop(post_id = nil)

    # get the comments by the post id or the globalized @content record
    comments = 
      if !post_id.nil?
        Comment.where(:post_id => post_id)
      else
        Comment.where(:post_id => @content.id, :comment_approved => 'Y', :is_spam => 'N')
      end

    if comments.size > 0
      html = "<h3 id='comments-title'>#{comments.count}" + I18n.t("helpers.view_helper.display_comments_loop.response") + " #{obtain_the_title}</h3>"
    end

    html = nested_comments obtain_comments.arrange(:order => 'created_at ASC')

    render :inline => html.html_safe

  end


  # Return the author information of the articles
  # Params:
  # +raw+:: if set to true you will just get the author information in a raw ActiveRcord format

  def display_author_information(raw = false)

    admin = Admin.find_by_id(@content.admin_id)
    if raw
      admin
    else
      unless @admin.blank?
        html = "<div id='author-info'>
					<div id='author-description'>
						<h2>#{@admin.first_name} #{@admin.last_name}</h2>
						<p>#{@admin.description}</p>						
					</div>
				</div>"

        render :inline => html.html_safe
      end
    end

  end


  # Returns the html for the comments tree of a post
  # Params:
  # +messages+:: all of the messages for the post

  def nested_comments(messages)
    messages.map do |message, sub_messages|
      @comment = message
      render('admin/partials/comment') + content_tag(:div, nested_comments(sub_messages), :class => "nested_comments")
    end.join.html_safe
  end

  def admin_nested_comments(messages)
    messages.map do |message, sub_messages|
      @comment = message
      render('admin/partials/admin_comment') + content_tag(:ul, admin_nested_comments(sub_messages), :class => "list-group nested_comments")
    end.join.html_safe
  end


  # Returns a list of the given data
  # Params:
  # +arr+:: array that you want to list through to create the list

  def li_loop(arr)

    html = '<ul>'
    arr.each do |k, v|
      html += "<li><a href='#{site_url}#{k}'>#{v}</a></li>"
    end
    html += '</ul>'

    render :inline => html

  end

  # Returns a list of the given data, but puts children records in the loop
  # Params:
  # +arr+:: array that you want to list through to create the list

  def li_loop_for_terms(arr, term_type, initial = 'initial')

    article_url = Setting.get('articles_slug')

    html = '<ul class="' + initial + '">'
    arr.each do |key, val|
      html += "<li><a href='#{site_url}#{article_url}/#{term_type}#{key.structured_url}'>#{key.name}</a>"
      html += li_loop_for_terms(val, term_type, 'sub') unless val.blank?
    end
    html += '</ul>'

    render :inline => html

  end


  # Returns a sub string of the month name
  # Params:
  # +str+:: integer of the month

  def get_date_name_by_number(str)
    case str
    when  1 then I18n.t("helpers.view_helper.get_date_name_by_number.date_1")
    when  2 then I18n.t("helpers.view_helper.get_date_name_by_number.date_2")
    when  3 then I18n.t("helpers.view_helper.get_date_name_by_number.date_3")
    when  4 then I18n.t("helpers.view_helper.get_date_name_by_number.date_4")
    when  5 then I18n.t("helpers.view_helper.get_date_name_by_number.date_5")
    when  6 then I18n.t("helpers.view_helper.get_date_name_by_number.date_6")
    when  7 then I18n.t("helpers.view_helper.get_date_name_by_number.date_7")
    when  8 then I18n.t("helpers.view_helper.get_date_name_by_number.date_8")
    when  9 then I18n.t("helpers.view_helper.get_date_name_by_number.date_9")
    when 10 then I18n.t("helpers.view_helper.get_date_name_by_number.date_10")
    when 11 then I18n.t("helpers.view_helper.get_date_name_by_number.date_11")
    when 12 then I18n.t("helpers.view_helper.get_date_name_by_number.date_12")
    end
  end


  # returns a boolean as to wether the template file actually exists
  # Params:
  # +name+:: the name of the template file that you want to check exists

  def view_file_exists?(name)
    File.exists?("app/views/theme/#{current_theme}/template-#{name}." + get_theme_ext )
  end


  # get current theme

  def current_theme
    Setting.get('theme_folder')
  end


  # returns a full url to the file that you want to render from the theme file.
  # example usage would be: <%= render theme_url 'sidebar' %>
  # Params:
  # +append+:: the name of the file that you want to render

  def theme_url(append)
    "theme/#{current_theme}/#{append}"
  end

  # displays the header.  + get_theme_ext template in the theme if the file exists

  def display_header
    render :template => "/theme/#{current_theme}/header." + get_theme_ext  if File.exists?("app/views/theme/#{current_theme}/header." + get_theme_ext )
  end

  # displays the header. + get_theme_ext template in the theme if the file exists

  def display_footer
    render :template => "theme/#{current_theme}/footer." + get_theme_ext  if File.exists?("app/views/theme/#{current_theme}/footer." + get_theme_ext )
  end

end
