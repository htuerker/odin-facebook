class LikePolicy < ApplicationPolicy
    attr_reader :user, :like

    def initialize(user, like)
        super
        @user = user
        @like = like
    end

    def destroy?
        @like.present? && @like.persisted? && owner?
    end
    
    private

    def owner? 
        @user && @user == @like.user
    end
end