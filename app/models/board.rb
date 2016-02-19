class Board < ActiveRecord::Base
  belongs_to :user
  belongs_to :repo
  has_many :lists


  def self.findOrCreateBoards(result, user)
    result.each do |board|
      if  board['memberships'].find {|m| m['idMember'] == user.trello_id }
        # TODO change to find by trello_id
        self.find_by(trello_id: board['id']) || self.createBoard(board, user.id)
      end
    end
  end

  def self.createBoard(board, user_id)
    create! do |b|
      b.name = board['name']
      b.trello_id = board['id']
      b.syn = false
      b.user_id = user_id
    end
  end

  def occupied(repo)
    self.repo = repo
    self.syn = true
    self.save!
  end

  def connectTrello(token)
    #   Create new card for 3 events: open_issues, close_issues, pull_request
    name = self.repo.name
    self.lists.createList(name, self , token)
  end

end
