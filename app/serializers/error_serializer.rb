class ErrorSerializer
  include JSONAPI::Serializer

  def self.name_and_price_error
    {
      "message": 'Your query could not be completed',
      "error": 'Name and price cannot exist together'
    }
  end

  def self.negative_number_error
    {
      "message": 'Your query could not be completed',
      "error": 'Price cannot be negative'
    }
  end

  def self.no_search_results
    {
      "data": {}
    }
  end

  def self.no_search_input_error
    {
      "message": 'Your query could not be completed',
      "error": 'Search input cannot be empty'
    }
  end

  def self.min_max_price_error
    {
      "message": 'Your query could not be completed',
      "error": 'Minimum price must be less than maximum price'
    }
  end
end
