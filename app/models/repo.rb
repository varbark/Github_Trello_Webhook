class Repo < ActiveRecord::Base
  belongs_to :user
  has_one :board
  has_many :issues

  def self.findOrCreateRepos(user, result)
    result.each do |repo|
      self.find_by(github_id: repo['id']) || self.createRepo(repo, user.id)
    end
  end

  def self.createRepo(repo, user_id)
    create! do |r|
      r.name = repo['name']
      r.full_name = repo['full_name']
      r.syn = false
      r.github_id = repo['id']
      r.user_id = user_id
    end
  end

end
