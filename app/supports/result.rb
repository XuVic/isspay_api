class Result
  attr_reader :status, :body

  def initialize(status: , body: )
    @status = status
    @body = body
  end

  def success? 
    @status < 400 
  end
    
  def failure?
    @status >= 400
  end
end