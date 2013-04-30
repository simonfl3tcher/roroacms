class CommentsController < ApplicationController
		
	def index
		# @profile = Time.now
	end

	def create
		session[:return_to] ||= request.referer
		@comment = Comment.new(params[:comment])

		respond_to do |format|
		  if @comment.save
		    format.html { redirect_to session[:return_to], notice: 'Comment was successfully created. Awaiting Review' }
		  else
		    format.html { redirect_to session[:return_to]}
		    # format.json { render json: @user.errors, status: :unprocessable_entity }
		  end
		end


	end

end