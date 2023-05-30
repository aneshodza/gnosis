# frozen_string_literal: true

class Deployment < GnosisApplicationRecord
  belongs_to :pull_request
  has_one :issue, through: :pull_request, source: :issue

  def self.auto_create_or_update(branch, pull_request_id, url, has_passed)
    deploy = Deployment.find_or_initialize_by(deploy_branch: branch, pull_request_id: pull_request_id)
    deploy.update!(url: url, has_passed: has_passed)
  end
end
