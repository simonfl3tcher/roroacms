module ShortcodeHelper

	#  -------- CURRENTLY UNUSED -------- #

	# prepares the content for visual display by replacing shortcodes with the html equivalent
	# Params:
	# +c+:: is optional, but if you choose to pass it data this has to be a singular post object. 
	# 		If you don't pass it any content then it will take the globalized content for the page

	def prep_content(c = '')

		if c != ''
			@content = c
		end

		# c always has to be a post object as you will need to be able to access post_content
		c = @content.post_content

		if !c.blank?

			# split the content into a hash of the occurances
			replace = c.scan(/([<p>]*?{(\/)?(one_half|one_third|two_third|one_fourth|two_fourth|three_fourth|one_fifth|two_fifth|three_fifth|four_fifth|one_sixth|two_sixth|three_sixth|four_sixth|five_sixth)_?(last)?\}[<\/p>]*)/)
			
			# run through the occurances and replace with the necessary HTML
			replace.each do |f|
				
				if !f[1].blank?
					str = '</div>'
				elsif f[1].blank? && !f[2].blank?
					str = "<div class='#{f[2]} #{f[3]}'>"
				end

				c = c.to_s.gsub(f[0], str)

			end

		else
			c = ''
		end

		c

	end

end