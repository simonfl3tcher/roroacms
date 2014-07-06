def sign_in(user)
  visit admin_login_index_path
  fill_in "email",    with: user.email
  fill_in "password", with: user.password
  click_button "Sign in"
end
