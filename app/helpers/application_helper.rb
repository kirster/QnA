module ApplicationHelper
  def flash_messages
    flash.map do |type, message|
      content_tag :div, message.html_safe, class: "#{type}" 
    end.join.html_safe
  end
end
