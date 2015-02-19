module ApplicationHelper
  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible fade in", role: 'alert') do
        concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
          concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
          concat content_tag(:span, 'Close', class: 'sr-only')
        end)
        concat message
      end)
    end
    nil
  end

  def image_for(user, size)
    if user.deleted_at?
      image_tag('deleted_user.png', class: "gravie",  height: size, width: size)
    elsif user.profile_image_id?
      image_tag(attachment_url(user, :profile_image, :fill, size, size), class: "gravie")
    else
      gravatar_tag(user.email, :size => size, :html => { :class => "gravie" })
    end
  end

  def name_for(user)
    if user.deleted_at
      content_tag(:span, 'DELETED USER')
    else
      link_to(user.name, profiles_path(user))
    end
  end
end
