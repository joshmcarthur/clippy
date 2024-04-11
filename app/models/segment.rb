class Segment < ApplicationRecord
  belongs_to :transcript
  has_one :upload, through: :transcript

  def breaks?
    text.ends_with?(".") || text.ends_with?("?")
  end
end
