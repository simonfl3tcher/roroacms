module Roroacms 	
	class Menu < ActiveRecord::Base

	  ## associations ##

	  has_many :menu_options, :dependent => :destroy

	  ## validations ##

	  validates :name, :key, :presence => true

	  before_save :deal_with_key

	  def deal_with_key
	  	self.key = key.gsub(' ', '-')
	  end

	end
end