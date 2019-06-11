# frozen_string_literal: true

class PunditAuthorizer
  include Pundit

  attr_reader :user, :obj

  def initialize(user, obj)
    @user = user
    @obj  = obj
  end

  def authorize_on(query)
    query += '?' unless query.last == '?'
    authorize(obj, query)
  end

  private

  def pundit_user
    user
  end
end
