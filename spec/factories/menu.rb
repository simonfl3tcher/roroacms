FactoryGirl.define do
  
  factory :menu do
    name { Faker::Lorem.word }
    key { Faker::Lorem.word }
  end

end