class Media < ActiveRecord::Base

	# get the name of the S3 bucket that is set in the admin panel
	BUCKET = Setting.get('aws_bucket_name')
	
	include AWS::S3

	# get all objects inside the BUCKET 

	def self.setup_and_search_posts url = nil
		if url.nil?    
			files = AWS::S3::Bucket.find("#{BUCKET}").objects
		else 
			# if url is defined it will either get all objects inside a directory or get an inidividual
			# file depending on the type of string passed in through prefix
			files = AWS::S3::Bucket.objects(Setting.get('aws_bucket_name'), :prefix => url)
		end
		
		files
	end

end