class Trash < ActiveRecord::Base

	# is the bootstrap for the bulk update function. It takes in the call
    # and decides what function to call in order to get the correct output

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
					# return a message for the user
					return "There were no records to reinstate."
				end

				# return a message for the user
				return "These records was successfully reinstated."

			when "destroy"

				if !params[:posts].blank? 
					delete_posts params[:posts] 
				elsif !params[:pages].blank?
					delete_posts params[:pages]
				else
					# return a message for the user
					return "There were no records to delete."
				end
				
				# return a message for the user
				return  "These records was successfully deleted."

			else
				# return a message for the user
				return "Nothing was done"

		end

	end

	private

	# update all of the given records to be reinstated

	def self.reinstate_posts(posts)
		posts.each do |val|
			post = Post.find(val)
			post.disabled = "N"
			post.save
		end
	end

	# delete all of the given records for good

	def self.delete_posts(posts)
		posts.each do |val|
			post = Post.find(val)
			post.destroy
		end
	end

end