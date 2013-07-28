# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
APP_CONFIG = '123123'




Setting.create :setting_name => 'articles_slug', :type_of_setting => 'G', :setting => ENV['articles_slug']
Setting.create :setting_name => 'home_page', :type_of_setting => 'G', :setting => '1'
Setting.create :setting_name => 'seo_home_title', :type_of_setting => 'SEO', :setting => ENV['site_title']
Setting.create :setting_name => 'seo_home_description', :type_of_setting => 'SEO', :setting => ''
Setting.create :setting_name => 'seo_rewrite_titles', :type_of_setting => 'SEO', :setting => ''
Setting.create :setting_name => 'seo_canonical_urls', :type_of_setting => 'SEO', :setting => ''
Setting.create :setting_name => 'seo_404_title', :type_of_setting => 'SEO', :setting => ''
Setting.create :setting_name => 'seo_404_description', :type_of_setting => 'SEO', :setting => ''
Setting.create :setting_name => 'seo_google_analytics_code', :type_of_setting => 'SEO', :setting => ''
Setting.create :setting_name => 'seo_no_index_categories', :type_of_setting => 'SEO', :setting => ''
Setting.create :setting_name => 'seo_no_index_archives', :type_of_setting => 'SEO', :setting => ''
Setting.create :setting_name => 'seo_autogenerate_descriptions', :type_of_setting => 'SEO', :setting => ''
Setting.create :setting_name => 'seo_additional_headers', :type_of_setting => 'SEO', :setting => ''
Setting.create :setting_name => 'seo_site_title', :type_of_setting => 'SEO', :setting => ENV['site_title']
Setting.create :setting_name => 'category_slug', :type_of_setting => 'G', :setting => ENV['category_slug']
Setting.create :setting_name => 'article_comments', :type_of_setting => 'COMMENTS', :setting => 'Y'
Setting.create :setting_name => 'article_comment_type', :type_of_setting => 'COMMENTS', :setting => 'R'
Setting.create :setting_name => 'site_url', :type_of_setting => 'G', :setting => ENV['site_url']
Setting.create :setting_name => 'display_url', :type_of_setting => 'G', :setting => ENV['display_url']
Setting.create :setting_name => 'tag_slug', :type_of_setting => 'G', :setting => ENV['tag_slug']
Setting.create :setting_name => 'site_email', :type_of_setting => 'G', :setting => ENV['admin_email']
Setting.create :setting_name => 'aws_access_key_id', :type_of_setting => 'AWS', :setting => ENV['aws_access_key_id']
Setting.create :setting_name => 'aws_secret_access_key', :type_of_setting => 'AWS', :setting => ENV['aws_secret_access_key']
Setting.create :setting_name => 'aws_bucket_name', :type_of_setting => 'AWS', :setting => ENV['aws_bucket_name']
Setting.create :setting_name => 'pagination_per', :type_of_setting => 'G', :setting => ''
Setting.create :setting_name => 'theme_folder', :type_of_setting => 'T', :setting => ENV['theme_folder']
Admin.create :username => ENV['admin_username'], :password => ENV['admin_password'], :email => ENV['admin_email'], :access_level => 'admin', :first_name => '', :last_name => ''
Post.create :post_title => 'Welcome to Roroa', :post_type => 'page', :post_slug => 'welcome-to-roroa', :structured_url => '/welcome-to-roroa', :post_date => Time.now.to_s(:db), :admin_id => '1'
Post.create :post_title => 'First News Post', :post_type => 'post', :post_status => 'Published', :post_slug => 'first-news-post', :post_date => Time.now.to_s(:db), :admin_id => '1', :post_content => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis in mauris ac ultrices. Morbi interdum varius dictum. Nulla at ullamcorper lacus, non rutrum ante. Proin sed v'
Post.create :post_title => 'Contact', :post_type => 'page', :post_template => 'Contact', :post_status => 'Published', :structured_url => '/contact', :post_slug => 'contact', :post_date => Time.now.to_s(:db), :admin_id => '1', :post_content => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis in mauris ac ultrices. Morbi interdum varius dictum. Nulla at ullamcorper lacus, non rutrum ante. Proin sed v'
Menu.create :name => 'Header', :key => 'header'
Menu.create :name => 'Footer', :key => 'footer'
MenuOption.create :menu_id => '1', :parent_id => 0, :data_type => '', :lft => 1, :rgt => 8
MenuOption.create :menu_id => '1', :option_id => 1, :data_type => 'page', :lft => 2, :rgt => 3, :custom_data => 'type=page&linkto=1&label=Welcome+to+Roroa&class=&target=sw'
MenuOption.create :menu_id => '1', :option_id => 0, :data_type => ENV['articles_slug'], :lft => 4, :rgt => 5, :custom_data => "type=#{ENV['articles_slug']}&linkto=#{ENV['articles_slug']}&label=+#{ENV['articles_slug'].capitalize}&class=&target=sw"
MenuOption.create :menu_id => '1', :option_id => 1, :data_type => 'page', :lft => 6, :rgt => 7, :custom_data => 'type=page&linkto=3&label=Contact&class=&target=sw'

MenuOption.create :menu_id => '2', :parent_id => 0, :data_type => '', :lft => 1, :rgt => 8
MenuOption.create :menu_id => '2', :option_id => 1, :data_type => 'page', :lft => 2, :rgt => 3, :custom_data => 'type=page&linkto=1&label=Welcome+to+Roroa&class=&target=sw'
MenuOption.create :menu_id => '2', :option_id => 0, :data_type => ENV['articles_slug'], :lft => 4, :rgt => 5, :custom_data => "type=#{ENV['articles_slug']}&linkto=#{ENV['articles_slug']}&label=+#{ENV['articles_slug'].capitalize}&class=&target=sw"
MenuOption.create :menu_id => '2', :option_id => 1, :data_type => 'page', :lft => 6, :rgt => 7, :custom_data => 'type=page&linkto=3&label=Contact&class=&target=sw'
