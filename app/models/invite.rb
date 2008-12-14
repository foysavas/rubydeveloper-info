class Invite
  include DataMapper::Resource
  
  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime
  property :random, String

  property :used, Boolean, :default => 0
  property :email, String, :length => 255
  validates_is_unique :email

  belongs_to :user

  before :create, :randomize

  def randomize
    code_length = 10
    valid_chars = ("A".."Z").to_a + ("1".."9").to_a
    length = valid_chars.size
    hex_code = ""
    1.upto(code_length) { |i| hex_code << valid_chars[rand(length-1)] }
    self.random = hex_code
  end

  def code
    self.random.to_s + '0' + self.id.to_s
  end

  class << self
    def find(code)
      code_broke = code.split("0", 2)
      Invite.first(:id => code_broke[1], :random => code_broke[0])
    end
  end
end
