class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  validates :item_id, presence: true, numericality: true
  validates :invoice_id, presence: true, numericality: true
  validates :quantity, presence: true, numericality: true
  validates :unit_price, presence: true, numericality: true

  before_destroy :find_invoice
  after_destroy :destroy_orphaned_invoice

  def find_invoice
    @invoice = self.invoice
  end

  def destroy_orphaned_invoice
    if @invoice.invoice_items.length == 0
      @invoice.destroy
    end
  end
end
