class Admin < ActiveRecord::Base
	
	has_secure_password

	has_many :posts
	
	validates :email, presence: true, uniqueness: true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}

  	validates :username, :access_level, :presence => true 

	ACCESS_LEVELS = ["admin", "editor"]

	validates_uniqueness_of :email, :username

	validates_presence_of :password, :on => :create

	def self.setup_and_search(params)

		admins = Admin.where('1+1=2').page(params[:page]).per(Setting.get_pagination_limit)
		if params.has_key?(:search)
			admins = Admin.where("email like ? or first_name like ? or last_name like ? or username like ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%").page(params[:page]).per(Setting.get_pagination_limit)
		end

		return admins

	end

	def self.set_sessions(session, admin)

		session[:admin_id] = admin.id
		session[:username] = admin.username

	end

	def self.set_sessions_manually(session, i, name)
		session[:admin_id] = i
		session[:username] = name
	end

	def self.destroy_session(session)

		session[:admin_id] = nil
		session[:username] = nil

	end

	def self.post_status_sql(session)

		if !session[:admin_id].blank?

			status = "(post_status = 'Published')"

		else

			status = "(post_status = 'Published' AND post_date <= DATE(NOW()))"

		end

		return status

	end
	
end 