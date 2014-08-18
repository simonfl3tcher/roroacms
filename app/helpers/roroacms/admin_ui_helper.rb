module Roroacms  
  module AdminUiHelper

    # returns the html for the generic bulk update dropdown
    # Params:
    # +options+:: a hash of the values that you want in the dropdown i.e. Hash['move_to_trash' => 'Move To Trash']

    def bulk_update_dropdown(options)
      @options = options
      render :partial => "roroacms/admin/partials/bulk_update_dropdown"
    end


    # returns the html for the generic back button

    def back_button
      html = link_to :back, :class => 'btn btn-mini pull-right'
      html += '<i class="icon-arrow-left"></i>'
      html.html_safe
    end

  end
end