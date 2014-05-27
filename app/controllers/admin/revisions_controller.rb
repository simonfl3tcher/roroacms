class Admin::RevisionsController < AdminController

	# displays the revision post


	def edit
		# gets the individual post
		@post = Post.find(params[:id])

		@revision = { 'parent' => Post.find(@post.ancestry), 'revision' => @post}
		
		# set title 
		add_breadcrumb "Revisions"
		@title = 'Revision for "' + @revision['revision'].post_title + '"'
	end
	

	# restore the post to the given post data

	def restore
		# do the restore
		restore = Post.restore(Post.find(params[:id]))

		# redirect to either the post or page area depending on what post_type the post has
		if restore.post_type == 'page'
			redirect_to edit_admin_page_path(restore.id), notice: 'Page was successfully restored.'
		else
			redirect_to edit_admin_post_path(restore.id), notice: 'Post was successfully restored.'
		end
	end

end