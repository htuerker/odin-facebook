# frozen_string_literal: true

module Notifications
  class CreateService
    def self.call(subject)
      case subject
      when Comment
        notify_all subject, subject.user.id, comment_recipient_ids(subject)
      when FriendRequest
        notify subject, subject.sender.id, subject.receiver.id
      when Like
        notify subject, subject.user.id, subject.post.user.id
      else
        raise 'Unsupported notification source!'
      end
    end

    class << self
      def notify_all(subject, actor_id, recipient_ids)
        recipient_ids.each do |recipient_id|
          notify(subject, actor_id, recipient_id)
        end
      end

      def notify(subject, actor_id, recipient_id)
        Notification.create!(subject: subject,
                             actor_id: actor_id,
                             recipient_id: recipient_id)
      end

      def comment_recipient_ids(comment)
        recipients = ([comment.post.user.id] + comment.post.comments.pluck(:user_id))
        recipients.reject { |id| id == comment.user.id }.uniq
      end
    end
  end
end
