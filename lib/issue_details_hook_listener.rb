# frozen_string_literal: true

class NewSectionHookListener < Redmine::Hook::ViewListener
  def view_issues_show_description_bottom(context={})
    p "some extra context:"
    @prs = ActiveRecord::Base.connection.exec_query("SELECT * FROM pull_requests WHERE issue_id = (#{context[:issue].id})").to_a
    @deployments = @prs.map do |pr|
      ActiveRecord::Base.connection.exec_query("SELECT * FROM deployments WHERE pull_request_id = (#{pr['id']})").to_a
    end
    @deployments
    @deployments_strings = @deployments.each_with_index.map do |deployment_list, index|
      p deployment_list[0]
      p deployment_list[0]['url']
      deployment_list.each_with_index.map do |deployment, index|
        <<-ListObject
          <li>
            <a href='#{deployment['url']}' target='_blank'>#{deployment['deploy_branch']}</a>
          </li>
        ListObject
      end
    end

    p @deployments_strings

    @pr_string = @prs.each_with_index.map do |pr, index|
      <<-ListObject
      <li>
        <a href='#{pr['url']}' target='_blank'>#{pr['title']}</a>
        <ul>
          #{@deployments_strings[index]}
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
