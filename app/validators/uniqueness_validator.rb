class UniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    find_model(record)
    relation = build_relation(attribute, value)

    record.errors.add(attribute, :taken, message: "(#{value}) has already been taken") if relation.exists?
  end

  private

  def find_model(record)
    @model ||= record.resource.model_name.to_s.constantize
  end

  def build_relation(key, value)
    @model.where({key.to_s => value})
  end
end