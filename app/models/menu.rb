class Menu < ActiveRecord::Base
	
	## associations ##

	has_many :menu_options, :dependent => :destroy

	## validations ##

	validates :name, :key, :presence => true

end