class BaseForm
  include ActiveModel::Validations
  include ActiveSupport::Configurable

  attr_reader :resource, :options
  
  class << self
    def in_create(resource, options)
      options.merge!(context: :create)
      new(resource, options)
    end
  
    def in_update(resource, options)
      options.merge!(context: :update)
      new(resource, options)
    end
  end

  def initialize(resource, options)
    @resource = resource
    @options = options
  end

  def submit
    if valid?
      if update?
        resource.update(attributes)
      elsif create?
        resource.save!
      end

      Result.new(status: 201, body: resource) if resource.persisted?
    else
      Result.new(status: 422, body: errors)
    end
  end

  def target_resource
    if update?
      model_name = @resource.model_name.to_s
      model_name.constantize.new(attributes)
    elsif create?
      resource 
    end
  end

  def attributes
    options[:attributes]
  end

  def context
    options[:context]
  end

  def create?
    context == :create
  end

  def update?
    context == :update
  end
end