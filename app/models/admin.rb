class Admin < ActiveRecord::Base

	has_secure_password
	
	# relations and validations

	has_many :posts
	validates :email, presence: true, uniqueness: true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  	validates :username, :access_level, :presence => true 
	validates_uniqueness_of :email, :username
	validates_presence_of :password, :on => :create

	# general data that doesn't change very often mainly for views

	ACCESS_LEVELS = ["admin", "editor"]
	GET_ADMINS = Admin.where('1=1').order('name asc')


	# get all the admins in the system - however if there is a search parameter 
	# search the necessary fields for the given value

	def self.setup_and_search(params)
		if params.has_key?(:search)
			admins = Admin.where("email like ? or first_name like ? or last_name like ? or username like ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%").page(params[:page]).per(Setting.get_pagination_limit)
		else 
			admins = Admin.where('1+1=2').page(params[:page]).per(Setting.get_pagination_limit)
		end
		
		return admins
	end

	# set the session data for the admin to allow/restrict the necessary areas

	def self.set_sessions(session, admin)
		session[:admin_id] = admin.id
		session[:username] = admin.username
	end

	def self.set_sessions_manually(session, i, name)
		session[:admin_id] = i
		session[:username] = name
	end


	# destroy the session data - logging them out of the admin panel

	def self.destroy_session(session)
		session[:admin_id] = nil
		session[:username] = nil
	end

end 