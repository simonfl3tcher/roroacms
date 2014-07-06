require 'rails_helper'

RSpec.describe Term, :type => :model do

  let!(:term) { FactoryGirl.create(:term) }

  it "has a valid factory" do
    expect(FactoryGirl.create(:term)).to be_valid
  end

  it "is invalid without a name" do
    expect(FactoryGirl.build(:term, name: nil)).to_not be_valid
  end

  it "builds the slug if created without a slug" do
    record = FactoryGirl.build(:term, slug: nil)
    expect(record).to be_valid
    expect(record.slug).to eq(record.name.downcase.gsub(' ', '-').gsub(/[^a-z0-9\-\s]/i, ''))
  end

  it "creates the structured url via the slug" do
    expect(term.structured_url).to eq('/' + term.slug)
  end

  it "is invalid without a unique slug" do
    expect(FactoryGirl.build(:term, slug: term.slug)).to_not be_valid
  end

  it "should format the slug to match the /\A[A-Za-z0-9\-]*\z/ format" do
    expect(FactoryGirl.build(:term, slug: 'Hesfd ssdf?-sdf? $')).to be_valid
    expect(FactoryGirl.build(:term, slug: 'hello-how-are-_?')).to be_valid
  end

  it "returns the redirect url via the type of term" do
    expect(Term.get_redirect_url({:type_taxonomy => 'category'})).to eq('/admin/article/categories')
    expect(Term.get_redirect_url({:type_taxonomy => 'tag'})).to eq('/admin/article/tags')
    expect(Term.get_redirect_url).to eq('/admin')
  end

  it "returns type for front end visuals" do
    expect(Term.get_type_of_term({:type_taxonomy => 'category'})).to eq('Category')
    expect(Term.get_type_of_term({:type_taxonomy => 'tag'})).to eq('Tag')
  end


  it "updates the slug for subcategories" do
    sub_term = FactoryGirl.create(:term, name: 'Testing Term Title', parent: term.id)
    t = Term.find(term.id)
    t.slug = 'hello'
    t.save
    expect(Term.find(sub_term.id).structured_url).to eq('/hello/' + sub_term.slug)
  end

  context "bulk updating" do
    let!(:term_2){ FactoryGirl.create(:term) }
    it "deletes given records" do
      expect { Term.bulk_update({:to_do => 'destroy', :categories => [term_2.id, term.id]}) }.to change(Term,:count).by(-2)
    end

  end

end
