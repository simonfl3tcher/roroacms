module FilebrowserHelper

	AWS::S3::Base.establish_connection!(
      :access_key_id     => Setting.find_by_setting_name('aws_access_key_id')[:setting],
      :secret_access_key => Setting.find_by_setting_name('aws_secret_access_key')[:setting]
    )

	BUCKET = Setting.find_by_setting_name('aws_bucket_name')[:setting]

	def download_url_for(song_key)  
	    AWS::S3::S3Object.url_for(song_key, BUCKET, :authenticated => false)  
	end

	def torrent_url_for(song_key)  
	    download_url_for(song_key) + "?torrent"  
	end  

	def get_bucket_size

		size = 0

		AWS::S3::Bucket.find(BUCKET).objects.each do |object| #object should be an S3Object
		    size += object.content_length.to_i #in bytes
		end

		return number_to_human_size(size)

	end


end
