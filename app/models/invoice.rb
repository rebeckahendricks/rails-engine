class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items, dependent: :destroy
  has_many :transactions

  validates :customer_id, presence: true, numericality: true
  validates :status, presence: true
end

