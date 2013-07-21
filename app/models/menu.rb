class Menu < ActiveRecord::Base
	validates :name, :key, :presence => true
	has_many :menu_options, :dependent => :destroy

	def self.save_menu_on_fly(p)

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

		return true


	end
end