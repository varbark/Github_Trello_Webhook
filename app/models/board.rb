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


end
