require_dependency "roroacms/application_controller"

module Roroacms
  class CommentsController < ApplicationController

    # CommentsController is simply used for the blog comments form. On post it will save the data in the database for the admin to filter.

    include Roroacms::CommentsHelper

    
    def create
      # Check to see if comments are actually allowed, this can be switched on and off in the admin panel
      if comments_on

        session[:return_to] = request.referer
        @comment = Comment.new(comments_params)

        respond_to do |format|
          if @comment.save
            Roroacms::Emailer.comment(@comment).deliver
            format.html { redirect_to "#{session[:return_to]}#commentsArea", notice: comments_success_message.html_safe }
          else
            format.html { redirect_to "#{session[:return_to]}#commentsArea", notice: comments_error_display(@comment).html_safe}
          end
        end

      else
        render :inline =>  I18n.t("controllers.comments.create.error")
      end
      
    end


    private

    # Strong parameters

    def comments_params
      params.require(:comment).permit(:post_id, :author, :email, :website, :comment, :parent_id)
    end

  end
end