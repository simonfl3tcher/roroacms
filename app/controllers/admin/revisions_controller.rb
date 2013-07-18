class Admin::RevisionsController < AdminController

	before_filter :authorize_admin

	def index 
		@time = Time.now
	end

	def edit
		post = Post.find(params[:id])
		parent = Post.find(post.parent_id)

		@revisions = Post.where(:ancestry => post.parent_id, :post_type => 'autosave').order('created_at desc')
		@revision = { 'parent' => parent, 'revision' => post}
	end

	def restore
		
		post = Post.find(params[:id])
		restore = Post.restore post
		if restore.post_type == 'page'
			redirect_to edit_admin_page_path(restore.id), notice: 'Page was successfully restored.'
		else
			redirect_to edit_admin_post_path(restore.id), notice: 'Post was successfully restored.'
		end
	end
end