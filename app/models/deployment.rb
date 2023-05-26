class Deployment < ActiveRecord::Base
  belongs_to :pull_request
  has_one :issue, through: :pull_request
end
