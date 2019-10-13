module ErrorsHandler
  extend ActiveSupport::Concern

  def unauthorized(e)
    render_json error_response(403, [e.message])
  end

  def forbidden(e)
    render_json error_response(403, [e.message])
  end

  def bad_request(e)
    render_json error_response(400, [e.message])
  end

  def not_found(e)
    render_json error_response(404, [e.message])
  end

  def form_invalid(e)
    render_json error_response(406, e.errors)
  end

  def error_response(status, errors)
    JsonResponse.new(status, errors, type: :error)
  end

  def respond_with_expectation(expectation, status)
    result = Result.new(status: status, body: expectation.message)
    respond_with result
  end
end