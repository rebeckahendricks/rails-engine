class Merchant < ApplicationRecord
  has_many :items

  validates :name, presence: true

  def self.good_id?(merchant_id)
    merchant_id.nil? || where(id: merchant_id).any?
  end
end
