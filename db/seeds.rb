# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "#{Roroacms::Engine.root}/app/models/roroacms/setting.rb"
require "#{Roroacms::Engine.root}/app/helpers/roroacms/general_helper.rb"
require "#{Roroacms::Engine.root}/app/helpers/roroacms/media_helper.rb"
require "#{Roroacms::Engine.root}/app/models/roroacms/post.rb"

Roroacms::Setting.create(:setting_name => 'articles_slug', :type_of_setting => 'G')
Roroacms::Setting.create(:setting_name => 'home_page', :type_of_setting => 'G', :setting => '1')
Roroacms::Setting.create(:setting_name => 'seo_home_title', :type_of_setting => 'SEO') 
Roroacms::Setting.create(:setting_name => 'seo_home_description', :type_of_setting => 'SEO')
Roroacms::Setting.create(:setting_name => 'seo_rewrite_titles', :type_of_setting => 'SEO')
Roroacms::Setting.create(:setting_name => 'seo_canonical_urls', :type_of_setting => 'SEO')
Roroacms::Setting.create(:setting_name => 'seo_404_title', :type_of_setting => 'SEO')
Roroacms::Setting.create(:setting_name => 'seo_404_description', :type_of_setting => 'SEO')
Roroacms::Setting.create(:setting_name => 'seo_google_analytics_code', :type_of_setting => 'SEO')
Roroacms::Setting.create(:setting_name => 'seo_no_index_categories', :type_of_setting => 'SEO')
Roroacms::Setting.create(:setting_name => 'seo_no_index_archives', :type_of_setting => 'SEO')
Roroacms::Setting.create(:setting_name => 'seo_autogenerate_descriptions', :type_of_setting => 'SEO')
Roroacms::Setting.create(:setting_name => 'seo_site_title', :type_of_setting => 'SEO')
Roroacms::Setting.create(:setting_name => 'category_slug', :type_of_setting => 'G')
Roroacms::Setting.create(:setting_name => 'article_comments', :type_of_setting => 'COMMENTS', :setting => 'Y')
Roroacms::Setting.create(:setting_name => 'article_comment_type', :type_of_setting => 'COMMENTS', :setting => 'R')
Roroacms::Setting.create(:setting_name => 'site_url', :type_of_setting => 'G')
Roroacms::Setting.create(:setting_name => 'tag_slug', :type_of_setting => 'G')
Roroacms::Setting.create(:setting_name => 'site_email', :type_of_setting => 'G')
Roroacms::Setting.create(:setting_name => 'pagination_per', :type_of_setting => 'G', :setting => 25)
Roroacms::Setting.create(:setting_name => 'pagination_per_fe', :type_of_setting => 'G', :setting => 10)
Roroacms::Setting.create(:setting_name => 'theme_folder', :type_of_setting => 'T')
Roroacms::Setting.create(:setting_name => 'aws_access_key_id', :type_of_setting => 'AWS')
Roroacms::Setting.create(:setting_name => 'aws_secret_access_key', :type_of_setting => 'AWS')
Roroacms::Setting.create(:setting_name => 'aws_bucket_name', :type_of_setting => 'AWS')
Roroacms::Setting.create(:setting_name => 'aws_folder', :type_of_setting => 'AWS')
Roroacms::Setting.create(:setting_name => 'smtp_address', :type_of_setting => 'EMAIL')
Roroacms::Setting.create(:setting_name => 'smtp_domain', :type_of_setting => 'EMAIL')
Roroacms::Setting.create(:setting_name => 'smtp_port', :type_of_setting => 'EMAIL')
Roroacms::Setting.create(:setting_name => 'smtp_username', :type_of_setting => 'EMAIL')
Roroacms::Setting.create(:setting_name => 'smtp_password', :type_of_setting => 'EMAIL')
Roroacms::Setting.create(:setting_name => 'smtp_authentication', :type_of_setting => 'EMAIL')
Roroacms::Setting.create(:setting_name => 'setup_complete', :type_of_setting => 'G')
Roroacms::Setting.create(:setting_name => 'tour_taken', :type_of_setting => 'G', :setting => 'N')
Roroacms::Setting.create(:setting_name => 'url_prefix', :type_of_setting => 'G', :setting => 'http://')
Roroacms::Setting.create(:setting_name => 'breadcrumb_seperator', :type_of_setting => 'G', :setting => '/')
Roroacms::Setting.create(:setting_name => 'demonstration_mode', :type_of_setting => 'G', :setting => 'N')
Roroacms::Setting.create(:setting_name => 'user_groups', :type_of_setting => 'G', :setting => '{"admin":["posts","banners","terms","comments","media","menus","pages","revisions","settings","themes","trash","administrators","articles","banners","terms","comments","media","menus","pages","revisions","themes","trash","markdown"]}')

