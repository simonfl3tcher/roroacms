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

# :admins_id, :post_content, :post_date, :post_name, :post_parent, :post_slug, :post_status, :post_title, :post_type, :disabled