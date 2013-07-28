module MediaHelper

	BUCKET = Setting.find_by_setting_name('aws_bucket_name')[:setting]
	include AWS::S3

	def media_setup_and_search_posts    
		files = AWS::S3::Bucket.find("#{BUCKET}").objects
		return files

	end

	def media_create(p) 

		begin
          AWS::S3::S3Object.store("#{p[:create_dir]}/", "#{p[:create_dir]}/", BUCKET, :access => :public_read, :content_type => 'binary/octet-stream')
          redirect_to admin_media_path, notice: 'Folder was successfully created.' 
        rescue
          render :text => "Couldn't create folder"
        end

	end

	def media_advanced_create(p) 

		if p[:reference].blank?

			dir = ''
			where = BUCKET
		else
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

	def media_get_by_key(p)

		return AWS::S3::Bucket.objects(Setting.find_by_setting_name('aws_bucket_name')[:setting], :prefix => p[:key])

	end

	def media_get_folder_list(p)

		files = Media.setup_and_search_posts
		@f = Array.new
 		files.each_with_index {|item, index|
 			if item.content_type != 'binary/octet-stream'
				next
			end

		   @f.push item
		}

		return @f

	end


end