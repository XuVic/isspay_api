module JsonRenderer
  class MessageRenderer< Renderer
    private

    def data
      body
    end

    def type
      'message'
    end

  end
end