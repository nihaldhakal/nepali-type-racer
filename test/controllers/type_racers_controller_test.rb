require 'test_helper'

class TypeRacersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get type_racers_index_url
    assert_response :success
  end

  test "should get new" do
    get type_racers_new_url
    assert_response :success
  end

end
