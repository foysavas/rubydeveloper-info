# This is a default user class used to activate merb-auth.  Feel free to change from a User to 
# Some other class, or to remove it altogether.  If removed, merb-auth may not work by default.
#
# Don't forget that by default the salted_user mixin is used from merb-more
# You'll need to setup your db as per the salted_user mixin, and you'll need
# To use :password, and :password_confirmation when creating a user
#
# see merb/merb-auth/setup.rb to see how to disable the salted_user mixin
# 
# You will need to setup your database and create a user.
class User
  include DataMapper::Resource
  include Gravtastic::Resource
  include DataMapper::Is::Paginated
  is_paginated(:per_page => 25)

  property :id,     Serial
  property :login,  String, :length => 255
  property :created_at, DateTime
  property :updated_at, DateTime
  validates_is_unique :login
  validates_format :login, :as => :email_address, :message => "Email must be valid"


  property :full_name, String, :length => 255
  
  property :irc, String
  property :github, String
  property :twitter, String
  property :homepage, String, :length => 255

  property :statement, DM::Text

  # Pick a Side
  property :on_team_awesome, TrueClass, :default => false

  # Invitations
  belongs_to :inviter, :class_name => "User", :child_key => [:inviter_id]
  has n, :invitees, :class_name => "User", :child_key => [:inviter_id]
  property :invite_depth, Integer, :default => 0
  property :invite_score, Integer, :default => 0
  before :create, :set_invite_depth

  is_gravtastic :with => 'login'

  def user_to_param
    "#{id}-#{full_name.gsub(/[^[:alnum:] ]/,'')}"
  end

  # Contributions
  has n, :contributions
  has n, :projects, :through => :contributions

  after :create, :attach_contributions

  before :save, :check_for_changed_email
  def check_for_changed_email
    if attribute_dirty?(:login)
      reset_contributions
      attach_contributions
    end
  end


  private

  def set_invite_depth
    unless inviter.nil?
      self.invite_depth = inviter.invite_depth + 1
    end
  end

  def reset_contributions
    Contribution.all(:user_id => id).update!(:user_id => nil)
  end

  def attach_contributions
    Contribution.all(:email => login).update!(:user_id => id)
  end

end
