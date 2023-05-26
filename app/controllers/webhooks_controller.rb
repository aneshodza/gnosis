class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def github_webhook
    # Do something with the event
    p params[:pull_request][:head][:ref]
    p "number: #{params[:pull_request][:head][:ref].match(/\/(\d+)-/)[1]}"
    # PullRequest.create!(action: params.body[:action], url: params.body[:pull_requests][:url],
    #                     title: params.body[:pull_requests][:title], source_branch: params.body[:pull_requests][:head][:ref],
    #                     target_branch: params.body[:pull_requests][:base][:ref], was_merged: params.body[:pull_requests][:merged])

    render json: {status: :ok}
  end

  def semaphore_webhook
    # Do something with the event
    render json: {status: :ok}
  end
end
