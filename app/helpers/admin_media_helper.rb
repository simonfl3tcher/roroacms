module AdminMediaHelper

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

	def render_folder_loop(initial = false)

		files = Media.setup_and_search_posts

		@initial = initial
		@f = Array.new
 		files.each_with_index {|item, index|
 			if item.content_type != 'binary/octet-stream'
				next
			end

		   @f.push item
		}
		render :partial => 'admin/media/media_folder_loop'


	end

	def make_media_folder_subpage(fulldata, nextalong, i, y = false)

		hasFolder = false
		if !fulldata[i+2].blank?
			if fulldata[i+1].key.count('/') < fulldata[i+2].key.count('/') 
				hasFolder = true
			end
		end

		file = fulldata[i+1]
		name = file.key.split("/").last
		if !y
			html = '<ul>'
		end
		html += "<li class='folderRow'>
						<a class='folderLink' href='' data-key='#{file.key}' data-hasfolder='#{hasFolder}'>
<i class='icon-folder-close'></i>&nbsp;<span>#{name}</span>
						<i class='icon-remove'></i></a>"
		if !fulldata[i+2].blank?
			if fulldata[i+1].key.count('/') < fulldata[i+2].key.count('/') 
				html += make_media_folder_subpage fulldata, fulldata[i+1], i+1
			end
		end
		html += "</li>"

		if !y
			html += '</ul>'
		end

		return html.html_safe
	end
end