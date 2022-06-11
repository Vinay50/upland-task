module JsonApiFilterable
  extend ActiveSupport::Concern

  included do
    include JsonApiParseable
  end

  def filters
    @_filters ||= unjsonapi_keys(filter_params[:filter])
  end

  def filter_params
    params.permit(filter: {})
  end
end
