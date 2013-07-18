class Admin::TermRelationshipController < AdminController

	def destroy
	    @term = TermRelationship.find(params[:id])
	    @term.destroy

	    respond_to do |format|
	      format.html { redirect_to admin_administrators_path, notice: 'Admin was successfully deleted.' }
	    end

	end

end