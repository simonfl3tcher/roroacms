def sign_in(user)
  visit "/admin/login"
  fill_in "email",    with: user.email
  fill_in "password", with: user.password
  click_button "Sign in"
end
