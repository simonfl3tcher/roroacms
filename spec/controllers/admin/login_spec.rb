require "spec_helper"

describe Admin::LoginController do 

	describe "GET #new" do

		it "should render :new template" do
			get :new
			response.should render_template :new
		end

	end

	describe "GET #create" do

	end


end