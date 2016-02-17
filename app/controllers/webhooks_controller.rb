class WebhooksController < ApplicationController
  respond_to :html, :js
  def connect
    board = Board.find(params['webhook']['board_id'][0])
    repo = Repo.find(params['webhook']['repo_id'])
    board.occupied(repo)
    redirect_to root_path
  end

  def sync
    github_token = current_user.github_token
    trello_token = current_user.trello_token
    repo = Repo.find(params['repo_id'])
    board = repo.board
    repo.createWebhook(github_token)
    board.connectTrello(trello_token)
    redirect_to root_path
  end

  def receiveHooks

  end

end
