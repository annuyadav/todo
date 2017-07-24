class User < ApplicationRecord

  # ===== Constants ===============================================
  STAMP_WIDTH = 50
  STAMP_HEIGHT = 50
  THUMBNAIL_WIDTH = 200
  THUMBNAIL_HEIGHT = 200

  # ==== Validations ==============================================
  validates :first_name, :last_name, presence: true, length: 2..72

  # ==== Associations =============================================
  has_many :owned_todo_lists, class_name: 'TodoList', foreign_key: 'owner_id'
  has_and_belongs_to_many :todo_lists, -> { distinct }

  # ==== Devise settings ==========================================
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable, :trackable

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  # ==== Photofy ===================================================
  photofy(:profile_pic)
  after_photofy :profile_pic, :stamp, Proc.new { |img| img.resize_to_fill(STAMP_WIDTH, STAMP_HEIGHT) }

  def default_pic_path
    '/default_user_img.jpg'
  end

  def default_stamp_path
    '/default_stamp_user_img.jpg'
  end

  def profile_image
    profile_pic? ? profile_pic_path.gsub(Rails.root.to_s, '') : default_pic_path
  end

  def stamp_image
    self.stamp ? stamp_path.gsub(Rails.root.to_s, '') : default_stamp_path
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def all_todo_lists(state=nil)
    if state.present?
      owned_todo_lists.where(state: state) + todo_lists.where(state: state)
    else
      owned_todo_lists + todo_lists
    end
  end
end
