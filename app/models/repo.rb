class Repo < ActiveRecord::Base
  belongs_to :user
  has_one :board
  has_many :issues
  include AppModules::Http

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


  def createWebhook(token)
    path = "repos/#{self.full_name}/hooks"
    data =  {
        'name': 'web',
        'active': true,
        'events': [
            'issues',
            'issue_comment',
            'pull_request'
        ],
        'config': {
            'url': "#{ENV['WEB_URL']}/github/#{self.github_id}/hooks",
            "content_type": "json"
        }
    }
    res = sendGithubPostRequest(path, token, data)
    if res.status == 201
      self.update(syn: true)
    else
      puts 'error: can not create webhook'
    end
  end

end
