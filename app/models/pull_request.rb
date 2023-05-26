# frozen_string_literal: true

class PullRequest < GnosisApplicationRecord
  belongs_to :issue
  has_many :deployments, dependent: :destroy

  before_create :set_issue

  private
end
