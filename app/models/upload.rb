# frozen_string: true

##
# Stores the top-level file upload record
class Upload < ApplicationRecord
  UPLOAD_MIME_TYPES = %w[video/mp4 video/webm audio/mpeg].freeze

  has_one_attached :file
  has_one_attached :audio

  validate :validate_file_content_type
  validate :validate_file_attached

  def video?
    file.content_type.start_with?('video/')
  end

  def audio?
    file.content_type.start_with?('audio/')
  end

  private

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
