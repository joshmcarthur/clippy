class Transcript < ApplicationRecord
  belongs_to :upload
  has_many :segments, -> { order(:range) }, dependent: :destroy
  has_many :clips, through: :segments
  has_one :summary, dependent: :destroy
end
