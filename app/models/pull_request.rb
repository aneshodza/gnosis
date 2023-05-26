class PullRequest < ActiveRecord::Base
  belongs_to :issue
  has_many :deployments
end
