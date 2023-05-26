# frozen_string_literal: true

class Deployment < ApplicationRecord
  belongs_to :pull_request
  has_one :issue, through: :pull_request, source: :issue
end
