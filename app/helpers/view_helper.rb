module ViewHelper

	def display_content

		

		if !session[:admin_id].blank?

			admin = Admin.find(session[:admin_id])

			if admin.inline_editing == 'Y'

				html = "<p class='editable'><button id='editButton'class='btn btn-mini' onclick='clickToEdit();'><i class='icon-pencil'></i>&nbsp;Edit</button><button id='saveButton' class='btn btn-mini' onclick='clickToSave();'><i class='icon-save'></i>&nbsp;Save</button></p><div id='editable_content' data-reference='#{@content.id}'>#{@content.post_content.html_safe}</div>"
				render :inline => html.html_safe
			end

		else 

			render :inline => @content.post_content.html_safe

		end

	end

	def display_title

		render :inline => @content.post_title

	end

	def display_date format = nil

		if format

			render :inline => @content.post_date.strftime(format)

		else

			render :inline => @content.post_date.strftime("%d-%m-%Y")

		end

	end

	def get_the_content post

		render :inline => post.post_content.html_safe

	end

	def get_the_title post

		render :inline => post.post_title

	end

	def get_the_date post, format = nil

		if format

			render :inline => post.post_date.strftime(format)

		else

			render :inline => post.post_date.strftime("%d-%m-%Y")

		end

	end

	def get_the_permalink post

		article_url = Setting.where(:setting_name => 'articles_slug').first.setting

		if post.post_type == 'post'

			render :inline => "http://localhost:3000/#{article_url}/#{post.post_slug}"
		
		else 

			render :inline => "http://localhost:3000/#{post.post_slug}"

		end

	end

	def get_archive_caption

		render :inline => 'Archive area'

	end

	def get_notifications

		if flash[:notice]
	    	html = "<div class='alert alert-success'><button type='button' class='close' data-dismiss='alert'>x</button><strong>Success!</strong> #{flash[:notice]}</div>"
	    	render :inline => html.html_safe
	    elsif flash[:error]
	    	html = "<div class='alert alert-danger'><button type='button' class='close' data-dismiss='alert'>x</button><strong>Error!</strong> #{flash[:error]}</div>"
	    	render :inline => html.html_safe
	    end
	end

	def get_comments_form

		comments_on = Setting.where(:setting_name => 'article_comments').first.setting

		if comments_on == 'Y'

			type = Setting.where(:setting_name => 'article_comment_type').first.setting

			render(:template =>"pages/comments_form.html.erb", :layout => nil, :locals => { :type => type }).to_s

		else

			return false

		end

	end

	def site_url

		return Setting.where(:setting_name => 'site_url').first.setting
	end
end