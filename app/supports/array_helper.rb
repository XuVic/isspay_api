module ArrayHelper
  def to_range(array)
    min = array[0] || 0 
    max = array[1] || Float::INFINITY
    min..max
  end
end