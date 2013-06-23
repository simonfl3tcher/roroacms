class Media < ActiveRecord::Base

	include AWS::S3

	def self.setup_and_search_posts params
	      
		files = AWS::S3::Bucket.find(BUCKET).objects
		
		if params.has_key?(:search) && !params[:search].blank?
			
		end

		return files

	end

end