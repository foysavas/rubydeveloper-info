Given /^I am not authenticated$/ do
  # yay!
end

Given "I am authenticated" do
  unless @user
    if User.count > 0
      @user = User.first
    else
      @user = User.create(:login => 'foysavas@gmail.com', :password => 'password', :password_confirmation => 'password')
    end
  end
  visit "/login"
  fill_in 'login', :with => @user.login
  fill_in 'password', :with => 'password'
  click_button "Login"
end

Then "I should be logged in" do
  response.body.to_s.should =~ /logout/m
end
