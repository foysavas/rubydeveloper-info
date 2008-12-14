require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Invite do

  before :each do
    Invite.all.destroy!
  end

  it "should have various properties" do
    i = Invite.new
    i.should respond_to :created_at
    i.should respond_to :updated_at
    i.should respond_to :random
    i.should respond_to :used
    i.should respond_to :email
    i.should respond_to :user_id
  end

  it "should generate a randomized alphanumeric string upon create" do
    i1 = Invite.new(:email => 'first@email.com')
    i2 = Invite.new(:email => 'second@email.com')
    i1.save
    i2.save
    i1.random.should_not be_nil
    i2.random.should_not be_nil
    i1.random.should_not == i2.random
  end

  it "should produce an invite code as random+'0'+id" do
    i = Invite.new(:email => 'first@email.com')
    i.save
    i.code.should == "#{i.random}0#{i.id}"
  end

  it "should have a class method for finding by invite code" do
    Invite.should respond_to :find
    i = Invite.new(:email => 'first@email.com')
    i.save
    Invite.find(i.code).should == i
  end

end
