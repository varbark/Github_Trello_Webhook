class SessionsController < ApplicationController
  include AppModules::Http
  def create
    auth = request.env["omniauth.auth"]
    if auth.provider == 'github'
      oauthGithub(auth)
      if ifTreloTokenAvailable?
        current_user.updateBoards
        redirect_to root_path
      else
        render 'pages/loginTrello'
      end
    elsif auth.provider == 'trello'
      oauthTrello(auth)
      redirect_to root_path
    else
      puts "Can not find provider #{auth.provider}"
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

  def ifTreloTokenAvailable?
    token = current_user.trello_token
    res =  sendTrelloGetRequest("tokens/#{token}", token)
    if res.status == 200
      true
    else
      false
    end
  end




end
