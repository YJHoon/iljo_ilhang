require 'test_helper'

class UsefulServiceTest < ActiveSupport::TestCase
  setup do
    @useful = UsefulService.create!()
  end

  test "useful 생성" do
    useful_id = @useful.id
    service = UsefulService.new(useful_id)
    pp service.build_useful(useful_id).attributes
  end
end
