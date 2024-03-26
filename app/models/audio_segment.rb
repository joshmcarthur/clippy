class AudioSegment < ApplicationRecord
  belongs_to :upload
  has_one_attached :audio
end
