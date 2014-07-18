module AdminRoroaHelper

  # returns wether it is numeric or not
  # Params:
  # +obj+:: either an int, float, decimal or string of a number or not depending on what you are looking for

  def is_numeric?(obj)
    obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end


  # returns a hash of the different themes as a hash with the details kept in the theme.yml file

  def get_theme_options

    hash = []
    Dir.glob("app/views/theme/*/") do |themes|
      opt = themes.split('/').last
      if File.exists?("#{themes}theme.yml")
        info = YAML.load(File.read("#{themes}theme.yml"))
        hash << info
      end
    end

    hash
  end


  # destroys the theme from the file structure
  # Params:
  # +theme+:: the theme name which is set in the theme.yml file and should be the same as the folder name

  def destory_theme(theme)
    require 'fileutils'
    FileUtils.rm_rf("app/views/theme/#{theme}")
  end

  # retuns a hash of the template files within the current theme

  def get_templates
    hash = []
    current_theme = Setting.get('theme_folder')

    Dir.glob("app/views/theme/#{current_theme}/template-*.html.erb") do |my_text_file|
      opt = my_text_file.split('/').last
      opt['template-'] = ''
      opt['.html.erb'] = ''
      # strips out the template- and .html.erb extention and returns the middle as the template name for the admin
      hash << opt.titleize
    end

    hash
  end


  # returns a html dropdown of the template options
  # Params:
  # +current+:: current post template, if it doesn't have one it will just return a standard dropdown

  def get_template_dropdown(current = '')

    templates = get_templates
    str = ''

    templates.each do |f|
      str += 
        if f == current
          "<option value='#{f}' selected='selected'>#{f}</option>"
        else
          "<option value='#{f}'>#{f}</option>"
        end
    end

    str.html_safe

  end


  # returns boolean as to wether the logged in user is the complete overlord of the system

  def is_overlord?
    current_user.overlord == 'Y' ? true : false
  end


  # returns a table block of html that has nested ootions
  # Params:
  # +options+:: is a hash of all of the record that you want to display in a nested table

  def nested_table(options)
    options.map do |opt, sub_messages|
      @content = opt
      # set the sub to be sub messages. The view checks its not blank and runs this function again
      @sub = sub_messages

      render('admin/partials/table_row')

    end.join.html_safe
  end


  # returns a html block of line indentation to show that it is underneath its parent
  # Params:
  # +cont+:: a hash of the record you are checking against

  def ancestory_indent(cont)

    html = ''
    cont.ancestor_ids.length

    i = 0
    while i < cont.ancestor_ids.length  do
      html += "<i class=\"icon-minus\"></i>"
      i += 1
    end

    render :inline =>  html.html_safe

  end

  # checks if the current theme being used actually exists. If not it will return an error message to the user

  def theme_exists

    if !Dir.exists?("app/views/theme/#{Setting.get('theme_folder')}/")
      html = "<div class='alert alert-danger'><strong>" + I18n.t("helpers.admin_roroa_helper.theme_exists.warning") + "!</strong>" + I18n.t("helpers.admin_roroa_helper.theme_exists.message") + "!</div>"
      render :inline => html.html_safe
    end

  end

  # get the last (#{limit}) comments
  # Params:
  # +limit+:: count of how many comments you would like to return

  def latest_comments(limit = 5)
    if !limit.blank?
      Comment.where(:comment_approved => 'N').order("submitted_on DESC").first(limit)
    else
      Comment.where(:comment_approved => 'N').order("submitted_on DESC")
    end
  end

  # count how many records in given post type
  # Params:
  # +type+:: what type of post records you want to get the count for

  def get_count_post(type)
    Post.where(:post_type => type).count
  end

  # count all comments
  def get_count_comments
    Comment.all.size
  end

  # display errors inline to the input
  # Params:
  # +model+:: ActiveRecord model from form
  # +attribute+:: the attribute that you want to check errors for

  def errors_for(model, attribute)
    if model.errors[attribute].present?
      name = model.class.name.constantize.human_attribute_name(attribute)
      content_tag :span, :class => 'help-block error' do
        name.to_s.capitalize + ' ' + model.errors[attribute].join(", ")
      end
    end
  end

  # display errors inline to the input specifically for setting ares
  # Params:
  # +model+:: ActiveRecord model from form
  # +attribute+:: the attribute that you want to check errors for

  def setting_errors_for(model, attribute)
    if !model[:errors].blank? && model[:errors][attribute.to_sym].present?
      content_tag :span, :class => 'help-block error' do
        I18n.t("views.admin.settings.tab_content.#{attribute.to_s}").downcase.capitalize + ' ' + I18n.t("activerecord.errors.messages.empty")
      end
    end
  end

  # deals with the user images (profile/cover images)
  # Params:
  # +params+:: parameters
  # +attribute+:: admin ActiveRecord object

  def profile_images(params, admin)

    Admin.deal_with_profile_images(admin, upload_images(params[:admin][:avatar], admin.username), 'avatar') if !params[:admin][:avatar].blank?
    Admin.deal_with_profile_images(admin, upload_images(params[:admin][:cover_picture], admin.username), 'cover_picture') if !params[:admin][:cover_picture].blank?

  end

  # lists all the controllers in the admin area and returns a formatted hash. This is used for the user group administration
  # Params:
  # +dir+:: the directory that you want to list the controllers for

  def list_controllers(dir = 'admin')
    hash = {}
    controllers = list_controllers_raw(dir)

    controllers.each do |f|

      key = f.sub('app/controllers/admin/', '')
      value = key.sub('_controller.rb', '')

      next if value == 'dashboard'

      v =
        case value
        when 'settings/general'
          'Settings'
        when 'terms'
          'Categories & Tags'
        when 'posts'
          'Articles'
        when 'administrators'
          'Users'
        else
          value
        end

      hash[ucwords(v)] = key.sub('_controller.rb', '')

    end

    hash.sort

  end

  # get user group data and return the value for the given key
  # Params:
  # +key+:: user group name that is set in the admin panel

  def get_user_group(key)

    if !Setting.get('user_groups').blank?

      arr = ActiveSupport::JSON.decode(Setting.get('user_groups').gsub("\\", ''))

      if arr.has_key? key
        arr[key]
      else
        Array.new
      end

    end
  end

  # is the user allowed access to the given controller - this function runs in the background.
  # Params:
  # +key+:: controller name

  def check_controller_against_user(key)
    get_user_group(current_user.access_level).include?(key)
  end

  # checks to see if the given path is the current page/link
  # Params:
  # +path+:: rake path of the link you want to check

  def cp(path)
    "active" if current_page?(path)
  end

  # .pluralize() but without the preceeding number
  # Params:
  # +count+:: how many
  # +noun+:: the word that you want to pluralize
  # +text+:: the text you want to append to the returning word

  def pluralize_without_count(count, noun, text = nil)
    if count != 0
      count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
    end
  end

  # displays the additional data on the page form
  # Params:
  # +data+:: data to loop through and display
  # +key_exists+:: this is used to define if the data is a hash or an array if it is an array this should be set to false
  # +key+:: if it is an array then it needs to use its parent key, this is provided via this vairable

  def addition_data_loop(data, keys_exist = true, key = nil)
    string = ''
    if keys_exist
      data.each do |key, value|
        string +=
          if value.is_a?(Array)
            addition_data_loop(value, false, key)
          else
            (render :partial => 'admin/partials/post_additional_data_view', :locals => { key: key, value: value })
          end
      end
    else
      data.each do |value|
        string += (render :partial => 'admin/partials/post_additional_data_view', :locals => { key: key, value: value })
      end
    end

    string.html_safe

  end

  # decides the bootstrap column length depending on the records
  # Params:
  # +posts+:: first set of records
  # +pages+:: second set of records

  def respond_to_trash(posts, pages)
    !posts.blank? && pages.blank? ? '6' : '12'
  end

  # clears the admin view cache.
  # This is used when logging out or changing user profile or settings

  def clear_cache
    expire_fragment('admin_header')
    expire_fragment('admin_quick_links')
    expire_fragment('admin_submit_bar_toggle')
  end

  # Returns generic notifications if the flash data exists

  def get_notifications
    if flash[:notice]
      html = "<div class='alert alert-success'><button type='button' class='close' data-dismiss='alert'>x</button><strong>" + I18n.t("helpers.view_helper.generic.flash.success") + "!</strong> #{flash[:notice]}</div>"
      render :inline => html.html_safe
    elsif flash[:error]
      html = "<div class='alert alert-danger'><button type='button' class='close' data-dismiss='alert'>x</button><strong>" + I18n.t("helpers.view_helper.generic.flash.error") + "!</strong> #{flash[:error]}</div>"
      render :inline => html.html_safe
    end
  end

  end
