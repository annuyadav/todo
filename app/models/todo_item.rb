class TodoItem < ApplicationRecord

  # ==== Validations ==============================================
  validates :description, presence: true, length: 2..170

  # ==== Associations =============================================
  belongs_to :todo_list

  # ==== Call back ================================================
  before_destroy :destroy_allowed?

  # ==== Scopes ===================================================
  default_scope { order('position ASC') }

  # ==== State machine ============================================
  state_machine :state, :initial => :open do
    event :assign do
      transition all => :open
    end

    event :complete do
      transition any => :done
    end

    before_transition :done => any, do: :open_authorize?
    after_transition any => :done, do: :update_todo_list
  end

  def open_authorize?
    todo_list.state_name != :done
  end

  def update_todo_list
    _state = todo_list.todo_items.collect { |items| items.state }.uniq
    todo_list.complete if _state.count == 1 and _state.first == 'done'
  end

  def destroy_allowed?
    state != 'done'
  end

end
