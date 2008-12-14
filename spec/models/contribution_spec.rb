require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Contribution do
  before :each do
    Contribution.auto_migrate!
    User.auto_migrate!
    Project.auto_migrate!
    @p = Project.create(:name => 'RubyDeveloper.Info')
    @u = User.create(:login => 'foysavas@gmail.com', :password => 'password', :password_confirmation => 'password')
  end

  it "should have various properties" do
    c = Contribution.new
    c.should respond_to :email
    c.should respond_to :user_id
    c.should respond_to :project_id
  end

  it "should bulk insert with a class method" do
    Contribution.should respond_to :bulk_insert
    authors = ['foysavas@gmail.com','you@email.com']
    Contribution.bulk_insert(authors, @p.id)
    Contribution.count.should == 2
    Contribution.get(1).user_id.should == @u.id
    Contribution.get(1).project_id.should == @p.id
    Contribution.get(2).user_id.should == nil
    Contribution.get(2).project_id.should == @p.id
  end

end
