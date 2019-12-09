class NotificationsController < ApplicationController
  def index
    @notifications = current_user.received_notifications
                                 .without_friend_requests
                                 .paginate(page: params[:notifications_page],
                                           per_page: 10)
    @notifications.not_seen.update_all(read_status: true)
  end
end