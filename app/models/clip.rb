##
# A clip is a user-initiated selection of a range of text within a transcript.
# It is created by selecting a start and end segment, and is associated with a transcript.
class Clip < ApplicationRecord
  belongs_to :transcript
  has_one :upload, through: :transcript

  def self.create_from_segments(start_segment, end_segment)
    # Make sure that segments are in time order, in case they have been selected in reverse
    start_segment, end_segment = [start_segment, end_segment].sort_by { |s| s.range.first }

    Clip.create(
      transcript: start_segment.transcript,
      range: start_segment.range.first..end_segment.range.last
    )
  end
end
