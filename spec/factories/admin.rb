FactoryGirl.define do
  
  sequence(:id) {|n| rand(10000)}
  sequence(:email) {|n| "user#{n}@example.com"}
  sequence(:login) {|n| "user#{n}"}
  
  factory :admin do
    email {FactoryGirl.generate :email}
    username {FactoryGirl.generate :login}
    password "123123123"
    access_level "admin"
  end

  factory :invalid_admin, parent: :admin do |f|
  	f.username nil
  end

end