module Sanitizer
  extend ActiveSupport::Concern

  class RuleCollection < SimpleDelegator
    def initialize
      super({})
    end

    def sanitize(key, value)
      return self[key.to_sym].call(value) if has_rule?(key)
      value
    end

    def clean(key, options)
      rule = options[:with]
      self[key] = make_proc(rule)
    end

    def make_proc(rule)
      return rule if rule.is_a?(Proc)

      return default_proc(rule) if rule.is_a?(String) || rule.is_a?(Symbol) 
    end

    def default_proc(sym)
      -> (val) { val.send(sym.to_sym) }
    end

    private

    def has_rule?(key)
      self.has_key?(key.to_sym)
    end
  end

  module ClassMethods
    def rules
      @@_rules ||= RuleCollection.new
    end

    def sanitizer_rules(&block)
      @@_rules ||= RuleCollection.new
      @@_rules.instance_eval(&block)
    end
  end

  def sanitize(params)
    return unless hashable?(params)

    params.each do |k, v|
      if hashable?(v)
        params[k] = self.sanitize(v)
      else
        params[k] = sanitize_rules.sanitize(k, v)
      end
    end
  end

  private

  def sanitize_rules
    self.class.rules
  end

  def hashable?(obj)
    obj.is_a?(Hash) || obj.is_a?(ActionController::Parameters)
  end
end