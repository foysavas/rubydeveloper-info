require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Repo do
  before :each do
    Repo.auto_migrate!
    Project.auto_migrate!
    @p = Project.create(:name => 'Extlib')
    @r = Repo.create(:project => @p, :remote_url => 'git://github.com/sam/extlib.git')
  end

  it "should have various properties" do
    @r.should respond_to :project
    @r.should respond_to :remote_url
    @r.should respond_to :checked_at
    @r.should respond_to :commit_count
  end

  it "should call bulk contribution inserts when checked" do
    @r.should_receive(:lastest_authors).and_return(['new@mail.com','old@mail.com'])
    Contribution.should_receive(:all).and_return(['old@mail.com'])
    Contribution.should_receive(:bulk_insert).with(['new@mail.com'],@p.id)
    @r.check
  end

  it "should set the checked_at time after check" do
    @r.stub!(:lastest_authors).and_return([])
    @r.should_receive(:save)
    @r.check
    @r.checked_at.should_not be_nil
  end

  it "should have a class method for checking all repos" do
    Repo.should respond_to :check_all
  end 

end
