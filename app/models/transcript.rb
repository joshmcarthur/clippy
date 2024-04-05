class Transcript < ApplicationRecord
  belongs_to :upload
  has_many :segments, dependent: :destroy
  has_one :summary, dependent: :destroy
end
