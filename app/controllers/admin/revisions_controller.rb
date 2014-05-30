class Admin::RevisionsController < AdminController

	# displays the revision post


	def edit
		# gets the individual post
		@post = Post.find(params[:id])

		@revision = { 'parent' => Post.find(@post.ancestry), 'revision' => @post}
		
		# set title 
		add_breadcrumb I18n.t("controllers.admin.revisions.breadcrumb_title")
		@title = I18n.t("controllers.admin.revisions.title", post_title: @revision['revision'].post_title)
	end
	

	# restore the post to the given post data

	def restore
		# do the restore
		restore = Post.restore(Post.find(params[:id]))

		# redirect to either the post or page area depending on what post_type the post has
		redirect_to edit_admin_page_path(restore.id), notice: I18n.t("controllers.admin.revisions.restore.flash.notice", post_type: restore.post_type.capitalize)
	end

end