# frozen_string_literal: true

class NewSectionHookListener < Redmine::Hook::ViewListener
  def view_issues_show_description_bottom(context={})
    @context = context
    setup
    content = <<-HTML
      <hr/>
      <p><strong>Pull Requests</strong></p>
      <ul>
        #{@pr_string}
      </ul>
    HTML
    content
  end

  private

  def setup
    get_prs
    get_deployments
    set_deployment_strings
    set_pr_string
  end

  def get_prs
    @prs = ActiveRecord::Base.connection.exec_query("SELECT * FROM pull_requests WHERE issue_id = (#{@context[:issue].id})").to_a
  end

  def get_deployments
    @deployments = @prs.map do |pr|
      ActiveRecord::Base.connection.exec_query("SELECT * FROM deployments WHERE pull_request_id = (#{pr['id']})").to_a
    end
  end

  def set_deployment_strings
    @deployments_strings = []
    @deployments.each do |deployment_list|
      formatted_deployment_list = []
      deployment_list.each do |deployment|
        formatted_deployment_list << "<li><a href='#{deployment['url']}' target='_blank'>#{deployment['deploy_branch']}</a></li>"
      end
      @deployments_strings << formatted_deployment_list
    end
  end

  def set_pr_string
    @pr_string = @prs.each_with_index.map do |pr, index|
      formatted_deployments_list = @deployments_strings[index].join
      <<-ListObject
      <li>
        <a href='#{pr['url']}' target='_blank'>#{pr['title']}</a>
        <ul>
          #{formatted_deployments_list}
        </ul>  
      </li>
      ListObject
    end.join
  end
end
