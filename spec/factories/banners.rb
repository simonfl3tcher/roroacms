require "faker"

FactoryGirl.define do
		
	factory :banner do |f|

		f.name { Faker::Name.name}
		f.image { Faker::Lorem.word}
		f.description { Faker::Lorem.characters(15)}

	end

end
