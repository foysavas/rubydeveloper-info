Given "there are no users" do
  User.auto_migrate!
  @user_count = 0
end

Given "there are users" do
  User.auto_migrate!
  User.fix {{
    :full_name => (full_name = unique { /\w+/.gen }),
    :login => "#{full_name}@email.com", 
    :password => 'password',
    :password_confirmation => 'password',
    :inviter_id => rand(User.count)
  }}
  10.times { User.gen }
end

When "I look at the user's profile" do
  visit resource(@user)
end

Then /^I should see user profile "(.*)"$/ do |user_id|
  u = User[user_id]
  response.body.to_s.should =~ Regexp.new(u.full_name)
end

