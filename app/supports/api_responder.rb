
class ApiResponder

  attr_reader :controller, :result

  RENDERERKLASS = {
    resource: JsonRenderer::ResourceRenderer,
    error: JsonRenderer::ErrorRenderer,
    message: JsonRenderer::MessageRenderer
  }

  def initialize(controller, result)
    @controller = controller
    @result = result
  end

  def renderer
    RENDERERKLASS[context]
  end

  def call
    renderer.new(controller, result).render
  end

  def context
    if result.success?
      return :resource if is_resource?
      
      :message
    else
      :error
    end
  end

  private

  def is_resource?
    result.body.is_a?(ActiveRecord::Base) || result.body[0].is_a?(ActiveRecord::Base)
  end
end