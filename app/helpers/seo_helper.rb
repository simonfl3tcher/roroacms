module SeoHelper

	def get_meta_headers


		if !@content.nil?

			if !(@content.respond_to? :length)

				home_id = Setting.where(:setting_name => 'home_page').first.setting	

				if @content.id == home_id.to_f
					headtags = get_manual_metadata 'home'
				else
					headtags = "#{get_page_title}\n"
					headtags += "#{get_meta_description}\n"
					headtags += "#{get_additional_headers}\n"
					headtags += "#{get_google_analytics}\n"
					headtags += "#{get_robots_tag}"
				end

				render :inline => headtags

			else
				url_arr = params[:slug].split('/')
				last_url = url_arr.last
				article_url = Setting.where(:setting_name => 'articles_slug').first.setting
				category_url = Setting.where(:setting_name => 'category_slug').first.setting

				if (last_url == article_url || last_url.nonnegative_float? || url_arr[1] == category_url)

					robots_var = false

					if url_arr[1] == category_url
						robots_var = 'category'
					elsif last_url.nonnegative_float?
						robots_var = 'archive'
					end

					new_string = last_url.slice(0,1).capitalize + last_url.slice(1..-1)


					if last_url.nonnegative_float? 

						if !url_arr[2].blank?
							new_string = Date::MONTHNAMES[url_arr[2].to_i]
							new_string = "#{new_string} #{url_arr[1]}"

							if !url_arr[3].blank?
								new_string = "#{url_arr[3]} #{new_string}"
							end

						end

					end

					headtags = "#{get_page_title new_string}\n"
					headtags += "#{get_additional_headers}\n"
					headtags += "#{get_google_analytics}\n"
					headtags += "#{get_robots_tag robots_var}"

					render :inline => headtags
				end

			end


		else 
			headtags = get_manual_metadata '404'
			render :inline => headtags

		end
	end

	private

	def get_meta_description overide = nil

		if overide.nil?



		else

			if !@content.post_seo_description.blank?

				return "<meta name=\"description\" content=\"#{@content.post_seo_description}\" />\n<meta name=\"author\" content=\"Simon Fletcher\">"

			else 

				description = truncate(@content.post_content, :length => 100, :separator => ' ')

				return "<meta name=\"description\" content=\"#{strip_tags(description)}\" />\n<meta name=\"author\" content=\"Simon Fletcher\">"


			end

		end

	end


	def get_page_title overide = nil


		if !overide.nil?

			websiteTitle = Setting.where(:setting_name => "seo_site_title").first.setting
			title = "#{overide} | #{websiteTitle}"
			return "<title>#{title}</title>"


		else

			if !@content.post_seo_title.blank?

				return "<title>#{@content.post_seo_title}</title>"

			else

				websiteTitle = Setting.where(:setting_name => "seo_site_title").first.setting
				title = "#{@content.post_title} | #{websiteTitle}"

				return "<title>#{title}</title>"

			end

		end

	end

	def get_robots_tag overide = nil

		if !overide.nil?
			if overide == 'archive' && Setting.where(:setting_name => "seo_no_index_archives").first.setting == 'Y'
				return "<meta name=\"robots\" content=\"noindex, follow\" />"
			elsif overide == 'category' && Setting.where(:setting_name => "seo_no_index_categories").first.setting == 'Y'
				return "<meta name=\"robots\" content=\"noindex, follow\" />"
			end
		else

			if @content.post_seo_no_index == 'Y' && @content.post_seo_no_follow == 'Y'

				return "<meta name=\"robots\" content=\"noindex, nofollow\" />"

			elsif @content.post_seo_no_index == 'N' && @content.post_seo_no_follow == 'Y'

				return "<meta name=\"robots\" content=\"index, nofollow\" />"

			elsif @content.post_seo_no_index == 'Y' && @content.post_seo_no_follow == 'N'

				return "<meta name=\"robots\" content=\"noindex, follow\" />"

			end

		end
	end

	def get_manual_metadata type

		title = "seo_#{type}_title"
		description = "seo_#{type}_description"

		headtags = "<title>#{Setting.where(:setting_name => title).first.setting}</title>\n"
		headtags += "<meta name=\"description\" content=\"#{Setting.where(:setting_name => description).first.setting}\" />\n"
		headtags += "#{get_additional_headers}\n"
		headtags += "#{get_google_analytics}\n"
		headtags += "#{canonical_urls}"

		return headtags
	end

	def get_additional_headers

		additionalHeaders = Setting.where(:setting_name => "seo_additional_headers").first.setting

		if !additionalHeaders.blank?

			return additionalHeaders

		end	
	end

	def get_google_analytics

		analyticsID = Setting.where(:setting_name => "seo_google_analytics_code").first.setting

		if !analyticsID.blank?

			analyticsCode = "<script class=\"cc-onconsent-analytics\" type=\"text/plain\">
var _gaq = _gaq || [];
_gaq.push(['_setAccount', '#{analyticsID}']);
_gaq.push(['_trackPageview']);
(function() {
var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();
</script>"

			return analyticsCode


		end
	end

	def canonical_urls

		canonical = Setting.where(:setting_name => "seo_canonical_urls").first.setting

		if canonical.to_s == 'Y'

			headtags = "<link rel=\"canonical\" href=\"#{url_for(:action => 'index')}\" />\n"
			return headtags

		end


	end

end