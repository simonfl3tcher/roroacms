module ShortcodeHelper

	# prep_content function takes the content and runs it through the standard column shortcodes that are used in roroa.

	def prep_content(c = '')

		if c != ''
			@content = c
		end

		c = @content.post_content
		replace = c.scan(/([<p>]*?{(\/)?(one_half|one_third|two_third|one_fourth|two_fourth|three_fourth|one_fifth|two_fifth|three_fifth|four_fifth|one_sixth|two_sixth|three_sixth|four_sixth|five_sixth)_?(last)?\}[<\/p>]*)/)
		
		replace.each do |f|
			
			if !f[1].blank?
				str = '</div>'
			elsif f[1].blank? && !f[2].blank?
				str = "<div class='#{f[2]} #{f[3]}'>"
			end

			c = c.to_s.gsub(f[0], str)

		end

		return c

	end

end