# frozen_string_literal: true

require_relative '../test_helper'

class DeploymentTest < ActiveSupport::TestCase
  def test_belongs_to_pull_request
    FactoryBot.create(:deployment)
    assert_equal 1, PullRequest.where(id: Deployment.first.pull_request_id).count
  end
end
