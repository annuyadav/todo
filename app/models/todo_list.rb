class TodoList < ApplicationRecord
  # ==== Validations ==============================================
  validates :description, presence: true, length: 2..170

  # ==== Associations =============================================
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_and_belongs_to_many :users, -> { distinct }
  has_many :todo_items, dependent: :destroy

  # ==== Call back ================================================
  before_destroy :destroy_allowed?

  # ==== State machine =============================================
  state_machine :state, :initial => :open do
    event :assign do
      transition all => :open
    end

    event :complete do
      transition any => :done
    end

    before_transition :done => any, do: :stop_state_update
    after_transition :on => :complete, do: :done_all_items
  end

  def stop_state_update
    return false
  end

  def done_all_items
    todo_items.each do |item|
      item.update(state: 'done')
    end
  end

  def add_user(email)
    _user = User.where(email: email).first
    return false unless _user
    return true if users << _user
  end

  def delete_user(user)
    return true if users.delete(user)
    false
  end

  def destroy_allowed?
    state != 'done'
  end
end
