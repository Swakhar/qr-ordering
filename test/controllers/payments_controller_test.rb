require "test_helper"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create_intent" do
    get payments_create_intent_url
    assert_response :success
  end

  test "should get webhook" do
    get payments_webhook_url
    assert_response :success
  end
end
