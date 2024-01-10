require "test_helper"

class GuidelinesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @guideline_high_impact = guidelines(:one)
    @guideline_low_impact = guidelines(:two)
  end

  test 'should filter guidelines by impact' do
    get :index, params: { impact: ['high'] }
    assert_response :success
    assert_template :index
    assert_includes assigns(:guidelines),  @guideline_high_impact
    refute_includes assigns(:guidelines),  @guideline_low_impact
  end
end
