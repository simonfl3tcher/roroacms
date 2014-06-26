require 'rails_helper'

RSpec.describe Term, :type => :model do

	let(:term) { FactoryGirl.create(:term) }
	let(:testing_term){ FactoryGirl.create(:term, name: 'Testing Term Title', parent: term.id) }
	let(:invalid_term) { FactoryGirl.create(:invalid_term) }

	it "has a valid factory" do 
		expect(FactoryGirl.create(:term)).to be_valid
	end

	it "is invalid without a name" do 
		expect(FactoryGirl.build(:term, name: nil)).to_not be_valid
	end

	it "builds the slug if created without a slug" do 
		expect(testing_term.slug).to eq('testing-term-title')
		expect(testing_term.slug).to eq('testing-term-title')
	end

	it "creates the structured url via the slug" do 
		expect(testing_term.structured_url).to eq('/' + testing_term.structured_url)
	end

	it "is invalid without a unique slug" do 
		expect(FactoryGirl.build(:term, slug: term.slug)).to_not be_valid
	end

	it "is invalid if it the slug does not match /\A[A-Za-z0-9-]*\z/" do 
		expect(FactoryGirl.build(:term, slug: 'Hesfd ssdf?-sdf? $')).to_not be_valid
		expect(FactoryGirl.build(:term, slug: 'hello-how-are-_?')).to_not be_valid
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
		term = Term.find(term.id)
		term.slug = '/123123'
		ter.save

		expect(testing_term.structured_url).to eq('/123123/' + testing_term.slug)
	end

	context "bulk updating" do 
		let(:array) { [FactoryGirl.create(:term).id, term.id] }

		it "deletes given records" do
			expect { Term.bulk_update({:to_do => 'destroy', :comments => @array}) }.to change(Term, :count).by(-2)
		end

	end

end