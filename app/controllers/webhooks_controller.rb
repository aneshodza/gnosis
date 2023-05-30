# frozen_string_literal: true

class WebhooksController < ApplicationController
  protect_from_forgery except: %i[github_webhook_catcher semaphore_webhook_catcher]

  def github_webhook_catcher
    github_webhook_handler(params)

    render json: {status: :ok}
  end

  def semaphore_webhook_catcher
    semaphore_webhook_handler(params)

    render json: {status: :ok}
  end

  private

  def github_webhook_handler(params)
    numbers = params[:pull_request][:head][:ref].match(%r{/(\d+)}) || []

    return unless numbers.length.positive? && Issue.exists?(id: numbers[1])

    PullRequest.auto_create_or_update(params.merge(issue_id: numbers[1]))
  end

  def semaphore_webhook_handler(params)
    range = params[:revision][:branch][:commit_range]
    branch = params[:revision][:branch][:name]
    repo = params[:repository][:slug]
    passed = params[:pipeline][:result] == 'passed'

    first_sha = range.split('...').first
    last_sha = range.split('...').last

    sha_between = fetch_commit_history(repo, branch, first_sha, last_sha)
    create_deploys_for_pull_requests(sha_between, branch, passed)
  end

  def fetch_commit_history(repo, branch, first_commit, last_commit)
    Octokit.configure do |config|
      config.access_token = ENV.fetch('GITHUB_ACCESS_TOKEN', nil)
    end
    client = Octokit::Client.new
    commit_sha_list = client.commits(repo, branch).pluck(:sha)

    first_commit_index = commit_sha_list.index(first_commit)
    last_commit_index = commit_sha_list.index(last_commit)

    commit_sha_list[last_commit_index..first_commit_index]
  end

  def create_deploys_for_pull_requests(sha_between, branch, passed)
    sha_between.each do |sha|
      pr = PullRequest.find_by(merge_commit_sha: sha)
      next unless pr

      pr.deployments.create(deploy_branch: branch, url: url, has_passed: passed)
    end
  end

  def url
    "https://#{params[:organization][:name]}.semaphoreci.com/workflows/#{params[:workflow][:id]}/"
  end
end
