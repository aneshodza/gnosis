# frozen_string_literal: true

require_relative '../test_helper'

class WebhookCatchControllerControllerTest < ActionController::TestCase
  def setup
    @controller = WebhooksController.new
    @github_webhook_hash = {
      pull_request: {
        state: 'closed',
        html_url: 'https://github.com/aneshodza/test-repo/pull/17',
        title: 'Create something',
        head: {
          ref: 'feature/1-some-feature'
        },
        base: {
          ref: 'main'
        },
        merged: true,
        merge_commit_sha: '19a89f0050eacf201ccd058d5e28cddf2b035bfc'
      }
    }
  end

  def test_create_pull_request
    assert_difference('PullRequest.count', 1) do
      @request.headers['X-Hub-Signature-256'] =
        'sha256=a61084e5bafb012607e8b4ea9f37260774bf1f00617861f2ae7aef73888234f7'
      post :github_webhook_catcher, params: @github_webhook_hash, as: :json
    end

    new_pr = PullRequest.last
    assert_equal 'merged', new_pr.state
    assert_equal 1, new_pr.issue_id
  end

  def test_create_pull_request_no_issue
    @github_webhook_hash[:pull_request][:head][:ref] = 'feature/420-some-feature-no-issue'
    @request.headers['X-Hub-Signature-256'] = 'sha256=b15df5baab94e31571b043e810545ec49075dedb0dd7aa78b8f185501248c918'
    assert_difference('PullRequest.count', 0) do
      post :github_webhook_catcher, params: @github_webhook_hash, as: :json
    end
  end

  def test_with_invalid_sha
    @request.headers['X-Hub-Signature-256'] = 'sha256=invalid'
    assert_difference('PullRequest.count', 0) do
      post :github_webhook_catcher, params: @github_webhook_hash, as: :json
    end
    assert @response.status == 403
  end
end
