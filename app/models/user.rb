class User < ApplicationRecord
  has_secure_password
  validates :name,  presence: true
  validates :email, presence: true, uniqueness: true
  validates :bio, length: { maximum: 500 }, allow_blank: true
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
end
