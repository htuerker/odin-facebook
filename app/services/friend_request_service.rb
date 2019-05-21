# frozen_string_literal: true

class FriendRequestService
  def initialize(friend_request, params = nil, user = nil)
    @friend_request = friend_request
    @params = params
    @user = user
  end

  def self.update(friend_request, params, user)
    new(friend_request, params, user).update
  end

  def self.create(friend_request, params)
    new(friend_request, params).create
  end

  def create
    @friend_request.status = FriendRequest.statuses[:pending]
    if @friend_request.save
    else
      false
    end
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
    when FriendRequest.statuses[:cancelled]
      authorizer.authorize_on 'cancel'
      cancel
    end
  end

  def accept
    if @friend_request.update(@params)
      friendship = Friendship.new(user1: @friend_request.sender, user2: @friend_request.receiver)
      friendship.establish_friendship
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

  def cancel
    if @friend_request.update(@params)
    else
      false
    end
  end
end
