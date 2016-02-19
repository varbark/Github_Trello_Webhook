class List < ActiveRecord::Base
  belongs_to :board
  has_many :cards
  include AppModules::Http

  def self.createList(name, board, token)
    categories = ['openIssue', 'closeIssue', 'pullRequest']
    board_trello_id = board.trello_id
    categories.each do |category|
      create! do |list|
        list.name = name
        list.category = category
        list.board = board
        list.trello_id = list.sendTrello(name, token, category, board_trello_id)
      end
    end
  end

  def sendTrello(name, token, category, trello_id)
    res = JSON.parse(sendTrelloPostRequest('lists', token, "&name=#{name}_#{category}&idBoard=#{trello_id}"))
    res['id']
  end


  def createCard(data, title)
    urlParams = convertToUrl(data)
    token = self.board.user.trello_token
    request = JSON.parse(sendTrelloPostRequest('cards', token, urlParams))
    self.cards.create(name: title, trello_id: request['id'])
  end


  def moveCard(card, list, data)
    token = self.board.user.trello_token
    card.list = list
    urlParams = convertToUrl(data)
    sendTrelloPutRequest("cards/#{card.trello_id}/idList", token, urlParams)
  end


  def createComment(card, data)
    token = self.board.user.trello_token
    urlParams = convertToUrl(data)
    sendTrelloPostRequest("cards/#{card.trello_id}/actions/comments", token, urlParams)
  end

  private

  def convertToUrl(data)
    urlParams = data.map { |d| d.join('=') }
    if urlParams.length > 1
      urlParams = urlParams.join('&')
    else
      urlParams = urlParams[0]
    end
    URI.encode('&' + urlParams)
  end

end
