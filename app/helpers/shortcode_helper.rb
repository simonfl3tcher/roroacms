module ShortcodeHelper

	# prep_content function takes the content and runs it through the standard column shortcodes that are used in roroa.

	def prep_content
		# one half 
		c = @content.post_content
		c = c.gsub("<p>[one_half]", '<div class="one_half">')
		c = c.gsub("[/one_half]</p>", '</div>')
		c = c.gsub("<p>[one_half_last]", '<div class="one_half last">')
		c = c.gsub("[/one_half_last]</p>", '</div><div class="clear"></div>')
		c = c.gsub("[one_half]", '<div class="one_half">')
		c = c.gsub("[/one_half]", '</div>')
		c = c.gsub("[one_half_last]", '<div class="one_half last">')
		c = c.gsub("[/one_half_last]", '</div><div class="clear"></div>')

		#one third

		c = c.gsub("<p>[one_third]", '<div class="one_third">')
		c = c.gsub("[/one_third]</p>", '</div>')
		c = c.gsub("<p>[one_third_last]", '<div class="one_third last">')
		c = c.gsub("[/one_third_last]</p>", '</div><div class="clear"></div>')
		c = c.gsub("[one_third]", '<div class="one_third">')
		c = c.gsub("[/one_third]", '</div>')
		c = c.gsub("[one_third_last]", '<div class="one_third last">')
		c = c.gsub("[/one_third_last]", '</div><div class="clear"></div>')

		#two third

		c = c.gsub("<p>[two_third]", '<div class="two_third">')
		c = c.gsub("[/two_third]</p>", '</div>')
		c = c.gsub("<p>[two_third_last]", '<div class="two_third last">')
		c = c.gsub("[/two_third_last]</p>", '</div><div class="clear"></div>')
		c = c.gsub("[two_third]", '<div class="two_third">')
		c = c.gsub("[/two_third]", '</div>')
		c = c.gsub("[two_third_last]", '<div class="two_third last">')
		c = c.gsub("[/two_third_last]", '</div><div class="clear"></div>')

		# one fourth

		c = c.gsub("<p>[one_fourth]", '<div class="one_fourth">')
		c = c.gsub("[/one_fourth]</p>", '</div>')
		c = c.gsub("<p>[one_fourth_last]", '<div class="one_fourth last">')
		c = c.gsub("[/one_fourth_last]</p>", '</div><div class="clear"></div>')
		c = c.gsub("[one_fourth]", '<div class="one_fourth">')
		c = c.gsub("[/one_fourth]", '</div>')
		c = c.gsub("[one_fourth_last]", '<div class="one_fourth last">')
		c = c.gsub("[/one_fourth_last]", '</div><div class="clear"></div>')

		# two fourth

		c = c.gsub("<p>[two_fourth]", '<div class="two_fourth">')
		c = c.gsub("[/two_fourth]</p>", '</div>')
		c = c.gsub("<p>[two_fourth_last]", '<div class="two_fourth last">')
		c = c.gsub("[/two_fourth_last]</p>", '</div><div class="clear"></div>')
		c = c.gsub("[two_fourth]", '<div class="two_fourth">')
		c = c.gsub("[/two_fourth]", '</div>')
		c = c.gsub("[two_fourth_last]", '<div class="two_fourth last">')
		c = c.gsub("[/two_fourth_last]", '</div><div class="clear"></div>')

		# three fourth

		c = c.gsub("<p>[three_fourth]", '<div class="three_fourth">')
		c = c.gsub("[/three_fourth]</p>", '</div>')
		c = c.gsub("<p>[three_fourth_last]", '<div class="three_fourth last">')
		c = c.gsub("[/three_fourth_last]</p>", '</div><div class="clear"></div>')
		c = c.gsub("[three_fourth]", '<div class="three_fourth">')
		c = c.gsub("[/three_fourth]", '</div>')
		c = c.gsub("[three_fourth_last]", '<div class="three_fourth last">')
		c = c.gsub("[/three_fourth_last]", '</div><div class="clear"></div>')

		# one fifth

		c = c.gsub("<p>[one_fifth]", '<div class="one_fifth">')
		c = c.gsub("[/one_fifth]</p>", '</div>')
		c = c.gsub("<p>[one_fifth_last]", '<div class="one_fifth last">')
		c = c.gsub("[/one_fifth_last]</p>", '</div><div class="clear"></div>')
		c = c.gsub("[one_fifth]", '<div class="one_fifth">')
		c = c.gsub("[/one_fifth]", '</div>')
		c = c.gsub("[one_fifth_last]", '<div class="one_fifth last">')
		c = c.gsub("[/one_fifth_last]", '</div><div class="clear"></div>')

		# two fifth

		c = c.gsub("<p>[two_fifth]", '<div class="two_fifth">')
		c = c.gsub("[/two_fifth]</p>", '</div>')
		c = c.gsub("<p>[two_fifth_last]", '<div class="two_fifth last">')
		c = c.gsub("[/two_fifth_last]</p>", '</div><div class="clear"></div>')
		c = c.gsub("[two_fifth]", '<div class="two_fifth">')
		c = c.gsub("[/two_fifth]", '</div>')
		c = c.gsub("[two_fifth_last]", '<div class="two_fifth last">')
		c = c.gsub("[/two_fifth_last]", '</div><div class="clear"></div>')

		# three fifth

		c = c.gsub("<p>[three_fifth]", '<div class="three_fifth">')
		c = c.gsub("[/three_fifth]</p>", '</div>')
		c = c.gsub("<p>[three_fifth_last]", '<div class="three_fifth last">')
		c = c.gsub("[/three_fifth_last]</p>", '</div><div class="clear"></div>')
		c = c.gsub("[three_fifth]", '<div class="three_fifth">')
		c = c.gsub("[/three_fifth]", '</div>')
		c = c.gsub("[three_fifth_last]", '<div class="three_fifth last">')
		c = c.gsub("[/three_fifth_last]", '</div><div class="clear"></div>')

		# four fifth

		c = c.gsub("<p>[four_fifth]", '<div class="four_fifth">')
		c = c.gsub("[/four_fifth]</p>", '</div>')
		c = c.gsub("<p>[four_fifth_last]", '<div class="four_fifth last">')
		c = c.gsub("[/four_fifth_last]</p>", '</div><div class="clear"></div>')
		c = c.gsub("[four_fifth]", '<div class="four_fifth">')
		c = c.gsub("[/four_fifth]", '</div>')
		c = c.gsub("[four_fifth_last]", '<div class="four_fifth last">')
		c = c.gsub("[/four_fifth_last]", '</div><div class="clear"></div>')

		# one sixth

		c = c.gsub("<p>[one_sixth]", '<div class="one_sixth">')
		c = c.gsub("[/one_sixth]</p>", '</div>')
		c = c.gsub("<p>[one_sixth_last]", '<div class="one_sixth last">')
		c = c.gsub("[/one_sixth_last]</p>", '</div><div class="clear"></div>')
		c = c.gsub("[one_sixth]", '<div class="one_sixth">')
		c = c.gsub("[/one_sixth]", '</div>')
		c = c.gsub("[one_sixth_last]", '<div class="one_sixth last">')
		c = c.gsub("[/one_sixth_last]", '</div><div class="clear"></div>')

		# two sixth

		c = c.gsub("<p>[two_sixth]", '<div class="two_sixth">')
		c = c.gsub("[/two_sixth]</p>", '</div>')
		c = c.gsub("<p>[two_sixth_last]", '<div class="two_sixth last">')
		c = c.gsub("[/two_sixth_last]</p>", '</div><div class="clear"></div>')
		c = c.gsub("[two_sixth]", '<div class="two_sixth">')
		c = c.gsub("[/two_sixth]", '</div>')
		c = c.gsub("[two_sixth_last]", '<div class="two_sixth last">')
		c = c.gsub("[/two_sixth_last]", '</div><div class="clear"></div>')

		# three sixth

		c = c.gsub("<p>[three_sixth]", '<div class="three_sixth">')
		c = c.gsub("[/three_sixth]</p>", '</div>')
		c = c.gsub("<p>[three_sixth_last]", '<div class="three_sixth last">')
		c = c.gsub("[/three_sixth_last]</p>", '</div><div class="clear"></div>')
		c = c.gsub("[three_sixth]", '<div class="three_sixth">')
		c = c.gsub("[/three_sixth]", '</div>')
		c = c.gsub("[three_sixth_last]", '<div class="three_sixth last">')
		c = c.gsub("[/three_sixth_last]", '</div><div class="clear"></div>')

		# four sixth

		c = c.gsub("<p>[four_sixth]", '<div class="four_sixth">')
		c = c.gsub("[/four_sixth]</p>", '</div>')
		c = c.gsub("<p>[four_sixth_last]", '<div class="four_sixth last">')
		c = c.gsub("[/four_sixth_last]</p>", '</div><div class="clear"></div>')
		c = c.gsub("[four_sixth]", '<div class="four_sixth">')
		c = c.gsub("[/four_sixth]", '</div>')
		c = c.gsub("[four_sixth_last]", '<div class="four_sixth last">')
		c = c.gsub("[/four_sixth_last]", '</div><div class="clear"></div>')
		
		# five sixth

		c = c.gsub("<p>[five_sixth]", '<div class="five_sixth">')
		c = c.gsub("[/five_sixth]</p>", '</div>')
		c = c.gsub("<p>[five_sixth_last]", '<div class="five_sixth last">')
		c = c.gsub("[/five_sixth_last]</p>", '</div><div class="clear"></div>')
		c = c.gsub("[five_sixth]", '<div class="five_sixth">')
		c = c.gsub("[/five_sixth]", '</div>')
		c = c.gsub("[five_sixth_last]", '<div class="five_sixth last">')
		c = c.gsub("[/five_sixth_last]", '</div><div class="clear"></div>')
		

		return c

	end

end