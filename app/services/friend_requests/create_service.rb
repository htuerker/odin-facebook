module FriendRequests
  class CreateService < ::BaseService
    def initialize(user, params = { })
      @current_user = user
      @params = params
    end

    def execute
      @friend_request = @current_user.sent_friend_requests.build(@params)
      if @friend_request.save
        success({ resource: @friend_request })
      else
        error({ resource: @friend_request })
      end
    end
  end
end
