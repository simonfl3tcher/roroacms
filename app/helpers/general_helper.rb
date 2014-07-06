module GeneralHelper

  # get a value from the theme yaml file by the key
  # Params:
  # +key+:: YAML key of the value that you want to retrive

  def theme_yaml(key = nil)
    if File.exists?("#{Rails.root}/app/views/theme/#{current_theme}/theme.yml")
      theme_yaml = YAML.load(File.read("#{Rails.root}/app/views/theme/#{current_theme}/theme.yml"))
      theme_yaml[key]
    else
      'html.erb'
    end
  end

  # rewrite the theme helper to use the themes function file

  def rewrite_theme_helper

    if File.exists?("#{Rails.root}/app/views/theme/#{current_theme}/theme_helper.rb")

      # get the theme helper from the theme folder
      file = File.open("#{Rails.root}/app/views/theme/#{current_theme}/theme_helper.rb", "rb")
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
    if !File.exists?("#{Rails.root}/app/views/theme/#{current_theme}/theme.yml")
      render :inline => I18n.t("helpers.general_helper.check_theme_folder.message") and return
    end
  end

  # list controllers in given directory
  # Params:
  # +dir+:: directory that you want to list all of the controllers from

  def list_controllers_raw(dir = "")
    dir = dir + "/**/" if !dir.blank?
    controller_list = Array.new
    Dir["app/controllers**/#{dir}*.rb"].each do |file|
      controller_list.push(file.split('/').last.sub!("_controller.rb",""))
    end
  end

  # capitalizes all words in a string
  # Params:
  # +str+:: the string

  def ucwords str
    return str.split(' ').select {|w| w.capitalize! || w }.join(' ');
  end

end
