class PagesController < ApplicationController
  respond_to :html, :js

  def index
    if current_user
      @repos = current_user.repos
    end
  end

  def boards
    @boards = current_user.findAvailableBoards
    @repo_id = params['repo_id']
  end
end
