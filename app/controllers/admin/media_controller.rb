class Admin::MediaController < AdminController

	# The media area is fully controlled by ajax. The index method creates the view
	# any calls after this are done via ajax

	# has all the functions for carrying out the work

	include MediaHelper

	# is used just for displaying the page. As soon as the page lods it runs an ajax call
	# that then goes to get_via_ajax to get all of the files.

	def index
		@initial = true
	end

	# Creates a directory with the name given in the params[:create_dir] value.
	# this method is called via ajax

	def create 
		if !params[:create_dir].blank?
			media_create params	
	    end
	end

	# This is called via an ajax call when you select/drop the files on the drop zone.

	def multipleupload
		if !params[:file].blank?
			media_advanced_create params
		else
			render :text => "No Files!"
		end
	end

	# gets all of the media from the S3 account that you have set up in the settings area in the admin
	# it then runs through them and displays them in the necessary way by this I mean that it gets folders 
	# as well as all different kinds of media so the view splits this all up for you.

	def get_via_ajax 
		@slash_count = params[:key].count('/').to_i

		if params[:key] == 'all'

			@files = media_setup_and_search_posts
			@initial = true

		else 
			@files = media_get_by_key params
		end

		print render :partial => 'admin/media/media_loop'
	end

	# deletes a directory or a file.

	def delete
		AWS::S3::S3Object.find(params[:file], BUCKET).delete
	end

	# deletes a directory or a file just via ajax.

	def delete_via_ajax
		AWS::S3::S3Object.find(params[:file], BUCKET).delete
		render :text => "done"
	end

	# renames the files. Currently you cannot rename directories once they are created.

	def rename_media 
		AWS::S3::S3Object.rename params[:previous], params[:new], Setting.find_by_setting_name('aws_bucket_name')[:setting]
		render :text => "Success!"
	end

	# gets all the folders in a nested view
	
	def get_folder_list
		@initial = true
		@r = media_get_folder_list params
		print render :partial => 'admin/media/media_folder_loop'
	end

end