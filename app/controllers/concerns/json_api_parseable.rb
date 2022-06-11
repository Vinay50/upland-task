module JsonApiParseable
  extend ActiveSupport::Concern

  def unjsonapi(str)
    str.to_s.underscore
  end

  def unjsonapi_keys(options)
    options&.transform_keys { |key| unjsonapi(key) }
  end

  def params_relationship_id(relationship_name)
    params.dig("data", "relationships", relationship_name, "data", "id")
  end

  def params_relationship_ids(relationship_name)
    relationships = Array.wrap(params.dig("data", "relationships", relationship_name))

    relationships.map { |p| p.dig("data", "id") }
  end
end
