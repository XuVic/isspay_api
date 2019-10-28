class Form
  include ActiveModel::Validations

  attr_reader :resource, :options
  

  class InputInvalid < StandardError
    attr_reader :errors, :error_msgs
    def initialize(errors)
      @errors = errors
      @error_msgs = errors.full_messages.uniq
      super('Submit data is invalid.')
    end
  end

  class << self
    def in_create(resource, options = {})
      options.merge!(context: :create)
      new(resource, options)
    end
  
    def in_update(resource, options = {})
      options.merge!(context: :update)
      resource.assign_attributes(options[:attributes])
      new(resource, options)
    end
  end

  def initialize(resource, options)
    @resource = resource
    @options = options
  end

  def submit!
    raise InputInvalid.new(errors) unless valid?

    resource if resource.save!
  end

  def target_resource
    resource
  end

  def attributes
    options[:attributes]
  end
end