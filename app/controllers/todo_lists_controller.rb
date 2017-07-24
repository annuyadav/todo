class TodoListsController < ApplicationController
  before_action :authenticate_user!
  before_action :fetch_todo_list, except: [:new, :create]
  before_action :fetch_todo_item, only: [:delete_todo_item, :update_todo_item]

  def new
    @todo_list = TodoList.new
  end

  def create
    @todo_list = current_user.owned_todo_lists.new(todo_list_params)
    if @todo_list.save
      redirect_to @todo_list, notice: 'ToDo list was successfully created.'
    else
      render :edit
    end
  end

  def index
    @todos = params[:state] ? current_user.all_todo_lists(params[:state]) : current_user.all_todo_lists
  end

  def edit
  end

  def show
  end

  def update
    if @todo_list.update(todo_list_params)
      redirect_to @todo_list, notice: 'ToDo list updated.'
    else
      render :edit
    end
  end

  def destroy
    _notice = @todo_list.destroy ? 'ToDo list was successfully destroyed.' : 'Unable to destroy ToDo list'
    redirect_to todo_lists_url, notice: _notice
  end

  def new_user
  end

  def share
    unless @todo_list.add_user(user_params[:email])
      redirect_to @todo_list, notice: 'Unable to share ToDo list' and return
    end
  end

  def sort
    params[:order].each do |key,value|
      _item = @todo_list.todo_items.where(id: value[:id]).first
      _item.update_attribute(:position, value[:position])
    end
    render body: nil
  end

  def destroy_share
    _notice = @todo_list.delete_user(User.where(id: params[:user_id]).first) ? 'User removed successfully.' : 'Unable to remove user.'
    redirect_to @todo_list, notice: _notice
  end

  def new_todo_item
    @todo_item = @todo_list.todo_items.build
  end

  def add_todo_item
    redirect_to @todo_list, notice: @todo_list.todo_items.create(todo_item_params) ? 'List item added.' : 'Unable to add item.'
  end

  def delete_todo_item
    redirect_to @todo_list and return unless @todo_item
  end

  def update_todo_item
    updated = @todo_item.send(params[:event]) if params[:event]
    flash[:notice] = updated ? 'ToDo item updated' : 'Unable to update'
  end

  def update_state
    updated = @todo_list.send(params[:event]) if params[:event]
    flash[:notice] = updated ? 'ToDo list updated' : 'Unable to update'
  end

  private

  def fetch_todo_list
    @todo_list = TodoList.where(id: params[:id]).first
  end

  def fetch_todo_item
    @todo_item = @todo_list.todo_items.where(id: params[:todo_item_id]).first
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def todo_list_params
    params.require(:todo_list).permit(:name, :description)
  end

  def todo_item_params
    params.require(:todo_item).permit(:description)
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
