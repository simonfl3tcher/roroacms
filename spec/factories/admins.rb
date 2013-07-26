require "faker"

FactoryGirl.define do
		
	factory :admin do |f|

		f.first_name { Faker::Name.first_name}
		f.last_name { Faker::Name.last_name}
		f.username { Faker::Name.name }
		f.access_level { 'admin' }
		f.password { "$2a$10$dI4Izxcbe41FkY289uRQp.r6md0GwpPSZfOeJGiXL2BX1tuiNjcwO" }
		f.email { Faker::Internet.email }

	end

	factory :access_admin do |f|

		f.first_name { 'Simon'}
		f.last_name { 'Fletcher'}
		f.username { 'simonfletcher'}
		f.access_level { 'admin' }
		f.password { '123123' }
		f.email { 'simonfletcher0@gmail.com' }

	end

end
