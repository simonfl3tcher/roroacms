FactoryGirl.define do

  factory :term_anatomy do
    taxonomy 'tag'
  end


  factory :term, :class => Term do |term|
    term.name { Faker::Lorem.sentence(3, true) }
    term.slug { Faker::Internet.slug(Faker::Lorem.words(4).join('-'), '-') }
    term.description { Faker::Lorem.paragraph(2) }
    term.term_anatomy { FactoryGirl.create(:term_anatomy, taxonomy: 'category') }
  end

  factory :tag, :class => Term do |term|
    term.name { Faker::Lorem.sentence(3, true) }
    term.slug { Faker::Internet.slug(Faker::Lorem.words(4).join('-'), '-') }
    term.description { Faker::Lorem.paragraph(2) }
    term.term_anatomy { FactoryGirl.create(:term_anatomy, taxonomy: 'tag') }
  end


  factory :invalid_term, parent: :term do |f|
    f.name nil
  end

end
