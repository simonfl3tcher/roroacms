module AdminMenuHelper

	# Returns a hash as key and value from the custom data string
	# Params:
	# +str+:: contains all of the data for the link

	def make_hash(str)

		str = str.split('&')
		hash = {}

		str.each do |s|
			opt = s.split('=')
			hash[opt[0]] = URI.unescape(opt[1].to_s.gsub('+', ' '))
		end

		hash

	end


	# Returns a string to check the checkbox if the two variables match
	# Params:
	# +one+:: comparable to two
	# +two+:: comparable to one

	def check_for_checked(one, two)
		if one.to_s == two.to_s
			return "checked='checked'"
		else
			return ''
		end
	end


	# Returns the menu options in a html format for the admin editing area
	# Params:
	# +menuid+:: the id from the "menus" record
	# +sub+:: is true if it is a sub menu

	def menu_list_loop(menuid, sub = false)

		# check to see if it is a sub menu 
		if sub 
			data = MenuOption.find(menuid)
			data = MenuOption.where(:parent_id => data.option_id)
		else 
			data = MenuOption.where(:menu_id => menuid, :parent_id => nil)
		end

		html = ''

		data.each do |m|

			if m.parent_id != 0

				# below creates the necessary vairbale for the html view
				existingData = make_hash m.custom_data
				name = existingData['label']

				if name.to_s.blank?

					if m.data_type == 'pages' || m.data_type == 'posts'
						opt = Post.find(m.option_id)
						name = opt.post_title
					elsif m.data_type == 'custom'
						name = existingData['customlink']
					else
						opt = Term.where(:id => m.option_id)
						name = opt.name
					end
				end

				# allow the view to see these variables
				@option = m
				@existingData = existingData
				@name = name

				# add each block to the html variable
				html += render :partial => 'admin/menus/partials/menu_list_loop' 

			end
		end

		html.html_safe	

	end


	# returns the count of the children within the lft and rgt values
	# Params:
	# +value+:: the current record that you want to check against
	
	def descendants_count(value)
      return (value.rgt - value.lft - 1)/2
    end
    

    # returns a list of all of the menus as an accordion with its list items inside 
	# Params:
	# +menu+:: the current record that you want to create the menu group option for
	
	def get_menu_groups(menu)
		@id = menu.name.gsub(' ', '');
		@menu = menu
    	return render :partial => 'admin/menus/partials/menu_menu_groups' 
	end
	

end