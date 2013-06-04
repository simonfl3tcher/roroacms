class Admin::MediaController < AdminController

	BUCKET = Setting.find_by_setting_name('aws_bucket_name')[:setting]
	include AWS::S3

	def index

		@files = AWS::S3::Bucket.find(BUCKET).objects

	end

	def delete
		AWS::S3::S3Object.find(params[:file], BUCKET).delete
	    redirect_to admin_media_path, notice: 'File was successfully deleted.' 
	end

	def show

	end

	
	def bulk_update
		action = params[:to_do]
		action = action.gsub(' ', '_')

		if params[:media].nil?
			action = ""
		end
		case action.downcase 
			when "move_to_trash"
				bulk_update_destroy params[:media]
				respond_to do |format|
			      format.html { redirect_to admin_media_path, notice: 'Media were successfully destroyed.' }
			    end
			else
			
			respond_to do |format|
		      format.html { redirect_to admin_media_path, notice: 'Nothing was done' }
		    end
		end
	end

	def bulk_update_destroy params

		params.each do |val|
			AWS::S3::S3Object.find(val, BUCKET).delete
		end

	end


end