FactoryGirl.define do

  sequence(:id) {|n| rand(10000..100000000)}

  factory :admin, class: Roroacms::Admin do
    email { Faker::Internet.email }
    username { Faker::Lorem.word  }
    password "123123123"
    access_level "admin"
  end

  factory :invalid_admin, parent: :admin do |f|
    f.username nil
  end

  factory :comment, class: Roroacms::Comment do
    email { Faker::Internet.email }
    author { Faker::Name.name }
    comment { Faker::Lorem.paragraph(2) }
    post { FactoryGirl.create(:post) }
  end

  factory :invalid_comment, parent: :admin do |f|
    f.comment nil
  end

  factory :menu, class: Roroacms::Menu do
    name { Faker::Lorem.word }
    key { Faker::Lorem.word }
  end

  factory :post, class: Roroacms::Post do
    post_title { Faker::Lorem.sentence(3, true) }
    post_slug { Faker::Internet.slug(Faker::Lorem.words(4).join('-'), '-') }
    post_content { Faker::Lorem.paragraph(5) }
    post_date { Date.new(2012, 12, 3) }
    post_type 'post'
    disabled 'N'
  end

  factory :invalid_post, parent: :post do |f|
    f.post_title nil
  end

  factory :disabled_post, parent: :post do |f|
    f.post_type 'post'
    f.disabled 'Y'
  end

  factory :disabled_page, parent: :post do |f|
    f.post_type 'page'
    f.disabled 'Y'
  end

  factory :term_anatomy, class: Roroacms::TermAnatomy do
    taxonomy 'tag'
  end


  factory :term, class: Roroacms::Term do |term|
    term.name { Faker::Lorem.sentence(3, true) }
    term.slug { Faker::Internet.slug(Faker::Lorem.words(4).join('-'), '-') }
    term.description { Faker::Lorem.paragraph(2) }
    term.term_anatomy { FactoryGirl.create(:term_anatomy, taxonomy: 'category') }
  end

  factory :tag, class: Roroacms::Term do |term|
    term.name { Faker::Lorem.sentence(3, true) }
    term.slug { Faker::Internet.slug(Faker::Lorem.words(4).join('-'), '-') }
    term.description { Faker::Lorem.paragraph(2) }
    term.term_anatomy { FactoryGirl.create(:term_anatomy, taxonomy: 'tag') }
  end


  factory :invalid_term, parent: :term do |f|
    f.name nil
  end

end
