# frozen_string: true

##
# Stores the top-level file upload record
class Upload < ApplicationRecord
  UPLOAD_MIME_TYPES = %w[video/mp4 video/webm audio/mpeg].freeze
  DEFAULT_LANGUAGE = "en-NZ".freeze # TODO: Move to config

  has_one_attached :file
  has_one_attached :audio
  has_many :audio_segments, -> { order(:sequence_number) }, dependent: :destroy
  has_one :transcript, dependent: :destroy
  has_one :summary, through: :transcript
  has_many :clips, -> { ordered }, through: :transcript

  validate :validate_file_content_type
  validate :validate_file_attached

  before_validation :default_language, on: :create
  before_validation :default_name, on: :create

  # When the model instance is changed, a message will sent over
  # ActionCable that notifies the page to reload.
  broadcasts_refreshes

  def video?
    file.content_type.start_with?('video/')
  end

  def audio?
    file.content_type.start_with?('audio/')
  end

  def processed?
    processing_ended_at.present?
  end

  def language_iso639_1
    language.split("-").first
  end

  def audio_extractable?
    file.attached? && (video? || audio?)
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  private

  def default_name
    name.presence || (self.name = file.filename.base)
  end

  def default_language
    self.language ||= DEFAULT_LANGUAGE
  end

  def validate_file_attached
    return if file.attached?

    errors.add(:file, :blank)
  end

  def validate_file_content_type
    return if file.attached? && UPLOAD_MIME_TYPES.include?(file.content_type)

    file.purge
    errors.add(:file, :invalid_content_type)
  end
end
