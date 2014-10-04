module Roroacms
	
	class Admin::DashboardController < AdminController

	  # interface to the admin dashboard
	  def index
	    @comments = latest_comments
	    @counts = {:page => get_count_post('page'), :post => get_count_post('post'), :comments => @comments.size }
	  end

	end

end