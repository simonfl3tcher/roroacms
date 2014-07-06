FactoryGirl.define do

  factory :comment do
    email { Faker::Internet.email }
    author { Faker::Name.name }
    comment { Faker::Lorem.paragraph(2) }
    post { FactoryGirl.create(:post) }
  end

  factory :invalid_comment, parent: :admin do |f|
    f.comment nil
  end

end
