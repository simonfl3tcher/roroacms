require "spec_helper"

describe NewViewHelper do

	describe "obtain_children" do 
		it "should return the given posts children"
	end

	describe "#obtain_permalink" do 
		it "should return the post url"
	end

	describe "#obtain_excerpt" do 
		it "should return an excerpt of the post"
	end

	describe "#obtain_cover_image" do 
		it "should return the cover image"
	end

	describe "#obtain_the_date" do 
		it "should return the published date of the post/page"
	end

	describe "#has_cover_image" do 
		it "should return true if it has a cover image"
		it "should return false if it does not have a cover image"
	end

	describe "#obtain_all_category_ids" do 
		it "should return all category ids"
		it "should return all category ids of the categories the post is in"
	end

	describe "#obtain_categories" do 
		it "should return all the categories"
	end

	describe "#obtain_category" do 
		it "should return the category"
	end

	describe "#obtain_category_title" do 
		it "should return the category title"
	end

	describe "#obtain_category_link" do 
		it "should return the category link"
	end

	describe "#obtain_category_description" do 
		it "should return the category description"
	end

	describe "#in_category" do 
		it "should return a bool as to wether the given post is in the given category"
	end

	describe "#obtain_tag_link" do 
		it "should return the tag url"
	end

	describe "#obtain_tags" do 
		it "should return all the categories"
	end

	describe "#has_tag" do 
		it "should return wether the post has the given tag attached"
	end

	describe "#obtain_tag_title" do 
		it "should return the tag title"
	end

	describe "#obtain_tag_description" do 
		it "should return the tag description"
	end

	describe "#obtain_tag" do 
		it "should return the tag"
	end

	describe "#obtain_next_article" do 
		it "should return the article that is next in line"
	end

	describe "#obtain_next_article_link" do 
		it "should return the link to the article that is next in line"
	end

	describe "#obtain_previous_article" do 
		it "should return the article that is previous in line"
	end

	describe "#obtain_previous_article_link" do 
		it "should return the link to the article that is previous in line"
	end

	describe "#obtain_article" do 
		it "should return the article"
	end

	describe "#obtain_article_field" do 
		it "should return the article field"
	end

	describe "#obtain_article_status" do 
		it "should return the article status"
	end

	describe "#obtain_articles" do 
		it "should return the pages that have the given ids"
	end

	describe "#obtain_archives" do 
		it "should return all archives"
	end

	describe "#obtain_page" do 
		it "should return the given page - full record"
	end

	describe "#obtain_page_link" do 
		it "should return the given page - link"
	end


	describe "#obtain_page_field" do 
		it "should return a certain field in the given page"
	end

	describe "#is_page" do 

	end

	describe "#is_archive" do 

	end

	describe "#is_articles_home" do 

	end

	describe "#is_day_archive" do 

	end

	describe "#is_month_archive" do 

	end

	describe "#is_year_archive" do 

	end

	describe "#obtain_archive_year" do 

	end

	describe "#is_homepage" do 

	end

	describe "#is_article" do 

	end

	describe "#is_search" do 
		it "should return wether the given page is a searcg page"
	end

	describe "#is_tag" do 
		it "should return wether the given page is a tag page"
	end

	describe "#is_category" do 
		it "should return wether the given page is a category page"
	end

	describe "#obtain_user_profile" do 
		it "should return the user via id, email or username"
	end

	describe "#obtain_users" do 
		it "should return all users"
	end

	describe "#obtain_user_field" do 
		it "should return the given "
	end

	describe "#obtain_comment_author" do 
		it "should return the author of the comment"
	end

	describe "#obtain_comment_date" do 
		it "should return the date of the comment"
	end

	describe "#obtain_comment_time" do 
		it "should return the time of the comment"
	end

	describe "#obtain_comments" do 
		it "should return the comments for the article"
	end

	describe "#obtain_id" do 
		it "should return post/page record id"
	end

	describe "#obtain_the_author" do 
		it "should return the author of the article"
	end

	describe "#obtain_the_authors_articles" do 
		it "should return the articles that the author has published"
	end

	describe "#obtain_the_content" do 
		it "should return the content of the post/page"
	end

	describe "#obtain_the_title" do 
		it "should return the title of the post/page"
	end

	describe "#obtain_term_type" do 

	end

	describe "#obtain_additional_data" do 
		it "should return the additional data via the key"
	end

	describe "#create_excerpt" do 
		it "should create an excerpt via the given content"
	end

end