# frozen_string_literal: true

class NewSectionHookListener < Redmine::Hook::ViewListener
  def view_issues_show_description_bottom(context={})
    @prs = ActiveRecord::Base.connection.exec_query("SELECT * FROM pull_requests WHERE issue_id = (#{context[:issue].id})").to_a
    @deployments = @prs.map do |pr|
      ActiveRecord::Base.connection.exec_query("SELECT * FROM deployments WHERE pull_request_id = (#{pr['id']})").to_a
    end
    @deployments_strings = []
    @deployments.each do |deployment_list|
      formatted_deployment_list = []
      deployment_list.each do |deployment|
        formatted_deployment_list << "<li><a href='#{deployment['url']}' target='_blank'>#{deployment['deploy_branch']}</a></li>"
      end
      @deployments_strings << formatted_deployment_list
    end

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
    content = <<-HTML
      <hr/>
      <p><strong>Pull Requests</strong></p>
      <ul>
        #{@pr_string}
      </ul>
    HTML
    content
  end
end
