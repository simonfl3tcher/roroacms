FactoryGirl.define do
  
  factory :term_anatomy do 
  	taxonomy 'category'
  end


  factory :term do
    name { Faker::Lorem.sentence(3, true) }
    slug { Faker::Internet.slug(Faker::Lorem.words(4).join('-'), '-') }
    description { Faker::Lorem.paragraph(2) }
    term_anatomy { FactoryGirl.create(:term_anatomy, taxonomy: 'category') }
  end

  factory :term_tag, parent: :term do |f|
    f.term_anatomy {  FactoryGirl.create(:term_anatomy, taxonomy: 'tag') }
  end

  factory :invalid_term, parent: :term do |f|
  	f.name nil
  end

end