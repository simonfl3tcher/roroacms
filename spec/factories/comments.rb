# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  	factory :comment do |f|

		f.author { Faker::Name.name}
		f.comment { Faker::Lorem.paragraph}
		f.email { Faker::Internet.email}
		f.website { Faker::Internet.url}
		f.comment_approved { 'N' }
		f.post_id { 1 }

	end
end