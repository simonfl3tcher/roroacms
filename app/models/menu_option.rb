class MenuOption < ActiveRecord::Base

  ## associations ##

  belongs_to :menu

  ## methods ##

  # saves the menu on the fly via an ajax call. This is a seperate function because
  # the ajax call sends through a json object. It decodes this, updates the values and saves the menu
  # Params:
  # +p+:: json object sent through from the menu page

  def self.save_menu_on_fly(p)

    return true if p[:data].blank?

    f = ActiveSupport::JSON.decode p[:data]
    MenuOption.destroy_all(:menu_id => p[:menuid])

    f.each do | record |

      opt = MenuOption.new
      opt.menu_id = p[:menuid]
      opt.parent_id = record['parent_id']
      opt.data_type = record['data_type'].to_s.gsub(/\s+/, "")
      opt.option_id = record['item_id']
      opt.lft = record['left']
      opt.rgt = record['right']

      opt.custom_data = record['custom_data']

      opt.save

    end

    true
  end

end
