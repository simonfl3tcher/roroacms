class Admin::MediaController < AdminController

	include ControllersHelper
	include AWS::S3

	def index
		@files = AWS::S3::Bucket.find(BUCKET).objects
	end

	def delete
		AWS::S3::S3Object.find(params[:file], BUCKET).delete
	    redirect_to admin_media_path, notice: 'File was successfully deleted.' 
	end

	def bulk_update
		bulk_update_media params
	end

end