Roroacms::Post.create(:post_title => 'Sample page', :post_type => 'page', :post_status => 'Published', :post_slug => 'sample', :structured_url => '/sample', :post_date => Time.now.to_s(:db), :admin_id => '1', :post_content => '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus sollicitudin a orci ut tempor. Praesent in diam sagittis ligula sodales iaculis. Suspendisse ante nisi, sagittis quis elementum ac, tempor at nisi. Vestibulum convallis luctus nisi, ac tincidunt velit facilisis at. Duis eget rhoncus mi, sit amet fringilla felis. Pellentesque egestas, nisi ullamcorper venenatis vehicula, ipsum sem congue velit, sit amet molestie orci massa quis sapien. Aliquam in nisl quis augue ultricies interdum. Aenean pretium, lacus et posuere porttitor, velit erat placerat mi, tristique bibendum tellus magna sit amet elit. Donec turpis tellus, elementum nec consequat vel, tempus et turpis. Nunc quis elit volutpat, congue justo ac, sollicitudin diam. Etiam rhoncus nibh at ipsum porttitor mollis.</p>

<p>Fusce rutrum, ante at sodales fermentum, mi ligula egestas turpis, quis vulputate metus tellus id neque. Mauris placerat ipsum orci, vitae ornare orci pharetra et. Vestibulum sollicitudin bibendum rhoncus. Sed sit amet dolor eu augue consequat iaculis eu sit amet lectus. Etiam sit amet cursus tellus. Vestibulum id placerat odio, quis posuere leo. Morbi fringilla dapibus massa ut pretium. Proin nec augue lacus. Nullam porttitor lectus in libero dapibus consequat. Etiam sit amet diam a lorem rhoncus varius vitae nec turpis. Vestibulum mattis interdum eros, at consequat lectus fermentum et. Quisque vehicula scelerisque metus, ac viverra tortor lacinia eu.</p>

<p>Etiam vitae eros vulputate, eleifend enim sit amet, vulputate tellus. Morbi tincidunt velit velit, vitae lacinia ipsum lacinia non. Integer id tincidunt enim. Pellentesque et laoreet libero. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Maecenas bibendum faucibus felis eget consectetur. Vivamus scelerisque sagittis odio vitae vestibulum. Phasellus tempus consectetur elementum. Nam scelerisque eu erat quis laoreet. Etiam ipsum lacus, faucibus sit amet venenatis vel, suscipit ut purus. Morbi et felis nec ante fringilla sagittis vel eget ipsum. Etiam facilisis tempus tellus. Curabitur mattis lorem id imperdiet volutpat.</p>

<p>Aliquam varius, nisi at dignissim suscipit, massa mauris mattis nisi, eget faucibus erat lacus at sem. Ut et diam risus. Vestibulum nec molestie nisi, ac mattis leo. Proin tempor imperdiet lorem eu hendrerit. Integer et eros nec libero tempor viverra sed sed quam. Nulla tincidunt lacus mauris, ac consequat nunc molestie id. Sed nec urna vitae elit eleifend semper. Proin vitae fermentum augue.</p>')

Roroacms::Post.create(:post_title => 'Sample Post', :post_type => 'post', :post_status => 'Published', :post_slug => 'sample-post', :structured_url => '/sample-post', :post_date => Time.now.to_s(:db), :admin_id => '1', :post_content => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis in mauris ac ultrices. Morbi interdum varius dictum. Nulla at ullamcorper lacus, non rutrum ante. Proin sed v')