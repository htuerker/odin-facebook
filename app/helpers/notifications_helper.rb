module NotificationsHelper
  def notification_text_for(notification)
    case notification.subject_type
    when 'Comment'
      'commented on a post'
    when 'Like'
      'liked your post'
    else
      raise 'Unsupported notification source!'
    end
  end
end
