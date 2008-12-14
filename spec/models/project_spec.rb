require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Project do
  before :each do
    Project.auto_migrate!
    Repo.auto_migrate!
    Contribution.auto_migrate!
    @p = Project.create(:name => 'RubyDeveloper.Info')
  end

  it "should have various properties" do
    @p.should respond_to :name
    @p.should respond_to :repos
    @p.should respond_to :contributions
  end

  it "should have n repos" do
    Repo.create(:project => @p)
    @p.reload
    @p.repos.size.should == 1
  end

  it "should have n contributions" do
    Contribution.create(:project => @p)
    @p.reload
    @p.contributions.size.should == 1
  end

end
