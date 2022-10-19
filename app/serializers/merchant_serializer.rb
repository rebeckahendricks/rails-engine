class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  def self.no_search_results
    {
      "data": {}
    }
  end
end
