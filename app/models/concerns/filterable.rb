# modified from: http://www.justinweiss.com/blog/2014/02/17/search-and-filter-rails-models-without-bloating-your-controller/
#
# Call scopes directly from your URL params:
#
#     @products = Product.filter(params.permit(:status, :location, :starts_with))
module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    cattr_accessor :filters

    # Call the class methods with the same name as the keys in <tt>filtering_params</tt>
    # with their associated values. Most useful for calling named scopes from
    # URL params. Make sure you don't pass stuff directly from the web without
    # whitelisting only the params you care about first!
    #
    # filtering_params: hash of filter fields to values to filter by
    # prefix: prefix for converting filtering_params keys to available filters
    def filter_scope(filtering_params, prefix: nil)
      results = where(nil) # create an anonymous scope
      return results unless filtering_params

      filtering_params = filtering_params.to_h

      filtering_params = filtering_params.transform_keys { |key| "#{prefix}_#{key}" } if prefix.present?

      allowed_filtering_params = filtering_params.symbolize_keys.slice(*filters)
      allowed_filtering_params.each do |key, value|
        results = results.public_send(key, value)
      end
      results
      binding.pry
    end

    def filter_resource(filtering_params)
      results = self.where(nil) # create an anonymous scope
      return results unless filtering_params
      filtering_params.each do |key, value|
        results = results.public_send("filter_by_#{key}", value) if value.present?
      end
      results
    end

    def available_filters(*filters)
      self.filters ||= []
      self.filters += filters
      self.filters.uniq!
    end

    def normalize_filter_value(value)
      value&.split(",") || value
    end
  end
end
