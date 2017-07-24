class CreateTodoListsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :todo_lists_users, id: false do |t|
      t.belongs_to :todo_list, index: true
      t.belongs_to :user, index: true
    end
  end
end