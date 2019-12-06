class Notifications::CreateService
  def self.call(subject)
    case subject
    when Comment
      notify_all subject, subject.user.id, subject.notifier_ids
    when FriendRequest
      notify subject, subject.sender.id, subject.receiver.id
    else
      raise 'Unsupported notification source!!'
    end
  end

  class << self
    def notify_all(subject, actor_id, notifier_ids)
      notifier_ids.each { |notifier_id| notify(subject, actor_id, notifier_id) }
    end

    def notify(subject, actor_id, notifier_id)
      Notification.create!(subject: subject,
                           actor_id: actor_id,
                           notifier_id: notifier_id)
    end
  end
end
