module Roroacms	
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
	    (m.rgt - m.lft - 1)/2
	  end

	  # returns the menu in html format
	  # Params:
	  # +menu+:: the key of the menu that you want to return
	  # +sub+:: boolean as to wether the menu is a sub menu or not
	  # +c+:: class you want to give the UL

		def obtain_menu(menu = nil,  sub = false, c = '')
			if menu.is_a? Integer
				data =
					if sub 
						MenuOption.where(:parent_id => MenuOption.find(menu).option_id)
					else 
						MenuOption.where(:menu_id => menu, :parent_id => nil)
					end
			else
				m = Menu.find_by_key(menu)
				data = 
					if m.blank? 
						[]
					elsif sub 
						MenuOption.where(:parent_id => MenuOption.find(m[:id]).option_id)
					else 
						MenuOption.where(:menu_id => m[:id], :parent_id => nil)
					end

			end


			html = "<ul class='menu_#{menu} #{c}'>"

			if !data.blank?
				
				data.each do |m|
					if m.parent_id != 0
						existingData = make_hash m.custom_data

						name = existingData['label']
						attributes = menu_routing(m)
						html += "<li class='menu_link_wrapper wrapper_#{existingData['class']}' ><a " + attributes + ">#{name}</a>"

						if descendants_count(m) > 0
							html += get_menu m.id, true

						end

						html += '</li>'

					end
				end
				
			end

			html +='</ul>'

			html.html_safe

		end

		# returns the menu in a raw json format
	  # Params:
	  # +menu+:: the key of the menu that you want to return
	  # +sub+:: boolean as to wether the menu is a sub menu or not

		def raw_menu_data(menu, sub = false)
			if menu.is_a?(Integer)
				data =
					if sub 
						MenuOption.where(:parent_id => MenuOption.find(menu).option_id)
					else 
						MenuOption.where(:menu_id => menu, :parent_id => nil)
					end
			else
				m = Menu.find_by_key(menu)
				data =
					if sub 
						MenuOption.where(:parent_id => MenuOption.find(m[:id]).option_id)
					else 
						MenuOption.where(:menu_id => m[:id], :parent_id => nil)
					end
			end

			data

		end

		# create the a links with the given attributes
		# Params:
		# +menuOption+:: is the menu option record

		def menu_routing(menuOption) 

			# create a hash of the menu option id
			existingData = make_hash menuOption.custom_data

			# create generic variables
			home_id = Setting.get('home_page')	
			article_url = Setting.get('articles_slug')	
			category_url = Setting.get('category_slug')	
			tag_url = Setting.get('tag_slug')	
			
			# start the string by defining the target 
			atts = get_target(existingData['target'])
			p = Post.find_by_id(existingData['linkto'])
			blog = false

			if menuOption.data_type == 'page' && !p.blank?
				
				url = p.id == home_id.to_i ? site_url() : site_url(p.structured_url)
				atts += " href='#{url}' class='menu_link'"

			elsif menuOption.data_type == 'article' && !p.blank?

				url = site_url(article_url +  p.structured_url)
				atts += " href='#{url}' class='menu_link'"

			elsif menuOption.data_type == 'category'

				t = Term.find(existingData['linkto'])
				url = site_url(article_url + '/' + category_url + t.structured_url)
				atts += " href='#{url}' class='menu_link'"

			elsif menuOption.data_type == 'tag'

				t = Term.find(existingData['linkto'])
				url = site_url(article_url + '/' + tag_url + t.structured_url)
				atts += " href='#{url}' class='menu_link'"

			elsif menuOption.data_type == article_url && menuOption.option_id == 0 

				url = site_url(article_url)
				atts += " href='#{url}' class='menu_link'"
				blog = true

			elsif menuOption.data_type == 'custom'

				url = existingData['customlink']
				atts += " href='#{url}' class='menu_link'"

			end

			atts = (atts[0..-2] + " #{existingData['class']}'") if !existingData['class'].blank?

			if blog && request.original_url.include?(url)
				atts = (atts[0..-2] + " active'") 	
			else
				atts = (atts[0..-2] + " active'") if url == request.original_url
			end


			atts

		end
		

		# returns target blank if target is equal to nt
		# Params:
		# +target+:: is the "target" value that comes from the custom data

		def get_target(target) 
			ret = ''
			ret = 'target="_blank"' if target == 'nt'
			ret
		end

	end
end