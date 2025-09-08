require "test_helper"

class KitchenControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get kitchen_index_url
    assert_response :success
  end
end
