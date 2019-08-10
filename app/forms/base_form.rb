class BaseForm
  include ActiveModel::Validations
  attr_reader :resource, :options

  def initialize(resource, options = {})
    @resource = resource
    @options = options
  end

  def submit
    if valid?
      resource.save

      return resource if resource.persisted?
    else
      errors
    end
  end

  def context
    return 'default' unless options[:context]

    options[:context]
  end

  # def context
  #   resource.persisted? ? :save : :update 
  # end
end