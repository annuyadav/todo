class WelcomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @todos = current_user.all_todo_lists
  end
end
