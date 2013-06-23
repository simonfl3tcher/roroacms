class Admin::MediaController < AdminController

	include ControllersHelper

	def index
		@files = Media.setup_and_search_posts params
	end

	def delete
		AWS::S3::S3Object.find(params[:file], BUCKET).delete
	    redirect_to admin_media_path, notice: 'File was successfully deleted.' 
	end

	def bulk_update
		bulk_update_media params
	end

end