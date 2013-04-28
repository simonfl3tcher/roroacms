class Admin::RevisionsController < AdminController

	before_filter :authorize_admin

	def index 
		@time = Time.now
	end

	def edit
		post = Post.find(params[:id])
		parent = Post.find(post.post_parent)

		@revisions = Post.where(:post_parent => post.post_parent, :post_type => 'autosave').order('created_at desc')
		@revision = { 'parent' => parent, 'revision' => post}
	end

	def restore
		
		post = Post.find(params[:id])
		parent = Post.find(post.post_parent)

		parent.post_content = post.post_content
		parent.post_date = post.post_date
		parent.post_name = post.post_name
		parent.post_slug = post.post_slug
		parent.post_title = post.post_title
		parent.disabled = post.disabled

		parent.save

		redirect_to edit_admin_post_path(parent.id), notice: 'Post was successfully restored.'

	end
end