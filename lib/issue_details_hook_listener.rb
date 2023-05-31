class NewSectionHookListener < Redmine::Hook::ViewListener
  def view_issues_show_description_bottom(context={})
    content = "<hr/>"
    content << "<p><strong>Content added by hook</strong></p>"
    content << "<span id='here'></span>"
    content << "<script>document.getElementById('here').innerHTML = 'This was added with js';</script>"
    content.html_safe
  end
end
