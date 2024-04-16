module Ranged
  extend ActiveSupport::Concern

  def range
    start_time..end_time
  end

  class_methods do
    def between_time(start_time, end_time)
      where("start_time >= ? AND end_time <= ?", start_time, end_time)
    end

    def ordered
      order(:start_time)
    end
  end
end
