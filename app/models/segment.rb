class Segment < ApplicationRecord
  belongs_to :transcript
  has_one :upload, through: :transcript
  has_many :clips, foreign_key: :start_segment_id, dependent: :destroy

  def breaks?
    text.ends_with?(".") || text.ends_with?("?")
  end
end
