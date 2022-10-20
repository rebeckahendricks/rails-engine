class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true
  validates :merchant_id, presence: true, numericality: true

  def destroy_invoice_items
    invoice_items.each do |invoice_item|
      invoice_item.destroy
    end
  end

  def self.search_by_name(search_params)
    where('name ILIKE ?', "%#{search_params}%")
      .order(:name)
  end

  def self.search_by_price(min_price = 0, max_price = Float::INFINITY)
    where('unit_price >= ? and unit_price <= ?', min_price, max_price)
      .order(:name)
  end
end
