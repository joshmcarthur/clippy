class Segment < ApplicationRecord
  belongs_to :transcript
  has_one :upload, through: :transcript
  has_many :clips
end
