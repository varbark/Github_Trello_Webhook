class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

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
    json = JSON.parse(request.body.gets)
    if json['action']
      repo_id = json['repository']['id']
      repo = Repo.find_by_github_id(repo_id)
      repo.handleWebhhok(json)
    else
    #   it is a webhook json
    end
    render :nothing => true
  end

end
