class Clip < ApplicationRecord
  belongs_to :start_segment, class_name: :Segment
  belongs_to :end_segment, class_name: :Segment
  has_one :upload, through: :start_segment
end
