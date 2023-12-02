class ApplicationController < ActionController::API
  def serializer(object, serializer)
    serializer.new.serialize_to_json(object)
  end

  def each_serializer(objects, serializer)
    Panko::ArraySerializer.new(objects, each_serializer: serializer).to_json
  end
end
