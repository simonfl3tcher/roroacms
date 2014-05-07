class Admin < ActiveRecord::Base
	
	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
	
	# relations and validations

	has_many :posts
	validates :username, presence: true, uniqueness: true

	# general data that doesn't change very often

	ACCESS_LEVELS = ["admin", "editor"]
	GET_ADMINS = Admin.where('1+1=2').order('name asc')


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

	def self.find_for_database_authentication(conditions={})
	  self.where("username = ?", conditions[:email]).limit(1).first || self.where("email = ?", conditions[:email]).limit(1).first
	end

	def self.find_record(login)
		abort login.inspect
		where(["username = :value OR email = :value", { :value => login }]).first
	end


end 