require 'test_helper'

class UserRatingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_ratings_index_url
    assert_response :success
  end

  test "should get new" do
    get user_ratings_new_url
    assert_response :success
  end

  test "should get create" do
    get user_ratings_create_url
    assert_response :success
  end

  test "should get update" do
    get user_ratings_update_url
    assert_response :success
  end

end
