class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    provider = auth.provider
    if provider == 'github'
      oauthGithub(auth)
      if current_user.ifTrelloTokenAvailable?
        # TODO try to use trello webhook to get the new board information
        current_user.updateBoards
        redirect_to root_path
      else
        render 'pages/loginTrello'
      end
    elsif provider == 'trello'
      oauthTrello(auth)
      redirect_to root_path
    else
      puts "Can not find provider #{provider}"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def oauthGithub(auth)
    user = User.findOrCreateUser(auth)
    session[:user_id] = user.id
  end

  def oauthTrello(auth)
    current_user.create_with_trello(auth)
  end
end
