class Trash < ActiveRecord::Base

	def self.deal_with_form params

		action = params[:to_do]
		action = action.gsub(' ', '_')

		case action.downcase 
			when "reinstate"
					if !params[:posts].blank? 
						reinstate_posts params[:posts] 
					elsif !params[:pages].blank?
						reinstate_posts params[:pages]
					else
						return "There were no records to reinstate."
					end

					return "These records was successfully reinstated."
			when "destroy"
				if !params[:posts].blank? 
					delete_posts params[:posts] 
				elsif !params[:pages].blank?
					delete_posts params[:pages]
				else
					return "There were no records to delete."
				end
				return  "These records was successfully deleted."
			else
				return 'Nothing was done' 
		end

	end

	def self.reinstate_post val

		post = Post.find(val)
		post.disabled = "N"
		post.save

	end

	private

	def self.reinstate_posts posts
		posts.each do |val|
			post = Post.find(val)
			post.disabled = "N"
			post.save
		end
	end

	def self.delete_posts posts 
		posts.each do |val|
			post = Post.find(val)
			post.destroy
		end
	end

end