module Roroacms  
  module GeneralHelper

    # get a value from the theme yaml file by the key
    # Params:
    # +key+:: YAML key of the value that you want to retrive

    def theme_yaml(key = nil)
      if File.exists?("#{Rails.root}/app/views/themes/#{current_theme}/theme.yml")
        theme_yaml = YAML.load(File.read("#{Rails.root}/app/views/themes/#{current_theme}/theme.yml"))
        theme_yaml[key]
      else
        'html.erb'
      end
    end

    # rewrite the theme helper to use the themes function file

    def rewrite_theme_helper

      if File.exists?("#{Rails.root}/app/views/themes/#{current_theme}/theme_helper.rb")

        # get the theme helper from the theme folder
        file = File.open("#{Rails.root}/app/views/themes/#{current_theme}/theme_helper.rb", "rb")
        contents = file.read

        # check if the first line starts with the module name or not
        parts = contents.split(/[\r\n]+/)

        if parts[0] != 'module ThemeHelper'
          contents = "module ThemeHelper\n\n" + contents + "\n\nend"
        end

        # write the contents to the actual file file
        File.open("#{Rails.root}/app/helpers/theme_helper.rb", 'w') { |file| file.write(contents) }


      else
        contents = "module ThemeHelper\n\nend"
        File.open("#{Rails.root}/app/helpers/theme_helper.rb", 'w') { |file| file.write(contents) }
      end

      load("#{Rails.root}/app/helpers/theme_helper.rb")
    end

    # do a check to see if theme has theme.yml file

    def check_theme_folder
      if !File.exists?("#{Rails.root}/app/views/themes/#{current_theme}/theme.yml")
        render :inline => I18n.t("helpers.general_helper.check_theme_folder.message") and return
      end
    end

    def check_necessaries
      change = false
      hash = {'theme.yml' => 'Y', 'layout.html.erb' => 'Y', 'page.html.erb' => 'Y'}

      if !File.exists?("#{Rails.root}/app/views/themes/#{current_theme}/theme.yml")
        hash['theme.yml'] = 'N'
        change = true
      end 

      if !File.exists?("#{Rails.root}/app/views/themes/#{current_theme}/layout.html.erb")
        hash['layout.html.erb'] = 'N'
        change = true
      end

      if !File.exists?("#{Rails.root}/app/views/themes/#{current_theme}/page.html.erb")
        hash['page.html.erb'] = 'N'
        change = true
      end

      change ? hash : nil
    end

    # capitalizes all words in a string
    # Params:
    # +str+:: the string

    def ucwords(str = nil)
      return '' if str.blank?
      str.split(' ').select {|w| w.capitalize! || w }.join(' ')
    end

    # set the session data for the admin to allow/restrict the necessary areas

    def set_sessions(session, admin)
      session[:admin_id] = admin.id
      session[:username] = admin.username
    end

    # destroy the session data - logging them out of the admin panel

    def destroy_session(session)
      session[:admin_id] = nil
      session[:username] = nil
    end

    # strips the url of all the variable data so that the URLs are always the same
    # Params:
    # +url+:: the URL that you want to strip down

    def strip_url(url)

      Setting.strip_url(url)
      
    end

    # reutrns a nested menu
    # Params:
    # +item+:: hash of menu items 
    # +text+:: the hash value that you want to use as the title text 

    def nested_dropdown(items, text = 'post_title')
      result = []
      items.map do |item, sub_items|
        name = text == 'post_title' && !item.parent.blank? && item.parent.disabled == 'Y' ? item[text.to_sym] + " (parent: #{item.parent.post_title})" : item[text.to_sym]
        result << [('- ' * item.depth) + name.html_safe, item[:id]]
        result += nested_dropdown(sub_items, text) unless sub_items.blank?
      end
      result
    end


    # returns the closest revision to the current revision been displayed - this is an internal functon that no-body should have to worry about or touch
    # Params:
    # +revisions+:: ActiveRecord hash of revisions
    # +current+:: integer of the current record
    # +status+:: what status of the revisions you want to check against

    def get_closest_revision(revisions, current, status)
      if status == 'user-autosave'
        revisions.each_with_index do |f, index|
            return f if f.post_status.downcase == 'user-autosave' && index > current 
        end
        return nil
      end

      return revisions[current+1] if !revisions[current+1].blank?
      return revisions[0].parent
    end

  end

end