require 'rails_helper'

RSpec.describe Setting, :type => :model do

  before(:each) do
    @settings = Setting.get_all
  end

  it "should get the value for the given setting" do
    expect(Setting.get('articles_slug')).to eq('blog')
  end

  it "should return all settings" do
    expect(@settings).to be_a_kind_of(Hash)
    expect(@settings['articles_slug']).to eq('blog')
    expect(@settings['pagination_per']).to eq("25")
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
    @settings['smtp_username'] = ''
    errors = Setting.manual_validation(@settings)
    expect(errors[:smtp_username]).to eq('Server E-mail Address cannot be blank')
  end

  it "is invalid if smtp password slug is blank" do
    @settings['smtp_password'] = ''
    errors = Setting.manual_validation(@settings)
    expect(errors[:smtp_password]).to eq('SMTP password cannot be blank')
  end

  it "it sets a default if smtp authentication is blank" do
    @settings['authentication'] = ''
    errors = Setting.manual_validation(@settings)
    expect(errors[:authentication]).to be_nil
  end

  it "should save the value against the given field" do
    @settings['articles_slug'] = 'hello'
    Setting.save_data(@settings)
    expect(Setting.get_all['articles_slug']).to eq('hello')

  end

  it "should return the mail settings" do
    mail = Setting.mail_settings
    expect(mail[:address]).to eq(Setting.get('smtp_address'))
    expect(mail[:user_name]).to eq(Setting.get('smtp_username'))
  end

end
