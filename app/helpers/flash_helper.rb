module FlashHelper
  def display_flash
    flash_messages = []
    flash.each do |type, message|
      text = content_tag(:div, message, class: type)
      flash_messages << text if message
    end
    flash_messages.join("\n").html_safe
  end
end
