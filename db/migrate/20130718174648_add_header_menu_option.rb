class AddHeaderMenuOption < ActiveRecord::Migration
  def up
  	Menu.create :name => 'Header', :key => 'header'
  	MenuOption.create :menu_id => '1', :parent_id => 0, :data_type => '', :lft => 1, :rgt => 6
  	MenuOption.create :menu_id => '1', :option_id => 1, :data_type => 'page', :lft => 2, :rgt => 3, :custom_data => 'type=page&linkto=1&label=Welcome+to+Roroa&class=&target=sw'
  	MenuOption.create :menu_id => '1', :option_id => 0, :data_type => APP_CONFIG['articles_slug'], :lft => 4, :rgt => 5, :custom_data => "type=#{APP_CONFIG['articles_slug']}&linkto=#{APP_CONFIG['articles_slug']}&label=+#{APP_CONFIG['articles_slug'].capitalize}&class=&target=sw"
  end
end
