class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :reposts, dependent: :destroy

  validates :body, presence: true, length: { maximum: 280 }

  def liked_by?(user)
    return false unless user
    likes.exists?(user_id: user.id)
  end

  def reposted_by?(user)
    return false unless user
    reposts.exists?(user_id: user.id)
  end
end
