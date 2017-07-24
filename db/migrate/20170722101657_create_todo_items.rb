class CreateTodoItems < ActiveRecord::Migration[5.0]
  def change
    create_table :todo_items do |t|
      t.text :description
      t.string :state, default: 'open'
      t.integer :position
      t.integer :todo_list_id

      t.timestamps null: false
    end
  end
end
