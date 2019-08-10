class Api::V1::BaseController < ApplicationController
  private

  def build_resource(params)
    model = find_model
    model.new(params)
  end

  def find_model
    self.controller_name.classify.constantize
  end

  def error?(obj)
    obj.is_a?(ActiveModel::Errors)
  end

  def resource?(obj)
    if obj.respond_to?(:each)
      obj[0].is_a?(ActiveRecord::Base)
    else
      obj.is_a?(ActiveRecord::Base)
    end
  end

  def token
    standard, token = request.get_header('Authorization').split(' ')

    standard == 'Bearer' ? token : nil
  end
end
