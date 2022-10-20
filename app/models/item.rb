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

  def self.find_by_name(search_params)
    where('name ILIKE ?', "%#{search_params}%")
      .order(Arel.sql('lower(items.name)'))
      .first
  end

  def self.find_all_by_name(search_params)
    where('name ILIKE ?', "%#{search_params}%")
      .order(Arel.sql('lower(items.name)'))
  end

  def self.find_all_by_price(min_price:, max_price:)
    minimum = min_price_formatted(min_price)
    maximum = max_price_formatted(max_price)
    where('unit_price >= ? and unit_price <= ?', minimum, maximum)
      .order(Arel.sql('lower(items.name)'))
  end

  def self.min_price_formatted(min_price)
    if !min_price
      0
    else
      min_price.to_f
    end
  end

  def self.max_price_formatted(max_price)
    if !max_price
      Float::INFINITY
    else
      max_price.to_f
    end
  end
end
