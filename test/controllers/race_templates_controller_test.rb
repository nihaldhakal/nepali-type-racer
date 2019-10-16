require 'test_helper'

class RaceTemplatesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get race_templates_new_url
    assert_response :success
  end

end
