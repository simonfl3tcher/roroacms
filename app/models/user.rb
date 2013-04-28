class User < ActiveRecord::Base
	
	has_secure_password

	attr_accessible :email, :password, :access_level, :first_name, :last_name, :website, :password_confirmation
  
  	validates :email, presence: true, uniqueness: true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create }

  	validates :first_name, :last_name, :presence => true

  	validates_presence_of :password, :on => :create

  	validates_confirmation_of :password
	
end