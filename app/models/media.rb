class Media < ActiveRecord::Base

	# get the name of the S3 bucket that is set in the admin panel
	BUCKET = Setting.find_by_setting_name('aws_bucket_name')[:setting]
	
	include AWS::S3

	# get all objects inside the BUCKET 

	def self.setup_and_search_posts url = nil
		if url.nil?    
			files = AWS::S3::Bucket.find("#{BUCKET}").objects
		else 
			# if url is defined it will either get all objects inside a directory or get an inidividual
			# file depending on the type of string passed in through prefix

			files = AWS::S3::Bucket.objects(Setting.find_by_setting_name('aws_bucket_name')[:setting], :prefix => url)
		end
		
		files
	end

	# create the object in S3 this  a directory

	def self.create(p) 
		begin
			# create the object and store it in S3
			AWS::S3::S3Object.store("#{p[:create_dir]}/", "#{p[:create_dir]}/", BUCKET, :access => :public_read, :content_type => 'binary/octet-stream')
			redirect_to admin_media_path, notice: 'Folder was successfully created.' 
        rescue
          render :text => "Couldn't create folder"
        end
	end

	# create the object in S3 this a file

	def self.advanced_create(p) 

		if p[:reference].blank?
			dir = ''
			where = BUCKET
		else
			# create object inside the given directory
			dir = p[:reference]
			where = "#{BUCKET}/#{dir}/"
		end

		begin
	        @file = AWS::S3::S3Object.store(sanitize_filename(p[:file].original_filename), p[:file].read, where, :access => :public_read)
	        render :text => "Success!"   
	    rescue
	      	render :text => 'Fail!' 
	    end

	end

	# get S3 object via the key which is essentially a url string

	def self.get_by_key(p)
		return AWS::S3::Bucket.objects(Setting.find_by_setting_name('aws_bucket_name')[:setting], :prefix => p[:key])
	end

	# get a list of folders in the amazon S3 account

	def self.get_folder_list(p)
		files = Media.setup_and_search_posts
		arr = Array.new
 		
 		files.each_with_index do |item, index|
 			if item.content_type != 'binary/octet-stream'
				next
			end
		   arr.push item
		end

		arr
	end

end