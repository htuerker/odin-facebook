class NotificationsController < ApplicationController
  def index
    @notifications = current_user.received_notifications
                                 .paginate(page: params[:notifications_page],
                                           per_page: 10)
  end
end