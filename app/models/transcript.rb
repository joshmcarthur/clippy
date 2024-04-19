##
# This class represents a transcript of a video.
# It has a one-to-many relationship with segments, clips, and a summary.
class Transcript < ApplicationRecord
  include Litesearch::Model
  belongs_to :upload
  has_many :segments, -> { ordered }, dependent: :destroy
  has_many :clips, dependent: :destroy
  has_one :summary, dependent: :destroy

  litesearch do |schema|
    schema.fields %i[text]
    schema.tokenizer :porter
  end
end
