require 'spec_helper'


RSpec.describe Roroacms::Setting, :type => :model do

  before(:all) do
    @set = Roroacms::Setting.get_all
  end

  it "should get the value for the given setting" do
    expect(Roroacms::Setting.get('articles_slug')).to eq('news')
  end

  it "should return all settings" do
    expect(@set).to be_a_kind_of(Hash)
    expect(@set['articles_slug']).to eq('news')
    expect(@set['pagination_per']).to eq("10")
  end

  it "is invalid if articles slug is blank" do
    errors = Roroacms::Setting.manual_validation({'articles_slug' => ''})
    expect(errors[:articles_slug]).to eq('Articles Slug cannot be blank')
  end

  it "is invalid if category slug is blank" do
    @set['category_slug'] = ''
    errors = Roroacms::Setting.manual_validation(@set)
    expect(errors[:category_slug]).to eq('Category Slug cannot be blank')
  end

  it "is invalid if tag slug is blank" do
    @set['tag_slug'] = ''
    errors = Roroacms::Setting.manual_validation(@set)
    expect(errors[:tag_slug]).to eq('Tag Slug cannot be blank')
  end

  it "is invalid if smtp username slug is blank" do
    @set['smtp_username'] = ''
    errors = Roroacms::Setting.manual_validation(@set)
    expect(errors[:smtp_username]).to eq('Server E-mail Address cannot be blank')
  end

  it "is invalid if smtp password slug is blank" do
    @set['smtp_password'] = ''
    errors = Roroacms::Setting.manual_validation(@set)
    expect(errors[:smtp_password]).to eq('SMTP password cannot be blank')
  end

  it "it sets a default if smtp authentication is blank" do
    @set['authentication'] = ''
    errors = Roroacms::Setting.manual_validation(@set)
    expect(errors[:authentication]).to be_nil
  end

  it "should save the value against the given field" do
    Roroacms::Setting.save_data({'seo_google_analytics_code' => 'hello'})
    expect(Roroacms::Setting.get('seo_google_analytics_code')).to eq('hello')
  end

  it "should return the mail settings" do
    mail = Roroacms::Setting.mail_settings
    expect(mail[:address]).to eq(Roroacms::Setting.get('smtp_address'))
    expect(mail[:user_name]).to eq(Roroacms::Setting.get('smtp_username'))
  end

end
