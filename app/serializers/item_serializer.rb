class ItemSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :unit_price, :merchant_id

  def self.negative_price
    {
      "error": {}
    }
  end
end
