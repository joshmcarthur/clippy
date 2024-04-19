##
# A clip is a user-initiated selection of a range of text within a transcript.
# It is created by selecting a start and end segment, and is associated with a transcript.
class Clip < ApplicationRecord
  include Ranged

  belongs_to :transcript
  has_one :upload, through: :transcript

  def segments
    @segments ||= transcript.segments.between_time(start_time, end_time).ordered
  end

  def text
    segments.map(&:text).join(" ")
  end
end
