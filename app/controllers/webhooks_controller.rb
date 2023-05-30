# frozen_string_literal: true

class WebhooksController < ApplicationController
  protect_from_forgery except: %i[github_webhook_catcher semaphore_webhook_catcher]

  # To use this function, you would do something like:
  fetch_commit_history('owner/repo', 'branch')

  def github_webhook_catcher
    p_body = request.body.read

    unless verify_signature(p_body, request.env['HTTP_X_HUB_SIGNATURE_256'])
      return render json: {status: 403}, status: :forbidden
    end

    github_webhook_handler(params)

    render json: {status: :ok}
  end

  def semaphore_webhook_catcher
    semaphore_webhook_handler(params)

    render json: {status: :ok}
  end

  private

  def github_webhook_handler(params)
    numbers = params[:pull_request][:head][:ref].match(%r{/(\d+)})

    return unless numbers.length.positive? && Issue.exists?(id: numbers[1])

    PullRequest.auto_create_or_update(params.merge(issue_id: numbers[1]))
  end

  def verify_signature(payload_body, recieved_signature)
    signature = "sha256=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'),
                                                  ENV.fetch('GITHUB_WEBHOOK_SECRET', nil), payload_body)}"
    Rack::Utils.secure_compare(signature, recieved_signature)
  end

  def semaphore_webhook_handler(params)
    Rails.logger.debug params
  end

  def fetch_commit_history(repo, branch)
    Octokit.configure do |config|
      config.access_token = ENV.fetch('GITHUB_ACCESS_TOKEN', nil)
    end
    client = Octokit::Client.new
    client.commits(repo, branch)
  end
end
