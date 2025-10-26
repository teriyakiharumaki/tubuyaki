class Repost < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: :reposts_count
  validates :user_id, uniqueness: { scope: :post_id }
end
