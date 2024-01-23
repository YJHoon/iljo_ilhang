class ApplicationController < ActionController::API
  rescue_from Exceptions::DefaultError do |e|
    render json: { message: e.message }, status: :internal_server_error
  end

  rescue_from Exceptions::ForbiddenError do |e|
    render json: { message: e.message }, status: :forbidden
  end

  rescue_from Exceptions::OpenApiError do |e|
    render json: { message: e.message }, status: :bad_request
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { message: e.message }, status: :bad_request
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { message: e.message }, status: :not_found
  end

  def serializer(object, serializer)
    serializer.new.serialize_to_json(object)
  end

  def each_serializer(objects, serializer, context: {})
    Panko::ArraySerializer.new(objects, each_serializer: serializer, context: context).to_json
  end
end
