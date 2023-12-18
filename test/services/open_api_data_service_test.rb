require "test_helper"

class OpenApiDataServiceTest < ActiveSupport::TestCase
  setup do
    @get_open_api_data = GetOpenApiDatumsService.create!()
  end

  test "get_open_api_data 생성" do
    get_open_api_data_id = @get_open_api_data.id
    service = GetOpenApiDatumsService.new(get_open_api_data_id)
    pp service.build_get_open_api_data(get_open_api_data_id).attributes
  end
end
