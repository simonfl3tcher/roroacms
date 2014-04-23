class Admin::TrashController < AdminController

	# the trash area saves any posts/pages that were moved to trash in the trash can.
	# you can then decide if you want to remove these completely or reinstate them - put simply it is a fail
	# safe so that you don't accidently delete something that you didn't want to delete

	# check if the admin is allowed to access this area
	before_filter :authorize_admin_access

	def index 
		# get all posts/pages that are in the trash area
		@posts = Post.find(:all, :conditions => { :disabled => 'Y', :post_type => 'post' })
		@pages = Post.find(:all, :conditions => { :disabled => 'Y', :post_type => 'page' })
	end


	# remvove all of the posts/pages in the trash area in one go

	def empty_posts 
		@type = params[:format]
		Post.where(:disabled => 'Y', :post_type => @type).destroy_all
		
		redirect_to admin_trash_path, notice: "All #{@type}s were removed from the trash can."
	end
	

	# delete an individual post/pages

	def destroy
	    @post = Post.find(params[:id])
	    @post.destroy

	   	redirect_to admin_trash_path, notice: "This record was successfully destroyed."
	end


	# Takes all of the checked options and updates them with the given option selected. 
	# The options for the bulk update in pages area are:-
	# - Reinstate
	# - Destroy

	def deal_with_form
		# do the action required the function then returns the message to display to the user
		notice = Trash.deal_with_form params

		respond_to do |format|
	      format.html { redirect_to admin_trash_path, notice: notice }
	    end
	end

end