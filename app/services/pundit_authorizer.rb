# frozen_string_literal: true

class PunditAuthorizer
  include Pundit

  attr_reader :user, :obj

  def initialize(user, obj)
    @user = user
    @obj  = obj
  end

  # The only API
  # query can end with '? optionally
  def authorize_on(query)
    query += '?' unless query.last == '?'
    authorize(obj, query)
  end

  private

  # Override Pundit to refer user to @user, instead of current_user
  def pundit_user
    user
  end
end
