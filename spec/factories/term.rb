FactoryGirl.define do
  
  factory :term do
    name { Faker::Lorem.sentence(3, true) }
    slug { Faker::Internet.slug(Faker::Lorem.words(4).join('-'), '-') }
    description { Faker::Lorem.paragraph(2) }
  end

  factory :invalid_term, parent: :term do |f|
  	f.name nil
  end

end