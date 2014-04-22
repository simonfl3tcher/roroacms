module MediaHelper

	# establish a connection to S3

	AWS::S3::Base.establish_connection!(:access_key_id     => Setting.find_by_setting_name('aws_access_key_id')[:setting], :secret_access_key => Setting.find_by_setting_name('aws_secret_access_key')[:setting])
	BUCKET = Setting.find_by_setting_name('aws_bucket_name')[:setting]

	# require the dependencies
	include AWS::S3
	require 'digest/md5'

	def media_setup_and_search_posts url = nil

		if url.nil?    
			files = AWS::S3::Bucket.find("#{BUCKET}").objects
		else 
			files = AWS::S3::Bucket.objects(Setting.find_by_setting_name('aws_bucket_name')[:setting], :prefix => url)
		end
		
		files

	end

	def media_create(p, url = '') 
		begin
          AWS::S3::S3Object.store(url + "#{p[:create_dir]}/", url + "#{p[:create_dir]}/", BUCKET, :access => :public_read, :content_type => 'binary/octet-stream')
          render :text => 'Folder was successfully created.' 
        rescue
          render :text => "Couldn't create folder"
        end

	end

	def media_advanced_create(p, url = '') 

		if p[:reference].blank?

			dir = url + ''
			where = "#{BUCKET}/#{dir}"
		else
			dir = url + p[:reference]
			where = "#{BUCKET}/#{dir}"
		end

		current_size = get_folder_size(aws3_trainer_url(current_user.id),false)

		if (current_size + p[:file].size) <= trainer_max_size

			begin
		        @file = AWS::S3::S3Object.store(sanitize_filename(p[:file].original_filename), p[:file].read, where, :access => :public_read)
		        
		        return render :json => {:message => p[:file].original_filename, :code => 501}.to_json
		       
		    rescue ResponseError => error
			    render :text => error.message
			 end
		else
			return render :json => {:message => 'You have exceeded your storage limit!', :code => 403}.to_json
		end
	end

	def media_advance_create_admin(p, url = '')

		if p[:reference].blank?

			dir = ''
			where = BUCKET
		else
			dir = p[:reference]
			where = "#{BUCKET}/#{dir}"
		end

		begin
	        @file = AWS::S3::S3Object.store(sanitize_filename(p[:file].original_filename), p[:file].read, where, :access => :public_read)
	        
	        render :text => "Success!"
	       
	     rescue ResponseError => error
		    render :text => error.message
		  end

	end

	def manually_create_folder url 
		AWS::S3::S3Object.store(url, url, BUCKET, :access => :public_read, :content_type => 'binary/octet-stream')
	end

	def get_folder_size url, human = true
		total_bytes = 0
		files = AWS::S3::Bucket.objects(Setting.find_by_setting_name('aws_bucket_name')[:setting], :prefix => url)		
		files.each do |f|
			total_bytes += f.size.to_i
		end
		if human
			number_to_human_size(total_bytes) 
		else
			total_bytes
		end
	end

	def media_get_by_key(p, url = '')

		return AWS::S3::Bucket.objects(Setting.find_by_setting_name('aws_bucket_name')[:setting], :prefix => url + p[:key])

	end

	def media_get_folder_list(p, url = nil)

		files = Media.setup_and_search_posts url
		@f = Array.new
 		files.each_with_index {|item, index|
 			if item.content_type != 'binary/octet-stream'
				next
			end

		   @f.push item
		}

		return @f

	end

	def delete_all prefix

		obj = AWS::S3::Bucket.objects(BUCKET, :prefix => prefix)
		obj.each do |f|
			AWS::S3::S3Object.find(f.key, BUCKET).delete
		end

	end

	def upload_trainer_image(p, user, type = 'trainers') 

		where = "#{BUCKET}/" + type + "/" + user + "/"

		begin
	        @file = AWS::S3::S3Object.store(sanitize_filename(p[:file].original_filename), p[:file].read, where, :access => :public_read)
	        @url = S3Object.url_for("/" + type + "/" + user + "/" + p[:file].original_filename, BUCKET, :authenticated => false)

	        return @url

	    rescue ResponseError => error
	    	return @url = ''
		end

	end

	def upload_featured_image(image, user, type = 'trainers')

		where = "#{BUCKET}/" + type + "/" + user.to_s + "/article_featured_images/"

		begin
	        @file = AWS::S3::S3Object.store(sanitize_filename(image.original_filename), image.read, where, :access => :public_read)
	        @url = S3Object.url_for("/" + type + "/" + user.to_s + "/article_featured_images/" + image.original_filename, BUCKET, :authenticated => false)

	        return @url

	    rescue ResponseError => error
	    	return @url = ''
		end
	end

	def message_multiple_upload params, trainer 

		fol = Digest::MD5.hexdigest(params[:message][:user_id].to_s + "_" + trainer.to_s + '_' + Time.now.to_s)

		where = "#{BUCKET}/messages/" + fol + "/"
		arr = []

		if !params[:attachments].blank?

			params[:attachments].each do |f|

				begin
			        @file = AWS::S3::S3Object.store(sanitize_filename(f.original_filename), f.read, where, :access => :public_read)
			        @url = S3Object.url_for("/messages/" + fol + "/" + f.original_filename, BUCKET, :authenticated => false)
			        arr.push(@url) 

			    rescue ResponseError => error
			    	arr = []
				end
			end
		end

		arr.join('|')

	end

	def plan_multiple_upload params, trainer,  

		fol = Digest::MD5.hexdigest( "plan_" + trainer.to_s + '_' + Time.now.to_s)

		where = "#{BUCKET}/plan/" + fol + "/"
		arr = []

		if !params[:attachments].blank?

			params[:attachments].each do |f|

				begin
			        @file = AWS::S3::S3Object.store(sanitize_filename(f.original_filename), f.read, where, :access => :public_read)
			        @url = S3Object.url_for("/plan/" + fol + "/" + f.original_filename, BUCKET, :authenticated => false)
			        arr.push(@url) 

			    rescue ResponseError => error
			    	arr = []
				end
			end
		end

		arr.join('|')

	end

	def front_render_folder_loop(initial = false, url= nil)

		files = Media.setup_and_search_posts url 

		@initial = initial
		@f = Array.new
 		files.each_with_index {|item, index|
 			if item.content_type != 'binary/octet-stream'
				next
			end

		   @f.push item
		}
		render :partial => 'trainer/train/media/media_folder_loop'


	end

	def trainer_reached_limit
		path = 'trainers/' + current_user.id.to_s + '/trainers_files/'
		user_size = trainer_max_size
		current_size = get_folder_size(path, false)
		if current_size > user_size
			true
		else
			false
		end
	end

	def trainer_close_to_limit
		path = 'trainers/' + current_user.id.to_s + '/trainers_files/'
		user_size = trainer_max_size
		current_size = get_folder_size(path, false)
		percent = ((current_size.to_f / user_size.to_f) * 100)
		if percent >= 80 && percent <= 100
			true
		else
			false
		end
	end

	def is_trainer_media_size_under p 
		path = 'trainers/' + current_user.id.to_s + '/trainers_files/'
		current_size = get_folder_size(path, false)
		if current_size > p
			false
		else
			true
		end

	end

	def aws3_trainer_url id
		'trainers/' + id.to_s + '/trainers_files/'
	end

	def trainer_max_size
		current_user.user_detail.media_limit
	end

	private

	  def sanitize_filename(file_name)
	    just_filename = File.basename(file_name)
	    just_filename.sub(/[^\w\.\-]/,'_')
	  end


end