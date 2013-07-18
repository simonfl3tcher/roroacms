module MenuHelper

		def make_hash str

		str = str.split('&')

		hash = {}

		str.each do | s |

			opt = s.split('=')

			hash[opt[0]] = URI.unescape(opt[1].to_s.gsub('+', ' '))

		end

		return hash

	end

	def descendants_count m
      return (m.rgt - m.lft - 1)/2
    end

	def get_menu menu,  sub = false
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
				abort .inspect
				data = MenuOption.find(m[:id])
				data = MenuOption.where(:parent_id => data.option_id)
			else 
				data = MenuOption.where(:menu_id => m[:id], :parent_id => nil)
			end
		end

		html = "<ul class='menu_#{menu}'>"

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

		html +='</ul>'

		return html.html_safe

	end

	def menu_routing m 

		existingData = make_hash m.custom_data
		article_url = Setting.where(:setting_name => 'articles_slug').first.setting
		category_url = Setting.where(:setting_name => 'category_slug').first.setting
		tag_url = Setting.where(:setting_name => 'tag_slug').first.setting
		
		target = get_target existingData['target']
		atts = target

		if m.data_type == 'page'
			p = Post.find(existingData['linkto'])

			atts += " href='#{site_url(p.post_slug)}'"


		elsif m.data_type == 'article'
			p = Post.find(existingData['linkto'])
			atts += " href='#{site_url(article_url + '/' + p.post_slug)}'"

		elsif m.data_type == 'category'
			t = Term.find(existingData['linkto'])
			atts += " href='#{site_url(article_url + '/' + category_url + '/' + t.slug)}'"

		elsif m.data_type == 'tag'
			t = Term.find(existingData['linkto'])
			atts += " href='#{site_url(article_url + '/' + tag_url + '/' + t.slug)}'"

		elsif m.data_type == article_url && m.option_id == 0

			atts += " href='#{site_url(article_url)}'"


		elsif m.data_type == 'custom'
			atts += " href='#{existingData['customlink']}'"
		end

		return atts


	end

	def get_target target 

		ret = ''

		if target == 'nt'

			ret = 'target="_blank"'

		end

		return ret

	end


end