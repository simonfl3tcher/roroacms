require "faker"

FactoryGirl.define do
		
	factory :post do |f|

		f.post_name { '123123'}
		f.post_title { '123123123123'}

	end

	factory :invalid_post, parent: :post do |f|
		f.post_name nil
	end

end
