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
		redirect_to admin_trash_path, notice: "All #{@type}s were removed from the trash can."
	end

	def destroy
	    @post = Post.find(params[:id])
	    @post.destroy

	   	redirect_to admin_trash_path, notice: "This record was successfully destroyed."

	end

	def empty_pages

	end

	def deal_with_form
		
		notice = Trash.deal_with_form params
		respond_to do |format|
	      format.html { redirect_to admin_trash_path, notice: notice }
	    end

	end

	def edit
		Trash.reinstate_post params[:id]
		respond_to do |format|
	      format.html { redirect_to admin_trash_path, notice: 'This record was successfully reinstated.' }
	    end

	end
end