class Admin::TrashController < AdminController

	before_filter :authorize_admin
	before_filter :authorize_admin_access

	def index 
		@posts = Post.find(:all, :conditions => { :disabled => 'Y', :post_type => 'post' })
		@pages = Post.find(:all, :conditions => { :disabled => 'Y', :post_type => 'page' })
	end

	def empty_posts 
		@type = params[:format]
		Post.where(:disabled => 'Y', :post_type => @type).destroy_all
		redirect_to admin_trash_path, notice: "All #{@type}s were removed from the trash can!"
		# respond_to do |format|
		# 	abort('you are in here')
		# 	format.html { redirect_to admin_trash_path, notice: 'All posts were removed from the trash can!' }
		# end
	end

	def empty_pages

	end

	def deal_with_form
		
		if !params[:posts].blank? 
			reinstate_posts params[:posts] 
		elsif !params[:pages].blank?
			reinstate_posts params[:pages]
		else
			return redirect_to admin_trash_path, notice: "There were no records to reinstate!"
		end

		redirect_to admin_trash_path, notice: "This record was successfully reinstated!"

	end

	def edit

		type = params[:type]
		
		post = Post.find(params[:id])
		post.disabled = "N"
		post.save

		
		respond_to do |format|
	      format.html { redirect_to admin_trash_path, notice: 'This record was successfully reinstated!' }
	    end

	end

	private

	def reinstate_posts posts

		posts.each do |val|
			post = Post.find(val)
			post.disabled = "N"
			post.save
		end

	end
end