class BaseForm
  include ActiveModel::Validations
  attr_reader :resource, :options

  def initialize(resource, options = {})
    @resource = resource
    @options = options
  end

  def submit
    if valid?
      if context == :update
        resource.update(attributes)
      else
        resource.save!
      end

      return resource if resource.persisted?
    else
      errors
    end
  end

  def target_resource
    if context == :update
      model_name = @resource.model_name.to_s
      model_name.constantize.new(attributes)
    elsif context == :default
      resource 
    end
  end

  def attributes
    options[:attributes]
  end

  def context
    return :default unless options[:context]

    options[:context]
  end
end