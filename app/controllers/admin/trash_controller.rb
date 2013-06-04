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

		action = params[:to_do]
		action = action.gsub(' ', '_')

		case action.downcase 
			when "reinstate"
					if !params[:posts].blank? 
						reinstate_posts params[:posts] 
					elsif !params[:pages].blank?
						reinstate_posts params[:pages]
					else
						return redirect_to admin_trash_path, notice: "There were no records to reinstate."
					end

					redirect_to admin_trash_path, notice: "These records was successfully reinstated."
			when "destroy"
				if !params[:posts].blank? 
					delete_posts params[:posts] 
				elsif !params[:pages].blank?
					delete_posts params[:pages]
				else
					return redirect_to admin_trash_path, notice: "There were no records to delete."
				end
				redirect_to admin_trash_path, notice: "These records was successfully deleted."
			else
				respond_to do |format|
			      format.html { redirect_to admin_trash_path, notice: 'Nothing was done' }
			    end
		end
	end

	def edit

		type = params[:type]
		
		post = Post.find(params[:id])
		post.disabled = "N"
		post.save

		
		respond_to do |format|
	      format.html { redirect_to admin_trash_path, notice: 'This record was successfully reinstated.' }
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

	def delete_posts posts 

		posts.each do |val|
			post = Post.find(val)
			post.destroy
		end

	end
end