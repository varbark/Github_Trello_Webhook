class Board < ActiveRecord::Base
  belongs_to :user
  belongs_to :repo
  has_many :lists

  def self.findOrCreateBoards(result)
    result.each do |board|
      if  board['memberships'].find {|m| m['idMember'] == current_user..trello_uid }
        # TODO change to find by trello_id
        current_user.boards.find_by(name: board['name']) || Board.createBoard(board, current_user.id)
      end
    end
  end

  def self.createBoard(board)
    create! do |b|
      b.name = board['name']
      b.trello_id = board['id']
      b.syn = false
      b.user_id = current_user.id
    end
  end


end
