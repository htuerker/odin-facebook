class FriendRequestService
  def initialize(friend_request, params = nil, user = nil)
    @friend_request = friend_request
    @params = params
    @user = user
  end

  def self.update(friend_request, params, user)
    self.new(friend_request, params, user).update
  end

  def self.create(friend_request)
    self.new(friend_request).create
  end

  def create
  end

  def update
    authorizer = PunditAuthorizer.new(@user, @friend_request)
    case @params[:status]
    when FriendRequest.statuses[:accepted]
      authorizer.authorize_on 'accept'
      accept
    when FriendRequest.statuses[:declined]
      authorizer.authorize_on 'decline'
      decline
    end
  end

  def accept
    if @friend_request.update(@params)
      @friend_request.sender.establish_friendship(@friend_request.receiver)
    else
      false
    end
  end

  def decline
    if @friend_request.update(@params)
    else
      false
    end
  end
end
