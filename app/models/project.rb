class Project
  include DataMapper::Resource

  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime

  property :name, String

  has n, :repos
  has n, :contributions
end
