require 'rails_helper'

RSpec.describe Admin::AdministratorsController, :type => :controller do

  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:new_admin) { FactoryGirl.create(:admin, first_name: "Simon", last_name: "Fletcher") }
  before { sign_in(admin) }


  describe "GET #index" do

    before(:each) do
      get :index
    end

    it "should populate an array of contacts" do
      expect(assigns(:admins)).to_not be_nil
    end

    it "should render the :index template" do
      expect(response).to render_template :index
    end

  end

  describe "GET #new" do

    before(:each) do
      get :new
    end

    it "should create a new admin object" do
      expect(assigns(:admin)).to_not be_nil
    end

    it "should render the :new template" do
      expect(response).to render_template :new
    end

    it "should assign form action to variable" do
      expect(assigns(:action)).to eq('create')
    end

  end


  describe "POST #create" do

    context "with valid attributes" do

      it "should create new admin" do
        expect { post :create, admin: FactoryGirl.attributes_for(:admin) }.to change(Admin,:count).by(1)
      end

      it "should redirect to administrators#index" do
        post :create, admin: FactoryGirl.attributes_for(:admin)
        expect(response).to redirect_to admin_administrators_path
      end

    end

    context "with invalid attributes" do

      it "should not save the contact" do
        expect { post :create, admin: FactoryGirl.attributes_for(:invalid_admin) }.to_not change(Admin,:count)
      end

      it "should re-render the new method" do
        post :create, admin: FactoryGirl.attributes_for(:invalid_admin)
        expect(response).to render_template :new
      end

    end

  end

  describe "PUT #update" do

    context "valid attributes" do

      it "should located the requested @admin" do
        put :update, id: new_admin, admin: FactoryGirl.attributes_for(:admin)
        expect(assigns(:admin)).to eq(new_admin)
      end

      it "should change new_admin's attributes" do
        put :update, id: new_admin, admin: FactoryGirl.attributes_for(:admin, first_name: "Paul")
        new_admin.reload
        expect(new_admin.first_name).to eq("Paul")
      end

      it "should redirect to the updated admin" do
        put :update, id: new_admin, admin: FactoryGirl.attributes_for(:admin)
        expect(response).to redirect_to edit_admin_administrator_path(new_admin)
      end

    end

    context "invalid attributes" do

      it "should locate the requested @admin" do
        put :update, id: new_admin, admin: FactoryGirl.attributes_for(:invalid_admin)
        expect(assigns(:admin)).to eq(new_admin)
      end

      it "should not change new_admin's attributes" do
        put :update, id: new_admin, admin: FactoryGirl.attributes_for(:invalid_admin, first_name: "Paul")
        new_admin.reload
        expect(new_admin.first_name).to_not eq("Paul")
      end

      it "should re-render the edit template" do
        put :update, id: new_admin, admin: FactoryGirl.attributes_for(:invalid_admin)
        expect(response).to render_template :edit
      end

    end

  end

  describe "DELETE #destroy" do

    it "deletes the contact" do
      expect { delete :destroy, id: new_admin.id }.to change(Admin,:count).by(-1)
    end

    it "redirect to administrators#index" do
      delete :destroy, id: new_admin
      expect(response).to redirect_to admin_administrators_path
    end

  end

end
