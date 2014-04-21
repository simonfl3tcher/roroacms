class ContactForm < ActiveRecord::Base
	# relations and validations
	validates :name, :message, :email, :subject, :presence => true
end