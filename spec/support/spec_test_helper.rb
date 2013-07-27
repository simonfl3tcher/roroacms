module SpecTestHelper   

  def sign_in 
  	visit admin_path 
  	click_link 'Log In' 
  	fill_in 'username', with: 'simonfletcher'
  	fill_in 'password', with: '123123' 
  	click_button 'Sign In' 
  end 
  
end