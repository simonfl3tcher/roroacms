class Install < ActiveRecord::Migration
  def up
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
  end

end