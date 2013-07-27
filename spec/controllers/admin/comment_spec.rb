require "spec_helper"

describe Admin::CommentsController do 

	describe "GET #index" do

		it "should render :index template" do
			FactoryGirl.create(:comment)
			get :index, :format => "html"
			assigns(:comments).should be_nil
		end

	end
	
end