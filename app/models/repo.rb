require 'grit'

class Repo
  include DataMapper::Resource

  property :id, Serial
  property :updated_at, DateTime
  property :created_at, DateTime

  property :checked_at, DateTime
  property :commit_count, Integer, :default => 0

  property :remote_url, String, :length => 500

  belongs_to :project

  def check
    authors = lastest_authors
    known_authors = Contribution.all(:email.in => authors, :project_id => project_id)
    new_authors = authors - known_authors
    Contribution.bulk_insert(new_authors, project_id)
    self.checked_at = Time.now
    save
  end

  class << self
    def check_all
      Repo.all.each do |repo|
        repo.check
      end
    end
  end

  private

  def latest_authors
    new_commits.map { |c| c.author.email }.uniq
  end

  def new_commits
    r = []
    page_size = 50
    begin
      page = repo.commits('master', page_size, @commit_count)
      r = r + page
      @commit_count = @commit_count + page.size
    end while (page.size == page_size)
    r
  end

  def repo
    @repo ||= initialize_repo
  end

  def initialize_repo
    location = Merb.root + "/repos/" + self.id.to_s
    begin
      FileUtils.cd(location)
    rescue
      system "git clone #{@remote_url} #{location}"
      FileUtils.cd(location)
    ensure
      system "git pull"
      FileUtils.cd(Merb.root)
    end
    Grit::Repo.new(location)
  end

end
