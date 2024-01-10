require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get test" do
    get :test
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end
end
