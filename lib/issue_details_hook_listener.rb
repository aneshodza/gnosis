# frozen_string_literal: true

class NewSectionHookListener < Redmine::Hook::ViewListener
  def view_issues_show_description_bottom(_context={})
    content = <<-HTML
      <hr/>
      <p><strong>Content added by hook</strong></p>
      <span id='here'></span>
      <script>document.getElementById('here').innerHTML = 'This was added with js';</script>
    HTML
    content
  end
end
