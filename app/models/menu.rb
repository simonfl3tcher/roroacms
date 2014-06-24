class Menu < ActiveRecord::Base
	
	# relations and validations

	validates :name, :key, :presence => true
	has_many :menu_options, :dependent => :destroy

end