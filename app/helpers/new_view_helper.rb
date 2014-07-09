module NewViewHelper

	# The view helper contains all of the functions that the views
  # will use in order to display the contents of either the content
  # or format other data

  # Generic

	def obtain_children(id = nil)

	end

	def obtain_permalink(id = nil)

	end

	def obtain_excerpt(id = nil)

	end

	def obtain_cover_image(id = nil)

	end

	def obtain_id

	end

	def obtain_the_date(id = nil)

	end

	def has_cover_image(id = nil)

	end

	# category funcs

	def obtain_all_category_id(id = nil)

	end

	def obtain_categories

	end

	def obtain_category(id = nil, by = nil)

	end

	def obtain_category_title(id = nil)

	end

	def in_category(catid, id = nil)

	end

	def is_category(catid)

	end

	def obtain_category_description(id = nil)

	end

	# tag funcs

	def obtain_tag(id)

	end

	def obtain_tag_link(id = nil)

	end

	def obtain_tags

	end

	def has_tag?(str)

	end

	def obtain_tag_title(id = nil)

	end

	def obtain_tag_description(id = nil)

	end
	# article funcs

	def obtain_next_article(id = nil)

	end  

	def obtain_next_article_link(id = nil)

	end

	def obtain_previous_article(id = nil)

	end 

	def obtain_previous_article_link(id = nil)

	end

	def obtain_article(id)

	end

	def obtain_article_field(field, id = nil)

	end

	def obtain_article_status

	end

	def obtain_articles

	end

	# page funcs

	def obtain_page(id = nil, by = 'id')

	end

	def obtain_page_link(id = nil)

	end

	def obtain_page_url(id = nil)

	end

	def obtain_page_field(field, id = nil)

	end

	# Conditional Posts

	def is_page?(id = nil)

	end

	def has_tag?(id = nil)

	end

	def in_category?(id = nil)

	end

	def is_404?

	end

	def is_archive?

	end

	def is_day_archive?

	end

	def is_front_page?(id = nil)

	end

	def is_month_archive?

	end

	def is_article?(is = nil)

	end

	def is_search?

	end

	def is_tag?(tagid = nil)

	end

	def is_year_archive?(id = nil)

	end


	# User functions

	def obtain_user_profile(id)

	end

	def obtain_user_by(field)

	end

	def obtain_users

	end

	def obtain_user_field(id = nil, field)

	end

	# comment functions

	def comment_author(id)

	end

	def comment_date(id)

	end

	def comment_time(id)

	end

end