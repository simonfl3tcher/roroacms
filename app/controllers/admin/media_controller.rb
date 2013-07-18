class Admin::MediaController < AdminController

	def index
		@initial = true
	end

	def create 

		if !params[:create_dir].blank?

			Media.create params
	       	
	    end

	end

	def multipleupload

		if !params[:file].blank?

			Media.advanced_create params
			
		else
			render :text => "No Files!"
		end
	end

	def get_via_ajax 

		@slash_count = params[:key].count('/').to_i

		if params[:key] == 'all'
			@files = Media.setup_and_search_posts
			@initial = true
		else 
			@files = Media.get_by_key params
		end
		print render :partial => 'admin/media/media_loop'

	end

	def delete
		AWS::S3::S3Object.find(params[:file], BUCKET).delete
	end

	def rename_media 
		AWS::S3::S3Object.rename params[:previous], params[:new], Setting.find_by_setting_name('aws_bucket_name')[:setting]
		render :text => "Success!"
	end
	
	def get_folder_list
		
		@initial = true
		@r = Media.get_folder_list params
		print render :partial => 'admin/media/media_folder_loop'
	end

	def delete_via_ajax
		AWS::S3::S3Object.find(params[:file], BUCKET).delete
		render :text => "done"
	end

end