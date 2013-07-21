module AdminMenuHelper


	def make_hash(str)

		str = str.split('&')

		hash = {}

		str.each do | s |

			opt = s.split('=')

			hash[opt[0]] = URI.unescape(opt[1].to_s.gsub('+', ' '))

		end

		return hash

	end

	def check_for_checked(one, two)
		if one.to_s == two.to_s
			return "checked='checked'"
		else
			return ''
		end
	end

	def menu_list_loop(menuid, sub = false)
		if sub 
			data = MenuOption.find(menuid)
			data = MenuOption.where(:parent_id => data.option_id)
		else 
			data = MenuOption.where(:menu_id => menuid, :parent_id => nil)
		end

		html = ''

		data.each do |m|
			if m.parent_id != 0
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

				@option = m
				@existingData = existingData
				@name = name

				html += render :partial => 'admin/helper_partials/menu_list_loop' 

			end
		end

		return html.html_safe	

	end

	
	def descendants_count(m)
      return (m.rgt - m.lft - 1)/2
    end
	
	def get_menu_groups(menu)

		@id = menu.name.gsub(' ', '');
		@menu = menu
    	return render :partial => 'admin/helper_partials/menu_menu_groups' 

	end
	

end