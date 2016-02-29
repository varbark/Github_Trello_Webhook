class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    provider = auth.provider
    if provider == 'github'
      oauthGithub(auth)
      if github_user.ifTrelloTokenAvailable?
        # TODO try to use trello webhook to get the new board information
        createCurrentUserSession
        current_user.updateBoards
        redirect_to root_path
      else
        render 'pages/_loginTrello'
      end
    elsif provider == 'trello'
      oauthTrello(auth)
      createCurrentUserSession
      redirect_to root_path
    else
      puts "Can not find provider #{provider}"
    end
  end

  def destroy
    session[:github_user] = nil
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def oauthGithub(auth)
    user = User.findOrCreateUser(auth)
    user.updateRepos
    session[:github_user] = user.id
  end

  def oauthTrello(auth)
    github_user.create_with_trello(auth)
  end

  def createCurrentUserSession
    session[:user_id] = github_user.id
  end
end
