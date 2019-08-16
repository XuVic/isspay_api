class TimeDecorator < SimpleDelegator
  DAY = 24 * 60 * 60
  MONTH = 30 * DAY
  YEAR = 12 * MONTH

  def initialize(time)
    @time = if time.is_a?(Integer)
      super(Time.at(time))
    elsif time.is_a?(String)
      super(Time.parse(time))
    else
      super(time)
    end
  end

  def between?(time)
    first_date <= time && time <= last_date
  end

  def first_date
    self.class.new(Date.civil(year, month, 1).to_s)
  end

  def last_date
    self.class.new(Date.civil(year, month, -1).to_s)
  end

  def ago(days)
    self.class.new(@time.to_i - days * DAY)
  end

  private
end