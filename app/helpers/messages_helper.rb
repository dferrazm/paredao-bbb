module MessagesHelper
  def render_messages
    messages = ''
    flash.each { |type, message| messages << content_tag(:p, message.html_safe, class: "info-message #{type}") if [:success, :info, :error].include? type }
    messages.html_safe
  end

  def recapctha_messages
    content_tag(:p, flash[:recaptcha_error], class: 'info-message error') if flash[:recaptcha_error]
  end
end
