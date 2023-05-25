# frozen_string_literal: true

require_relative '../test_helper'

class ExampleControllerTest < ActionDispatch::IntegrationTest
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_index
    get :index
    assert_response :success
  end
end
