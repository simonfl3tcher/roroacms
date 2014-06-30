require 'rails_helper'

RSpec.describe "Pages", :type => :request do

	let(:admin) { FactoryGirl.create(:admin) }
  	before { sign_in(admin) }

end