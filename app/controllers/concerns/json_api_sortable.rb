module JsonApiSortable
  extend ActiveSupport::Concern

  included do
    extend JsonApiParseable

    cattr_accessor :valid_sort_fields, instance_writer: false
    cattr_accessor :sort_field_hash, instance_writer: false
  end

  class_methods do
    def available_sort_fields(*sorts)
      binding.pry
      self.valid_sort_fields ||= []
      self.valid_sort_fields.concat(Array.wrap(sorts).map { |s| unjsonapi(s).downcase })
      self.valid_sort_fields.uniq!
    end

    def alias_sort_fields(sort_field_hash = {})
      self.sort_field_hash = HashWithIndifferentAccess.new(sort_field_hash)
    end
  end

  def sortify(scope)
    binding.pry
    if sort_joins.present?
      table_name = infer_sort_model_parent(scope, sort_joins).association_table_alias(sort_joins.last, :sort)

      scope.left_joins_on(sort_joins, scope: :sort).order("#{table_name}.#{sort_query_string}", default_sort)
    else
      scope.order(sort_query, default_sort)
    end
  end

  def sort_from_params
    @_sort ||= params[:sort]
  end

  def sort_request
    @_sort_request ||= ensure_valid_sort_request
  end

  def sort_direction
    @_sort_direction ||= sort_from_params&.start_with?("-") ? :desc : :asc
  end

  def aliased_field_name(name)
    sort_field_hash && sort_field_hash[name] ? sort_field_hash[name] : name
  end

  def sort_query
    @_sort_query ||= sort_request.present? ? {aliased_field_name(sort_field_parts[:field]) => sort_direction} : default_sort
  end

  def sort_query_string
    if sort_query.is_a?(Symbol)
      sort_query.to_s
    else
      field, direction = sort_query.to_a.flatten

      "#{field} #{direction}"
    end
  end

  def sort_joins
    @_sort_joins ||= sort_field_parts[:scope]
  end

  def default_sort
    :id
  end

  def sort_by_name(scope, association)
    sort_request.present? ? sort_queryable = sort_query : sort_queryable = {"name"=>:asc}
    association == "users" ?
      scope.left_joins_on(:identity).order(Arel.sql(" 
        CASE 
          when type = 'TokenUser' Then users.name 
          else identities.name 
        END #{sort_queryable.values.first.to_s}"), default_sort) :
      scope.order(sort_queryable, default_sort) 
  end

  private

  def ensure_valid_sort_request
    return if sort_from_params.blank?

    potential_sort_field = sort_from_params.gsub(/-/, "").underscore.downcase

    return if valid_sort_fields.exclude?(potential_sort_field)

    potential_sort_field
  end

  def sort_field_parts
    return {scope: nil, field: sort_request} if sort_request.blank? || sort_request.to_s.exclude?(".")

    request_parts = sort_request.to_s.split(".")

    {scope: request_parts.take(request_parts.size - 1), field: request_parts.last}
  end

  def infer_sort_model_parent(scope, join_array)
    # walk the associations to name the parent of the last model
    join_array.take(join_array.length - 1).reduce(scope.model) do |memo, sort_join|
      memo.infer_association_class(sort_join)
    end
  end
end