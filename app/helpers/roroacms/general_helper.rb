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

    # list controllers in given directory
    # Params:
    # +dir+:: directory that you want to list all of the controllers from

    def list_controllers_raw(dir = "")
      dir = dir + "/**/" if !dir.blank?
      controller_list = Array.new
      Dir["#{Roroacms::Engine.root}/app/controllers**/roroacms/#{dir}*.rb"].each do |file|
        controller_list.push(file.split('/').last.sub!("_controller.rb",""))
      end
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

    def strip_url(url)

      url.sub!(/www./, '')            if url.include? "www."
      
      url.sub!(/https\:\/\//, '') if url.include? "https://"

      url.sub!(/http\:\/\//, '')  if url.include? "http://"

      return url
    end

    def nested_dropdown(items, text = 'post_title')
        result = []
        items.map do |item, sub_items|
            name = text == 'post_title' && !item.parent.blank? && item.parent.disabled == 'Y' ? item[text.to_sym] + " (parent: #{item.parent.post_title})" : item[text.to_sym]
            result << [('- ' * item.depth) + name.html_safe, item[:id]]
            result += nested_dropdown(sub_items, text) unless sub_items.blank?
        end
        result
    end

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