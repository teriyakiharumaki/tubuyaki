class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  validates :body, presence: true, length: { maximum: 280 }

  def liked_by?(user)
    return false unless user
    likes.exists?(user_id: user.id)
  end
end
