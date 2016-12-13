class Distance < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :startpunkt, presence: true, length: { maximum: 140 }
  validates :zielpunkt, presence: true, length: { maximum: 140 }
end
