class BaseService
  private

  def success(response = { })
    response[:status] = :success
    response
  end

  def error(response = { })
    response[:status] = :error
    response
  end
end
