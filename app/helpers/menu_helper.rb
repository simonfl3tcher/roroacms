module MenuHelper

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


	# returns the count of the children within the lft and rgt values
	# Params:
	# +m+:: the current record that you want to check against

	def descendants_count(m)
      return (m.rgt - m.lft - 1)/2
    end

	def get_menu(menu,  sub = false, c = '')
		if menu.is_a? Integer
			if sub 
				data = MenuOption.find(menu)
				data = MenuOption.where(:parent_id => data.option_id)
			else 
				data = MenuOption.where(:menu_id => menu, :parent_id => nil)
			end
		else
			m = Menu.find_by_key(menu)
			if m.blank?
				data = []
			else

				if sub 
					data = MenuOption.find(m[:id])
					data = MenuOption.where(:parent_id => data.option_id)
				else 
					data = MenuOption.where(:menu_id => m[:id], :parent_id => nil)
				end

			end
		end


		html = "<ul class='menu_#{menu} #{c}'>"

		if !data.blank?
			
			data.each do |m|
				if m.parent_id != 0
					existingData = make_hash m.custom_data

					name = existingData['label']
					attributes = menu_routing m

					html += "<li><a " + attributes + ">#{name}</a>"

					if descendants_count(m) > 0
						html += get_menu m.id, true

					end

					html += '</li>'

				end
			end
			
		end

		html +='</ul>'

		return html.html_safe

	end

	def raw_menu(menu, sub = false)
		if menu.is_a? Integer
			if sub 
				data = MenuOption.find(menu)
				data = MenuOption.where(:parent_id => data.option_id)
			else 
				data = MenuOption.where(:menu_id => menu, :parent_id => nil)
			end
		else
			m = Menu.find_by_key(menu)
			if sub 
				data = MenuOption.find(m[:id])
				data = MenuOption.where(:parent_id => data.option_id)
			else 
				data = MenuOption.where(:menu_id => m[:id], :parent_id => nil)
			end
		end

		return data

	end


	# create the a links with the given attributes
	# Params:
	# +menuOption+:: is the menu option record

	def menu_routing(menuOption) 

		# create a hash of the menu option id
		existingData = make_hash menuOption.custom_data

		# create generic variables
		article_url = Setting.get('articles_slug')	
		category_url = Setting.get('category_slug')	
		tag_url = Setting.get('tag_slug')	
		
		# start the string by defining the target 
		atts = get_target(existingData['target'])

		if menuOption.data_type == 'page'
			p = Post.find(existingData['linkto'])
			atts += " href='#{site_url(p.structured_url)}'"

		elsif menuOption.data_type == 'article'
			p = Post.find(existingData['linkto'])
			atts += " href='#{site_url(article_url +  p.structured_url)}'"

		elsif menuOption.data_type == 'category'
			t = Term.find(existingData['linkto'])
			atts += " href='#{site_url(article_url + '/' + category_url + t.structured_url)}'"

		elsif menuOption.data_type == 'tag'
			t = Term.find(existingData['linkto'])
			atts += " href='#{site_url(article_url + '/' + tag_url + t.structured_url)}'"

		elsif menuOption.data_type == article_url && menuOption.option_id == 0
			atts += " href='#{site_url(article_url)}'"

		elsif menuOption.data_type == 'custom'
			atts += " href='#{existingData['customlink']}'"
		end

		atts

	end
	

	# returns target blank if target is equal to nt
	# Params:
	# +target+:: is the "target" value that comes from the custom data

	def get_target(target) 
		ret = ''
		if target == 'nt'
			ret = 'target="_blank"'
		end

		ret
	end

end