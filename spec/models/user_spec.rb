require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe User do

  before :each do
    User.all.destroy!
    Contribution.auto_migrate!
    Project.auto_migrate!
  end

  it "should have various properties" do
    u = User.new
    u.should respond_to :full_name
    u.should respond_to :irc
    u.should respond_to :github
    u.should respond_to :twitter
    u.should respond_to :homepage
    u.should respond_to :statement
    u.should respond_to :inviter_id
    u.should respond_to :invite_depth
    u.should respond_to :invite_score
    u.should respond_to :on_team_awesome
    u.should respond_to :contributions
    u.should respond_to :projects
  end

  it "should set an incrementing invite depth before create" do
    u = User.new(:login => 'one@email.com', :password => 'password', :password_confirmation => 'password')
    u.save
    u.invite_depth.should == 0

    u2 = User.new(:login => 'two@email.com', :password => 'password', :password_confirmation => 'password', :inviter_id => u.id )
    u2.save
    u2.invite_depth.should == 1
  end

  it "should update contributions when you change email" do
    p = Project.create(:name => 'Test')
    c1 = Contribution.create(:email => 'contrib1@email.com', :project => p)
    c2 = Contribution.create(:email => 'contrib2@email.com', :project => p)

    u = User.create(:login => 'contrib1@email.com', :password => 'password', :password_confirmation => 'password')
    u.reload
    u.contributions.size.should == 1
    u.contributions.include?(c1).should == true

    u.login = 'contrib2@email.com'
    u.save
    u.reload
    u.contributions.size.should == 1
    u.contributions.include?(c2).should == true
  end

end
