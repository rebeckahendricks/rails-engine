class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates :name, presence: true

  def self.good_id?(merchant_id)
    merchant_id.nil? || where(id: merchant_id).any?
  end

  def self.search_by_name(search_params)
    where('name ILIKE ?', "%#{search_params}%")
      .order(Arel.sql('lower(name)'))
      .limit(1)
      .first
  end
end
