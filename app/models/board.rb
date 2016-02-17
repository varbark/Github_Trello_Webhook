class Board < ActiveRecord::Base
  belongs_to :user
  belongs_to :repo
  has_many :lists
  include AppModules::Http


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
    openIssueList = JSON.parse(sendTrelloPostRequest('lists', token, "&name=#{self.repo.name}_openIssue&idBoard=#{self.trello_id}"))
    closeIssueList = JSON.parse(sendTrelloPostRequest('lists', token, "&name=#{self.repo.name}_closeIssue&idBoard=#{self.trello_id}"))
    pullRequestList = JSON.parse(sendTrelloPostRequest('lists', token, "&name=#{self.repo.name}_pullRequest&idBoard=#{self.trello_id}"))
    self.lists.create(trello_id: openIssueList['id'], name: openIssueList['name'], category: 'openIssue')
    self.lists.create(trello_id: closeIssueList['id'], name: closeIssueList['name'], category: 'closeIssue')
    self.lists.create(trello_id: pullRequestList['id'], name: pullRequestList['name'], category: 'pullRequest')
  end

end
