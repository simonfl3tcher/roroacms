require 'rails_helper'

RSpec.describe Admin::AdministratorsController, :type => :controller do

	let(:admin) { FactoryGirl.create(:admin) }
	before { sign_in(admin) }


	describe "GET #index" do 
		
		it "populates an array of contacts" do 
			get :index
	    	expect(assigns(:admins)).to_not be_nil
		end
		
		it "renders the :index template" do 
			get :index 
			expect(response).to render_template :index
		end
	
	end

	describe "GET #show" do 
		
		it "should redirect to administrators#edit" do 
			admin = FactoryGirl.create(:admin)
			get :show, id: admin 
			expect(response).to redirect_to edit_admin_administrator_path(admin)
		end  

	end

	describe "GET #new" do

		it "should create a new admin object" do 
			get :new
			expect(assigns(:admin)).to_not be_nil
		end

		it "renders the :new template" do
			get :new
			expect(response).to render_template :new
		end

		it "assigns form action to variable" do 
			get :new
			expect(assigns(:action)).to eq('create')
		end

	end


	describe "POST #create" do

		context "with valid attributes" do 

			it "creates new admin" do 
				expect { post :create, admin: FactoryGirl.attributes_for(:admin) }.to change(Admin,:count).by(1)
			end

			it "redirects to administrators#index" do 
				post :create, admin: FactoryGirl.attributes_for(:admin)
				expect(response).to redirect_to admin_administrators_path
			end

		end

		context "with invalid attributes" do 

			it "does not save the contact" do 
				expect { post :create, admin: FactoryGirl.attributes_for(:invalid_admin) }.to_not change(Admin,:count)
			end

			it "re-renders the new method" do 
				post :create, admin: FactoryGirl.attributes_for(:invalid_admin)
				expect(response).to render_template :new
			end

		end

	end

	describe "PUT #update" do 
		
		before(:each) do 
			@admin = FactoryGirl.create(:admin, first_name: "Simon", last_name: "Fletcher")
		end

		it 'debugging...' do
			expect(FactoryGirl.create(:admin)).to be_valid
		end

		context "valid attributes" do 

			it "located the requested @admin" do 
				put :update, id: @admin, admin: FactoryGirl.attributes_for(:admin)
				expect(assigns(:admin)).to eq(@admin)
			end

			it "changes @admin's attributes" do 
				put :update, id: @admin, admin: FactoryGirl.attributes_for(:admin, first_name: "Paul")
				@admin.reload
				expect(@admin.first_name).to eq("Paul")
			end

			it "redirects to the updated admin" do 
				put :update, id: @admin, admin: FactoryGirl.attributes_for(:admin)
				expect(response).to redirect_to edit_admin_administrator_path(@admin)
			end

		end

		context "invalid attributes" do 
			
			it "located the requested @admin" do 
				put :update, id: @admin, admin: FactoryGirl.attributes_for(:invalid_admin)
				expect(assigns(:admin)).to eq(@admin)
			end

			it "does not change @admin's attributes" do 
				put :update, id: @admin, admin: FactoryGirl.attributes_for(:invalid_admin, first_name: "Paul")
				@admin.reload
				expect(@admin.first_name).to_not eq("Paul")
			end

			it "re-renders the edit template" do 
				put :update, id: @admin, admin: FactoryGirl.attributes_for(:invalid_admin)
				expect(response).to render_template :edit
			end

		end

	end

	describe "DELETE #destroy" do 
		
		before(:each) do
			@admin = FactoryGirl.create(:admin)
		end

		it "deletes the contact" do 
			expect { delete :destroy, id: @admin }.to change(Admin,:count).by(-1)
		end

		it "redirect to administrators#index" do 
			delete :destroy, id: @admin
			expect(response).to redirect_to admin_administrators_path
		end

	end

end