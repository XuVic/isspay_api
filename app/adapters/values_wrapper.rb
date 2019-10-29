class ValuesWrapper
  class << self
    def to_struct(values)
      struct = Struct.new(*fields(values)) do
        def keys
          self.to_hash.keys
        end

        def stringify_keys
          self.to_hash.stringify_keys
        end

        def to_hash
          self.to_h.tap do |h|
            h.delete(:id)
            h[:created_at] = Time.now unless h[:created_at]
            h[:updated_at] = Time.now
          end
        end
      end
      
      values[1..-1].map do |value|
        struct.new(*value)
      end
    end

    def fields(values)
      values[0].map(&:to_sym)
    end
  end

  attr_reader :records

  def initialize(records)
    @records = records
  end

  def table_name
    records[0].class.table_name.capitalize
  end

  def to_values_with(cols_order)
    records.map do |record|
      cols_order.map do |col|
        record.send(col.to_sym)
      end
    end
  end
end