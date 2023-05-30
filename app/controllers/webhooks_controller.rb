# frozen_string_literal: true

class WebhooksController < ApplicationController
  protect_from_forgery except: %i[github_webhook_catcher semaphore_webhook_catcher]

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
    signature = "sha256=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), ENV.fetch('GITHUB_WEBHOOK_SECRET', 'test'),
                                                  payload_body)}"
    Rack::Utils.secure_compare(signature, recieved_signature)
  end

  def semaphore_webhook_handler(params)
    Rails.logger.debug params
  end
end
