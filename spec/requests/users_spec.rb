require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

User.fix {{
  :full_name => (full_name = unique { /\w+/.gen }),
  :login => "#{full_name}@email.com",
  :password => 'password',
  :password_confirmation => 'password',
  :inviter_id => rand(User.count)+1
}}

given "a user exists" do
  DataMapper.auto_migrate!
  User.gen
end

given "many users exist" do
  DataMapper.auto_migrate!
  50.times { User.gen }
end


describe "resource(:users) populated", :given => "many users exist" do

  before :each do
    @response = request(resource(:users))
  end

  it "respond successfully" do
    @response.should be_successful
  end

  it "should contain a table of users" do
    @response.should have_selector("table.users")
  end
 
  it "should be paginated" do
    @response.should have_selector("div.paginated")
    page_two = click_link "2"
    page_two.should have_selector('table.users')
  end
end


describe "resource(:users)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:users))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a table of users" do
      @response.should have_xpath("//table")
    end   
  end
  
end

describe "resource(:users, :new)" do
  before(:each) do
    @response = request(resource(:users, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@user)", :given => "a user exists" do
  describe "GET" do
    before(:each) do
      @response = request(resource(User.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end    
end

