def fresh_user
  User.auto_migrate!
  User.create(:login => 'someone@gmail.com', :password => 'password', :password_confirmation => 'password', :full_name => 'Someone')
end

Given /^a user is contributor to "(.*)"$/ do |project_name|
  @user = fresh_user
  @project = Project.create(:name => project_name)
  @contribution = Contribution.create(:user => @user, :project => @project)
end

Given /^a user is not a contributor to "(.*)"$/ do |project_name|
  @user = fresh_user
end
