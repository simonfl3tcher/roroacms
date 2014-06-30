require 'rails_helper'

RSpec.describe "Admin::Articles", :type => :request do

	let(:admin) { FactoryGirl.create(:admin) }
  	before { sign_in(admin) }

end