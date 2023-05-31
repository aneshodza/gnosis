# frozen_string_literal: true

class NewSectionHookListener < Redmine::Hook::ViewListener
  def view_issues_show_description_bottom(context={})
    p "some extra context:"
    @prs = ActiveRecord::Base.connection.exec_query("SELECT * FROM pull_requests WHERE issue_id = (#{context[:issue].id})").to_a
    @pr_string = @prs.map do |pr|
      "<li><a href='#{pr['url']}'>#{pr['title']}</a></li>"
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
