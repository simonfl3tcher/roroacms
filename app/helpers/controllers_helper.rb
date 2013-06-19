module ControllersHelper

	def bulk_update_media params

		action = params[:to_do]
		action = action.gsub(' ', '_')

		if params[:media].nil?
			action = ""
		end
		case action.downcase 
			when "move_to_trash"

				params[:media].each do |val|
					AWS::S3::S3Object.find(val, BUCKET).delete
				end

				respond_to do |format|
			      format.html { redirect_to admin_media_path, notice: 'Media were successfully destroyed.' }
			    end
			else
			
			respond_to do |format|
		      format.html { redirect_to admin_media_path, notice: 'Nothing was done' }
		    end
		end

	end


end