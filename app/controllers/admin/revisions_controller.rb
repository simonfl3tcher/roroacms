class Admin::RevisionsController < AdminController

	before_filter :authorize_admin

	def index 
		@time = Time.now
	end

	def edit
		post = Post.find(params[:id])
		parent = Post.find(post.parent_id)

		@revisions = Post.where(:parent_id => post.parent_id, :post_type => 'autosave').order('created_at desc')
		@revision = { 'parent' => parent, 'revision' => post}
	end

	def restore
		
		post = Post.find(params[:id])
		restore = Post.restore post 
		redirect_to edit_admin_post_path(restore), notice: 'Post was successfully restored.'

	end
end