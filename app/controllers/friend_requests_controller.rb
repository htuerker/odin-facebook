class FriendRequestsController < ApplicationController
  before_action :set_friend_request, only: [:accept, :decline, :destroy]

  def index
    @sent_requests = current_user.friend_requests_sent.pending
    @received_requests = current_user.friend_requests_received.pending
  end

  def create
    @friend_request = FriendRequest.find_or_initialize_by(sender_id: current_user.id,
                                                          receiver_id: params[:friend_request][:receiver_id])
    @friend_request.status = 0
    respond_to do |format|
      if @friend_request.save
        format.html { redirect_back fallback_location: root_path,
                      success: "Friend request sent succesfuly" }
        format.json { render json: @friend_request, status: :created,
                      location: @friend_request }
        format.js
      else
        format.html { redirect_back fallback_location: root_path,
                      danger: "Something went wrong"  }
        format.json { render json: @friend_request.errors,
                      status: :unprocessable_entity }
        format.js
      end
    end
  end

  def accept
    unless FriendRequestPolicy.new(current_user, @friend_request).accept?
      raise Pundit::NotAuthorizedError
    end

    respond_to do |format|
      if @friend_request.update(status: 1)
        @friend_request.sender.establish_friendship(@friend_request.receiver)

        format.html { redirect_back fallback_location: root_path,
                      success: "You have accepted a friendship request!" }
        format.json { render json: @friend_request, status: :updated,
                      location: @friend_request }
        format.js
      else
        format.html { redirect_back fallback_location: root_path,
                      danger: "Something went wrong"  }
        format.json { render json: @friend_request.errors,
                      status: :unprocessable_entity }
        format.js
      end
    end
  end

  def decline
    unless FriendRequestPolicy.new(current_user, @friend_request).accept?
      raise Pundit::NotAuthorizedError
    end
    
    respond_to do |format|
      if @friend_request.update(status: -1)
        format.html { redirect_back fallback_location: root_path,
                      success: "You have declined a friendship request!" }
        format.json { render json: @friend_request, status: :updated,
                      location: @friend_request }
        format.js
      else
        format.html { redirect_back fallback_location: root_path,
                      danger: "Something went wrong"  }
        format.json { render json: @friend_request.errors,
                      status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    unless FriendRequestPolicy.new(current_user, @friend_request).destroy?
      raise Pundit::NotAuthorizedError
    end
    @friend_request.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path,
                    success: "Friend request successfuly canceled" }
      format.json  { head :ok }
      format.js
    end
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:receiver_id)
  end

  def set_friend_request
    @friend_request = FriendRequest.find(params[:id])
  end

  def require_authorized_receiver
    unless @friend_request.receiver == current_user
      flash[:danger] = "You're not authorized"
      redirect_back(fallback_location: root_path)
    end
  end
end
