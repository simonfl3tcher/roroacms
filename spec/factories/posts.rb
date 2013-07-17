require "faker"

FactoryGirl.define do
		
	factory :post do |f|

		f.post_name { Faker::Name.name}
		f.post_title { Faker::Name.name}

	end

	factory :invalid_post, parent: :post do |f|
		f.post_name nil
	end

end
