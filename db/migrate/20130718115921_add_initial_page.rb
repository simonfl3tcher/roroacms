class AddInitialPage < ActiveRecord::Migration
  def up
  	Post.create :post_title => 'Welcome to Roroa', :post_type => 'page', :post_slug => 'welcome-to-roroa', :structured_url => '/welcome-to-roroa', :post_date => Time.now.to_s(:db), :admin_id => '1', :post_content => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis in mauris ac ultrices. Morbi interdum varius dictum. Nulla at ullamcorper lacus, non rutrum ante. Proin sed v'
  	Post.create :post_title => 'First News Post', :post_type => 'post', :post_status => 'Published', :post_slug => 'first-news-post', :post_date => Time.now.to_s(:db), :admin_id => '1', :post_content => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis in mauris ac ultrices. Morbi interdum varius dictum. Nulla at ullamcorper lacus, non rutrum ante. Proin sed v'
  end
end
