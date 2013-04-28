require "faker"

FactoryGirl.define do
		
	factory :user do |f|

		f.first_name { Faker::Name.first_name}
		f.last_name { Faker::Name.last_name}
		f.password { "$2a$10$dI4Izxcbe41FkY289uRQp.r6md0GwpPSZfOeJGiXL2BX1tuiNjcwO" }
		f.email { Faker::Internet.email }

	end

end