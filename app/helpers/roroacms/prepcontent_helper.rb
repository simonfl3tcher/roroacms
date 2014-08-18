module Roroacms  
  module PrepcontentHelper

    MARKDOWN = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})


    # prepares the content for visual display by replacing shortcodes with the html equivalent
    # Params:
    # +c+:: is optional, but if you choose to pass it data this has to be a singular post object.
    # If you don't pass it any content then it will take the globalized content for the page

    def prep_content(c = '')
      c = 
        if c == ''
          @content.post_content
        elsif c.is_a?(Object)
          c.post_content
        else
          c = c
        end

      MARKDOWN.render(c).html_safe
      

    end

  end
end