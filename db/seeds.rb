# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Setting.create :setting_name => 'articles_slug', :type_of_setting => 'G', :setting => APP_CONFIG['articles_slug']
Setting.create :setting_name => 'home_page', :type_of_setting => 'G', :setting => '1'
Setting.create :setting_name => 'seo_home_title', :type_of_setting => 'SEO', :setting => APP_CONFIG['site_title']
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
Setting.create :setting_name => 'seo_site_title', :type_of_setting => 'SEO', :setting => APP_CONFIG['site_title']
Setting.create :setting_name => 'category_slug', :type_of_setting => 'G', :setting => APP_CONFIG['category_slug']
Setting.create :setting_name => 'article_comments', :type_of_setting => 'COMMENTS', :setting => 'Y'
Setting.create :setting_name => 'article_comment_type', :type_of_setting => 'COMMENTS', :setting => 'R'
Setting.create :setting_name => 'site_url', :type_of_setting => 'G', :setting => APP_CONFIG['site_url']
Setting.create :setting_name => 'display_url', :type_of_setting => 'G', :setting => APP_CONFIG['display_url']
Setting.create :setting_name => 'tag_slug', :type_of_setting => 'G', :setting => APP_CONFIG['tag_slug']
Setting.create :setting_name => 'site_email', :type_of_setting => 'G', :setting => APP_CONFIG['admin_email']
Setting.create :setting_name => 'aws_access_key_id', :type_of_setting => 'AWS', :setting => APP_CONFIG['aws_access_key_id']
Setting.create :setting_name => 'aws_secret_access_key', :type_of_setting => 'AWS', :setting => APP_CONFIG['aws_secret_access_key']
Setting.create :setting_name => 'aws_bucket_name', :type_of_setting => 'AWS', :setting => APP_CONFIG['aws_bucket_name']
Setting.create :setting_name => 'pagination_per', :type_of_setting => 'G', :setting => ''
Setting.create :setting_name => 'theme_folder', :type_of_setting => 'T', :setting => APP_CONFIG['theme_folder']
Admin.create :username => APP_CONFIG['admin_username'], :password => APP_CONFIG['admin_password'], :email => APP_CONFIG['admin_email'], :access_level => 'admin', :first_name => '', :last_name => ''
Post.create :post_title => 'Welcome to Roroa', :post_type => 'page', :post_slug => 'welcome-to-roroa', :structured_url => '/welcome-to-roroa', :post_date => Time.now.to_s(:db), :admin_id => '1', :post_content => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis in mauris ac ultrices. Morbi interdum varius dictum. Nulla at ullamcorper lacus, non rutrum ante. Proin sed v'
Post.create :post_title => 'First News Post', :post_type => 'post', :post_status => 'Published', :post_slug => 'first-news-post', :post_date => Time.now.to_s(:db), :admin_id => '1', :post_content => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis in mauris ac ultrices. Morbi interdum varius dictum. Nulla at ullamcorper lacus, non rutrum ante. Proin sed v'
Menu.create :name => 'Header', :key => 'header'
MenuOption.create :menu_id => '1', :parent_id => 0, :data_type => '', :lft => 1, :rgt => 6
MenuOption.create :menu_id => '1', :option_id => 1, :data_type => 'page', :lft => 2, :rgt => 3, :custom_data => 'type=page&linkto=1&label=Welcome+to+Roroa&class=&target=sw'
MenuOption.create :menu_id => '1', :option_id => 0, :data_type => APP_CONFIG['articles_slug'], :lft => 4, :rgt => 5, :custom_data => "type=#{APP_CONFIG['articles_slug']}&linkto=#{APP_CONFIG['articles_slug']}&label=+#{APP_CONFIG['articles_slug'].capitalize}&class=&target=sw"
 