class Admin::FilebrowserController < AdminController

	helper FilebrowserHelper
	# skip_before_filter :authorize_admin

	layout "filebrowser"

	 BUCKET = Setting.find_by_setting_name('aws_bucket_name')[:setting]

	include AWS::S3

	def index
		
			@files = AWS::S3::Bucket.find(BUCKET).objects
			@folder = @files.find('images')
	end

	def upload

		session[:return_to] ||= request.referer

		if params[:manualBrowse]
			session[:return_to] = "#{session[:return_to]}?manualBrowse=true"
		end

	    if !params[:file].blank?

	      if params[:dir].blank?

	        dir = ''
	        where = BUCKET
	      else
	        dir = params[:dir]
	        where = "#{BUCKET}/#{dir}/"
	      end


	      begin
	        @file = AWS::S3::S3Object.store(sanitize_filename(params[:file].original_filename), params[:file].read, where, :access => :public_read)
	        
	        redirect_to session[:return_to], notice: 'File was successfully uploaded.'
	       
	      rescue
	      	redirect_to session[:return_to], notice: 'Couldn\'t complete the upload.' 
	      end

	    elsif !params[:create_dir].blank?

	       begin
	          AWS::S3::S3Object.store("#{params[:create_dir]}/", "#{params[:create_dir]}/", BUCKET, :access => :public_read)
	          redirect_to session[:return_to]
	        rescue
	          redirect_to session[:return_to], notice: "Couldn't create the folder"
	        end
	    else

	    	redirect_to session[:return_to], notice: "Nothing Was Done"
	    end	
	  end

	def delete
		session[:return_to] ||= request.referer
	    if (params[:file])
	      AWS::S3::S3Object.find(params[:file], BUCKET).delete
	      redirect_to session[:return_to], notice: 'File was successfully deleted.' 
	    else
	      render :text => "No song was found to delete!"
	    end
	  end

	  def create_folder
	    begin
	      AWS::S3::S3Object.store('pdfs/', 'pdfs/', BUCKET, :access => :public_read)
	      redirect_to root_path
	    rescue
	      render :text => "Couldn't complete the upload"
	    end
	  end

	  private

	  def sanitize_filename(file_name)
	    just_filename = File.basename(file_name)
	    just_filename.sub(/[^\w\.\-]/,'_')
	  end

end