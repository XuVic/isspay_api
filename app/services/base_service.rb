class BaseService

  class NoImplementError < StandardError; end

  def initialize(user)
    @user = user
  end

  def call
    raise NoImplementError
  end

  def sql_transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end
end