FactoryGirl.define do |u|

  factory :post do
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

end
