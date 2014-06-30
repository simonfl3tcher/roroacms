require 'rails_helper'

RSpec.describe "Admin::Themes", :type => :request do

	let(:admin) { FactoryGirl.create(:admin) }
  	before { sign_in(admin) }

end