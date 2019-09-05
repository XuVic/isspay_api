module ErrorsHandler
  extend ActiveSupport::Concern

  def unauthorized(expectation)
    respond_with_expectation(expectation, 401)
  end

  def forbidden(expectation)
    respond_with_expectation(expectation, 403)
  end

  def bad_request(expectation)
    respond_with_expectation(expectation, 400)
  end

  def not_found(expectation)
    respond_with_expectation(expectation, 404)
  end

  def respond_with_expectation(expectation, status)
    result = Result.new(status: status, body: expectation.message)
    respond_with result
  end
end