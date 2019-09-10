class BaseService

  class NoImplementError < StandardError; end
  class ServiceHalt < StandardError; end

  attr_reader :user, :data

  def initialize(user = nil, data = {})
    @user = user
    @data = data
  end

  def call
    raise NoImplementError unless @result
  
    @result
  end

  def sql_transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end
end