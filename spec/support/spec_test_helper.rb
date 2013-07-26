module SpecTestHelper   
  def login_admin
    Admin.set_sessions(1, 'simonfletcher')
  end
end