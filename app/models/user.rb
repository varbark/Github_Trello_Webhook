class User < ActiveRecord::Base
  has_many :repos
  has_many :boards
  include AppModules::Http

  def self.findOrCreateUser(auth)
    user = User.find_by(github_id: auth["uid"]) || User.create_with_github(auth)
  end

  def self.create_with_github(auth)
    create! do |user|
      user.name = auth.info.name
      user.github_id = auth.uid
      user.github_token = auth.credentials.token
    end
  end


  def create_with_trello(auth)
    self.trello_id = auth.uid
    self.trello_token = auth.credentials.token
    self.save!
    self.updateBoards
  end

  def updateBoards
    token
    result = sendTrelloGetRequest("members/#{self.trello_id}/boards")
    Board.findOrCreateBoards(result)
  end

  def token
    self.trello_token
  end

end
