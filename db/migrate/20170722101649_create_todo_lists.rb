class CreateTodoLists < ActiveRecord::Migration[5.0]
  def change
    create_table :todo_lists do |t|
      t.string :name
      t.text :description
      t.string :state, default: 'open'
      t.integer :owner_id

      t.timestamps null: false
    end
  end
end
