class Service

  class NoImplementError < StandardError; end
  class ServiceHalt < StandardError; end
  class ServiceError < StandardError
    def initialize(msg)
      super(msg)
    end
  end

  attr_reader :user, :data

  def initialize(user: nil, data: {}, params: )
    @user = user
    @data = data.merge({params: params})
  end

  def call!
    raise NoImplementError
  end

  def params
    data[:params]
  end

  def sql_transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end
end