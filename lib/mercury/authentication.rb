module Mercury
  module Authentication

    def can_edit?

    	if current_admin.nil?
    		redirect_to root_path
    	else
    		true
    	end

    end

    def current_admin
	  	@current_admin ||= Admin.find(session[:admin_id]) if session[:admin_id]
	  end
  end
end
