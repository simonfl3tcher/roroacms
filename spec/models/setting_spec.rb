require 'rails_helper'

RSpec.describe Setting, :type => :model do

	before(:each) do 
		@settings = Setting.get_all
	end

	it "should get the value for the given setting" do 
		expect(Setting.get('articles_slug')).to eq('news')
	end

	it "get all settings" do 
		expect(@settings).to be_a_kind_of(Hash)
		expect(@settings['articles_slug']).to eq('news')
		expect(@settings['pagination_per']).to eq("2")
	end

	it "is invalid if articles slug is blank" do 
		@settings['articles_slug'] = ''
		errors = Setting.manual_validation(@settings)
		expect(errors[:articles_slug]).to eq('Articles Slug cannot be blank')
	end

	it "is invalid if category slug is blank" do 
		@settings['category_slug'] = ''
		errors = Setting.manual_validation(@settings)
		expect(errors[:category_slug]).to eq('Category Slug cannot be blank')
	end

	it "is invalid if tag slug is blank" do 
		@settings['tag_slug'] = ''
		errors = Setting.manual_validation(@settings)
		expect(errors[:tag_slug]).to eq('Tag Slug cannot be blank')
	end

	it "is invalid if smtp username slug is blank" do 
		
	end

	it "is invalid if smtp password slug is blank"
	it "is invalid if smtp authentication slug is blank"
	it "should save the value against the given field"

	it "should return the mail settings" do 
		mail = Setting.mail_settings
		expect(mail[:address]).to eq(Setting.get('smtp_address'))
		expect(mail[:user_name]).to eq(Setting.get('smtp_username'))
	end

end