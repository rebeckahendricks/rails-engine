class ItemSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :unit_price

  belongs_to :merchant
end
