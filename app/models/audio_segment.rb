class AudioSegment < ApplicationRecord
  include Ranged

  belongs_to :upload
  has_one_attached :audio
end
