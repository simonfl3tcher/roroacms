require 'spec_helper'

RSpec.describe Roroacms::Trash, :type => :model do

  let!(:post) { FactoryGirl.create(:disabled_post) }
  let!(:page) { FactoryGirl.create(:disabled_page) }

  before(:all) do 
    Roroacms::Post.update_all("disabled = 'N'")
  end


  it "should delete posts" do
    expect { Roroacms::Trash.deal_with_form({ to_do: "destroy", posts: [post.id] }) }.to change(Roroacms::Post,:count).by(-1)
  end

  it "should reinstate posts" do
    Roroacms::Trash.deal_with_form({ to_do: "reinstate", posts: [post.id] })
    expect(Roroacms::Post.find(post.id).disabled).to eq('N')
  end

  it "should reinstate pages" do
    Roroacms::Trash.deal_with_form({ to_do: "reinstate", pages: [page.id] })
    expect(Roroacms::Post.find(page.id).disabled).to eq('N')
  end

  it "should delete pages" do
    expect { Roroacms::Trash.deal_with_form({ to_do: "destroy", pages: [page.id] }) }.to change(Roroacms::Post,:count).by(-1)
  end

end
