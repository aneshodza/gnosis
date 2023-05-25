require_relative '../test_helper'

class ExampleControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_index
    get :index
    assert_response :success
  end
end
