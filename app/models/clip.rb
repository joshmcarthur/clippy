##
# A clip is a user-initiated selection of a range of text within a transcript.
# It is created by selecting a start and end segment, and is associated with a transcript.
class Clip < ApplicationRecord
  belongs_to :transcript
  has_one :upload, through: :transcript

  def segments
    @segments ||= transcript.segments.where("range && numrange(?, ?)", range.first, range.last).order(:range)
  end

  def text
    segments.map(&:text).join(" ")
  end
end
