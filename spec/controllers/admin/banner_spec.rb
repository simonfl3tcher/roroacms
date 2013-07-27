require "spec_helper"

describe Admin::BannersController do 

	before(:each) do 

		visit admin_path 
		current_path.should == admin_login_path
	  	fill_in 'username', with: 'admin'
	  	fill_in 'password', with: '123123' 
	  	click_button 'Sign In' 

	  	current_path.should == admin_path
	  	
	end

	describe "GET #index" do
		it "populates an array of banners" do
			get :index, :format => "html"
		end

		it "renders the :index view" do
			get :index, :format => 'html'
		end
	end

	describe "GET #new" do

		it "assigns a new post to @banner" do
			get :new
      		assigns(:banner).should be_nil
		end

		it "renders the :new template" do
			get :new
			response.should render_template :new
		end

	end

	describe "POST banner" do

		context "with valid attributes" do

			it "creates a new post" do 

				expect {
					banner :create, banner: FactoryGirl.create(:banner)
				}.to change(Post, :count).by(1)

			end

			it "redirects to the banner page" do
				post :create, banner: FactoryGirl.create(:banner)
				response.should redirect_to admin_banner_path
			end

		end

		context "with invalid attributes" do

			it "does not save the banner" do
				expect {
					banner :create, banner: FactoryGirl.attributes_for(:banner, image: nil)
				}.not_to change(Banner, :count)
			end

			it "re-renders the :new method" do 
				post :banner, banner: FactoryGirl.attributes_for(:banner, image: nil)
				response.should render_template :create
			end

		end

	end

	describe "PUT update" do

		before :each do 
			@banner = Banner.new(:name => '123123', :image => 'string.png', :description => '123123')
			@banner.save
		end

		context "valid attributes" do
			
			it "located the request @ban" do 
				put :edit, id: @banner, banner: @banner
				assigns(:banner).should eq([@banner])
			end

			it "changes @banner's attr" do 

				put :update, id: @banner, banner: FactoryGirl.attributes_for(:banner, image: 'something.png')

				@banner.reload
				@banner.image.should eq("something.png")

			end
		end

	end

	describe "delete destroy" do

		before :each do 
			@banner = Banner.new(:name => '123123', :image => 'string.png', :description => '123123')
			@banner.save
		end

		it "deletes the contact" do
			expect {
				Banner.destroy(@banner)
				}.to change(Banner, :count).by(-1)
		end

		it "redirects to banner page" do
			delete :destroy, id: @banner
			response.should redirect_to admin_login_path
		end

	end
end