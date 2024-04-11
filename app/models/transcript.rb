##
# This class represents a transcript of a video.
# It has a one-to-many relationship with segments, clips, and a summary.
class Transcript < ApplicationRecord
  belongs_to :upload
  has_many :segments, -> { order(:range) }, dependent: :destroy
  has_many :clips, dependent: :destroy
  has_one :summary, dependent: :destroy
end
