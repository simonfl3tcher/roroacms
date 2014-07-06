require 'rails_helper'

RSpec.describe Admin::TermsController, :type => :controller do

  let(:admin) { FactoryGirl.create(:admin) }
  let!(:term) { FactoryGirl.create(:term) }
  before { sign_in(admin) }

  describe "GET #categories" do

    before(:each) do
      get :categories
    end

    it "should set type to category" do
      expect(assigns(:type)).to eq('category')
    end

    it "should render the view template" do
      expect(response).to render_template :view
    end

  end

  describe "GET #tags" do

    before(:each) do
      get :tags
    end

    it "should set type to tag" do
      expect(assigns(:type)).to eq('tag')
    end

    it "should render the view template" do
      expect(response).to render_template :view
    end

  end

  describe "POST #create" do

    context "with valid attributes" do

      it "creates new term" do
        expect { post :create, {term: FactoryGirl.attributes_for(:term) } }.to change(Term,:count).by(1)
      end

      it "redirects to article/categories" do
        post :create, {term: FactoryGirl.attributes_for(:term), type_taxonomy: "category"}
        expect(response).to redirect_to admin_article_categories_path
      end

      it "redirects to article/tags" do
        post :create, {term: FactoryGirl.attributes_for(:term), type_taxonomy: "tag"}
        expect(response).to redirect_to admin_article_tags_path
      end
    end

    context "with invalid attributes" do

      it "does not save the contact" do
        expect { post :create, {term: FactoryGirl.attributes_for(:term, name: nil) } }.to_not change(Term,:count)
      end

      it "redirects to article/categories" do
        post :create, {term: FactoryGirl.attributes_for(:term, name: nil), type_taxonomy: "category"}
        expect(response).to redirect_to admin_article_categories_path
      end

      it "redirects to article/tags" do
        post :create, {term: FactoryGirl.attributes_for(:term, name: nil), type_taxonomy: "tag"}
        expect(response).to redirect_to admin_article_tags_path
      end

    end

  end

  describe "PUT #edit" do

    before(:each) do
      get :edit, id: term
    end

    it "should get the term object" do
      expect(assigns(:category)).to_not be_nil
    end

    it "renders the :edit template" do
      expect(response).to render_template :edit
    end

  end

  describe "PUT #update" do

    it "locates the requested record" do
      put :update, id: term
      expect(assigns(:category)).to eq(term)
    end

    context "with valid attributes" do

      before(:each) do
        put :update, { term: FactoryGirl.attributes_for(:term, name: "testing test"), id: term }
      end

      it "updates the given term" do
        term.reload
        expect(term.name).to eq("testing test")
      end

      it "renders the :edit template" do
        expect(response).to redirect_to edit_admin_term_path(term)
      end

    end

    context "with invalid attributes" do

      before(:each) do
        put :update, { term: FactoryGirl.attributes_for(:invalid_term, slug: '123123'), id: term }
      end

      it "does not save the contact" do
        term.reload
        expect(term.slug).to_not eq("123123")
      end

      it "renders the :edit template" do
        expect(response).to render_template :edit
      end

    end

  end

  describe "DELETE #destroy" do

    before(:each) do
      delete :destroy, id: term
    end

    it "deletes the term" do
      expect(Term.where(:id => term.id)).to_not exist
    end

    it "redirects to article/categories" do
      expect(response).to redirect_to admin_article_categories_path
    end

  end

  describe "POST #bulk_update" do

    let!(:array){ [term.id, FactoryGirl.create(:term).id] }

    it "deletes the given terms" do
      post :bulk_update, { to_do: "destroy", categories: array }
      expect(Term.where(:id => term.id)).to_not exist
    end

    it "redirects to article/categories" do
      post :bulk_update, {to_do: "destory", categories: array, type_taxonomy: "category"}
      expect(response).to redirect_to admin_article_categories_path
    end

    it "redirects to article/tags" do
      post :bulk_update, {to_do: "destory", categories: array, type_taxonomy: "tag"}
      expect(response).to redirect_to admin_article_tags_path
    end

  end

end
