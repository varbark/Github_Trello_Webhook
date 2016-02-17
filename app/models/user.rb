class User < ActiveRecord::Base
  has_many :repos
  has_many :boards
  include AppModules::Http

  def self.findOrCreateUser(auth)
    user = User.find_by(github_id: auth["uid"]) || User.create_with_github(auth)
    user.updateRepos
    user
  end

  def self.create_with_github(auth)
    create! do |user|
      user.name = auth.info.name
      user.github_id = auth.uid
      user.github_token = auth.credentials.token
    end
  end

  def updateRepos
    result = sendGithubGetRequest('user/repos', self.github_token)
    Repo.findOrCreateRepos(self, result)
  end




  def create_with_trello(auth)
    self.trello_id = auth.uid
    self.trello_token = auth.credentials.token
    self.save!
    self.updateBoards
  end

  def updateBoards
    result = sendTrelloGetRequest("members/#{self.trello_id}/boards", self.trello_token)
    Board.findOrCreateBoards(result, self)
  end

end
