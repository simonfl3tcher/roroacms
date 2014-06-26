require 'rails_helper'

RSpec.describe Trash, :type => :model do

	before(:each) do 
		@post = FactoryGirl.create(:disabled_post)
		@page = FactoryGirl.create(:disabled_page)
	end


	it "should delete posts" do 
		expect { Trash.deal_with_form({:to_do => "destroy", :posts => [@post.id]}) }.to change(Post,:count).by(-1)
	end

	it "should reinstate posts" do 
		Trash.deal_with_form({:to_do => "reinstate", :posts => [@post.id]})
		expect(Post.find(@post.id).disabled).to eq('N')
	end

	it "should reinstate pages" do 
		Trash.deal_with_form({:to_do => "reinstate", :pages => [@page.id]})
		expect(Post.find(@page.id).disabled).to eq('N')
	end

	it "should delete pages" do
		expect { Trash.deal_with_form({:to_do => "destroy", :pages => [@page.id]}) }.to change(Post,:count).by(-1)
	end
	
end