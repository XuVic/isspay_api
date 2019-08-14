class Hash
  def same_key_structure?(other)
    outer = other.is_a?(Hash) && self.keys.map(&:to_sym).sort == other.keys.map(&:to_sym).sort

    return outer unless outer

    inner = self.keys.map do |k|
      if self[k].is_a?(Hash)
        self[k].same_key_structure?(other[k]) 
      elsif self[k].is_a?(Array) && other[k].is_a?(Array)
        if self[k].size == other[k].size
          self[k].each_with_index.map do |_, i|
            self[k][i].same_key_structure?(other[k][i]) if self[k][i].is_a?(Hash) 
          end.all?
        else
          false
        end
      elsif other[k].is_a?(Hash) || other[k].is_a?(Array)
        false
      else
        true
      end
    end.reject(&:nil?)

    return inner.all?
  end

  def self.symbolize(obj)
    return obj.inject({}){|memo,(k,v)| memo[k.to_sym] =  symbolize(v); memo} if obj.is_a? Hash
    return obj.inject([]){|memo,v    | memo           << symbolize(v); memo} if obj.is_a? Array
    return obj
  end
end

Dir.glob("#{File.dirname(__FILE__)}/*.rb").each do |file|
  require file
end