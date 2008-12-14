Given /^I am a contributor to "(.*)"$/ do |project_name|
  @project = Project.create(:name => project_name)
  @contribution = Contribution.create(:user => @user, :project => @project)
end

Given /^I am not a contributor to "(.*)"$/ do |project_name|
end

Then /^I should be shown as a "(.*)" contributor$/ do |project_name|
 response.body.to_s.should =~ /Contributor to #{project_name}/m 
end

Then /^I should not be shown as a "(.*)" contributor$/ do |project_name|
 response.body.to_s.should_not =~ /Contributor to #{project_name}/m 
end


