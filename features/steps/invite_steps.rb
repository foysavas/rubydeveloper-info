Given /^"(.*)" has not been invited$/ do |email|
  Invite.all(:email => email).destroy!
end

Given /^"(.*)" has been invited$/ do |email|
  visit '/invites/new'
  fill_in 'invite[email]', :with => email
  click_button "Invite Them!"
end

Given "I have been invited" do
  Invite.auto_migrate!
  @invite = Invite.create(:user_id => 1, :email => 'a@email.com')
end

Given "I have a used invite code" do
  Invite.auto_migrate!
  @invite = Invite.create(:user_id => 1, :email => 'a@email.com', :used => true)
end

When "I fill in my invite code" do
  fill_in "invite_code", :with => @invite.code
end
