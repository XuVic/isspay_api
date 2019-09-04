module JsonRenderer
  class Renderer

    class NoImplementError < StandardError 
    end

    attr_reader :controller, :result

    delegate :response, to: :controller
    delegate :status, :body, to: :result

    def initialize(controller, result)
      @controller = controller
      @result = result
    end

    def render
      set_response_body(json_payload)
    end

    def json_payload
      {
        status: status,
        type: type,
        data: data
      }.to_json
    end

    def set_response_body(body)
      set_response_header('Content-Type', 'application/json; charset=utf-8')
      
      response.status = status
      response.body = body
    end
  
    def set_response_header(key, value)
      response.set_header(key, value)
    end
  end
end