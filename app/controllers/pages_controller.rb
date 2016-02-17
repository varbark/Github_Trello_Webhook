class PagesController < ApplicationController
  respond_to :html, :js

  def index
    if current_user
      @user = current_user
      @repos = @user.repos
      @boards = @user.boards
    end
  end

  def boards
    @boards = current_user.boards.where(syn: false)
  end
end
