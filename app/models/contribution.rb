class Contribution
  include DataMapper::Resource

  property :id, Serial
  property :updated_at, DateTime
  property :created_at, DateTime

  property :email, String, :length => 255
  belongs_to :user
  belongs_to :project

  class << self
    def bulk_insert(authors, project_id)
      authors.each do |a_email|
        attrs = {:email => a_email, :project_id => project_id}
        unless(u = User.first(:login => a_email)).nil?
          attrs.merge!(:user_id => u.id)
        end
        Contribution.create(attrs)
      end   
    end
  end

end
