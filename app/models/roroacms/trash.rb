module Roroacms   
  class Trash < ActiveRecord::Base

    # is the bootstrap for the bulk update function. It takes in the call
    # and decides what function to call in order to get the correct output
    # Params:
    # +params+:: the parameters

    def self.deal_with_form(params = {})

      case params[:to_do].gsub(' ', '_').downcase

      when "reinstate"

        if !params[:posts].blank?
          reinstate_posts params[:posts]
        elsif !params[:pages].blank?
          reinstate_posts params[:pages]
        else
          # return a message for the user
          return I18n.t("models.trash.deal_with_form.no_records_to_reinstate")
        end

        # return a message for the user
        return I18n.t("models.trash.deal_with_form.recrords_reinstated")

      when "destroy"

        if !params[:posts].blank?
          delete_posts params[:posts]
        elsif !params[:pages].blank?
          delete_posts params[:pages]
        else
          # return a message for the user
          return I18n.t("models.trash.deal_with_form.no_records_to_delete")
        end

        # return a message for the user
        return  I18n.t("models.trash.deal_with_form.records_deleted")

      else
        # return a message for the user
        return I18n.t("generic.nothing")

      end

    end

    private

    # update all of the given records to be reinstated
    # Params:
    # +posts+:: array of posts that you want to reinstate

    def self.reinstate_posts(posts)
      Post.where(:id => posts).update_all(:disabled => "N")
    end

    # delete all of the given records for good
    # Params:
    # +posts+:: array of posts that you want to reinstate
    
    def self.delete_posts(posts)
      Post.where(:id => posts).destroy_all
    end

  end
end