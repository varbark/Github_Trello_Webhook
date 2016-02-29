class User < ActiveRecord::Base
  has_many :repos
  has_many :boards
  include AppModules::Http

  def self.findOrCreateUser(auth)
    user = User.find_by(github_id: auth["uid"]) || User.create_with_github(auth)
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
    result = JSON.parse(sendGithubGetRequest('user/repos', self.github_token))
    Repo.findOrCreateRepos(self, result)
  end

  def create_with_trello(auth)
    self.trello_id = auth.uid
    self.trello_token = auth.credentials.token
    self.save!
    self.updateBoards
  end

  def ifTrelloTokenAvailable?
    token = self.trello_token
    res =  sendTrelloGetRequest("tokens/#{token}", token)
    if res.status == 200
      true
    else
      false
    end
  end


  def updateBoards
    result = JSON.parse(sendTrelloGetRequest("members/#{self.trello_id}/boards", self.trello_token))
    Board.findOrCreateBoards(result, self)
  end

  def findAvailableBoards
    self.boards.where(syn: false)
  end
end
