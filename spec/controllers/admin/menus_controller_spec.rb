require 'rails_helper'

RSpec.describe Admin::MenusController, :type => :controller do

	let(:admin) { FactoryGirl.create(:admin) }
	before { sign_in(admin) }

	before(:each) do 
		@menu = FactoryGirl.create(:menu)
	end

	describe "GET #index" do 

		it "populates an array of the menu objects" do 
			get :index
	    	expect(assigns(:all_menus)).to_not be_nil
		end

		it "creates an empty menu object for create form" do 
			get :index
			expect(assigns(:menu)).to_not be_nil
		end
		
		it "renders the :index template" do 
			get :index 
			expect(response).to render_template :index
		end
	
	end

	describe "PUT #edit" do 
		
		it "should create the menu object" do 
			get :edit, id: @menu
			expect(assigns(:menu)).to_not be_nil
		end

		it "renders the :edit template" do
			get :edit, id: @menu
			expect(response).to render_template :edit
		end

	end


	describe "POST #create" do

		context "with valid attributes" do 

			it "creates new menu" do
				expect { post :create, {menu: FactoryGirl.attributes_for(:menu) } }.to change(Menu,:count).by(1)
			end

			it "redirects to administrators#index" do 
				post :create, {menu: FactoryGirl.attributes_for(:menu) }
				expect(response).to redirect_to edit_admin_menu_path(assigns(:menu))
			end

		end

		context "with invalid attributes" do 

			it "does not save the contact" do 
				expect{post :create, {menu: FactoryGirl.attributes_for(:menu, name: nil) }}.to_not change(Menu,:count)
			end

			it "re-renders the new method" do 
				post :create, {menu: FactoryGirl.attributes_for(:menu, name: nil) }
				expect(response).to render_template :index
			end

		end

	end

	describe "DELETE #destroy" do 
		it "deletes the menu" do 
			expect{delete :destroy, id: @menu}.to change(Menu,:count).by(-1)
		end
	end

	describe "POST #save_menu" do 

		it "saves the menu" do 
			post :save_menu, {menuid: @menu, data: nil}
			expect(response.body).to eq('done')
		end

	end

	describe "POST #ajax_dropbox" do 

		it "render a a visual representation of the created record" do 
			post :ajax_dropbox
			expect(response).to render_template(:partial => 'admin/menus/partials/_menu_dropdown')
		end

	end


end