class Admin::CommentsController < AdminController

	add_breadcrumb I18n.t("generic.comments"), :admin_comments_path, :title => I18n.t("controllers.admin.comments.breadcrumb")

	# list out all of the comments
	def index 
		# set title
		set_title(I18n.t("generic.comments"))
	end


	# get and disply certain comment

	def edit
		# add breadcrumb and set title
		add_breadcrumb I18n.t("controllers.admin.comments.edit.breadcrumb")
		set_title(I18n.t("controllers.admin.comments.edit.title"))
		
		@comment = Comment.find(params[:id])
	end
	

	# update the comment. You are able to update everything about the comment as an admin

	def update
	    @comment = Comment.find(params[:id])
	    atts = comments_params
	    #  remove any html from the comment as we do not need it and it can be detrimental to the system
	    atts[:comment] = atts[:comment].to_s.gsub(%r{</?[^>]+?>}, '')

	    respond_to do |format|

	      if @comment.update_attributes(atts)
	     	format.html { redirect_to edit_admin_comment_path(@comment), notice: I18n.t("controllers.admin.comments.update.flash.success") }
	      else
	        format.html { 
	        	# add breadcrumb and set title
	        	add_breadcrumb I18n.t("controllers.admin.comments.edit.breadcrumb")				
	        	render action: "edit" 
	        }
	      end

	    end
	end


	# delete the comment

	def destroy
 		@comment = Comment.find(params[:id])
	    @comment.destroy

	    respond_to do |format|
	      format.html { redirect_to admin_comments_path, notice: I18n.t("controllers.admin.comments.destroy.flash.success") }
	    end

	end


	# bulk_update function takes all of the checked options and updates them with the given option selected. The options for the bulk update in comments area are
	# - Unapprove
	# - Approve
	# - Mark as Spam
	# - Destroy

	def bulk_update
		# This is what makes the update
		func = Comment.bulk_update params

		respond_to do |format|
	      format.html { redirect_to admin_comments_path, notice: func == 'ntd' ? I18n.t("controllers.admin.comments.bulk_update.flash.nothing_to_do") :  I18n.t("controllers.admin.comments.bulk_update.flash.success", func: func) }
	    end

	end


	# mark_as_spam function is a button on the ui and so need its own function. The function simply marks the comment as spam against the record in the database. 
	# the record is then not visable unless you explicity tell the system that you want to see spam records.

	def mark_as_spam
		comment = Comment.find(params[:id])
		comment.comment_approved = "S"
		respond_to do |format|
			if comment.save
				format.html { redirect_to admin_comments_path, notice: I18n.t("controllers.admin.comments.mark_as_spam.flash.success") }
			else
				format.html { render action: "index" }
			end
		end
	end
	

	private
	
	# Strong parameters

	def comments_params
		params.require(:comment).permit(:post_id, :author, :email, :website, :comment, :comment_approved, :parent_id, :is_spam, :commit, :submitted_on)
	end

end