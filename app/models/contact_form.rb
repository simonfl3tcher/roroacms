class ContactForm < ActiveRecord::Base
	validates :name, :message, :email, :subject, :presence => true
end