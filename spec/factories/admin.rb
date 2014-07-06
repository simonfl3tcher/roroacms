FactoryGirl.define do
  
  sequence(:id) {|n| rand(10000..100000000)}
  
  factory :admin do
    email { Faker::Internet.email }
    username { Faker::Lorem.word  }
    password "123123123"
    access_level "admin"
  end

  factory :invalid_admin, parent: :admin do |f|
  	f.username nil
  end

end