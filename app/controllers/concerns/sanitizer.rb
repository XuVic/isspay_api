module Sanitizer
  class NotFoundRule < StandardError
  end
  
  extend ActiveSupport::Concern

  class RuleCollection < SimpleDelegator
    def initialize
      super({})
    end

    def sanitize(key, value, action)
      if has_rule?(key.to_sym)
        proc = find_proc(key.to_sym, action.to_sym)
        proc.call(value)
      else
        value
      end
    end

    def clean(key, rules)
      self[key] = get_procs(rules)
    end

    def find_proc(key, action)
      rules = self[key]
      

      rules.has_key?(action) ? rules[:action] : rules[:with]
    end

    def get_procs(rules)
      raise NotFoundRule if rules.empty?

      rules.each do |k, v|
        rules[k] = make_proc(v)
      end
      return rules
    end

    def make_proc(rule)
      return rule if rule.is_a?(Proc)

      return default_proc(rule) if rule.is_a?(String) || rule.is_a?(Symbol) 
    end

    def default_proc(sym)
      -> (val) { val.send(sym.to_sym) }
    end

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
        params[k] = sanitize_rules.sanitize(k, v, action(params))
      end
    end
  end

  def action(params)
    params[:action]
  end

  def sanitize_rules
    self.class.rules
  end

  def hashable?(obj)
    obj.is_a?(Hash) || obj.is_a?(ActionController::Parameters)
  end
end