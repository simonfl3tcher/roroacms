FactoryGirl.define do

  
	factory :category, :class => Term do |f|
		f.name { Faker::Lorem.sentence(3, true) }
		f.slug { Faker::Internet.slug(Faker::Lorem.words(4).join('-'), '-') }
		f.description { Faker::Lorem.paragraph(2) }
	end

	factory :term_anatomy_category, :class => TermAnatomy do 
		taxonomy 'category'
		term_id nil
	end

	factory :term_anatomy_tag, :class => TermAnatomy do 
		taxonomy 'tag'
		term_id nil
	end

end