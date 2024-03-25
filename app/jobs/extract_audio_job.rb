require "open3"

class ExtractAudioJob < ApplicationJob
  queue_as :default

  def perform(upload)
    # Download the file to a temp file and process it
    upload.file.open do |temp_file|
      # Create a temp file for the FLAC file
      flac_temp_file = Tempfile.new([File.basename(temp_file.path), '.flac'])

      # Use ffmpeg to convert the downloaded file to FLAC
      _stdout, stderr, status = Open3.capture3("ffmpeg -i #{temp_file.path} #{flac_temp_file.path}")

      # Raise an exception if the system command failed
      raise "Failed to extract FLAC file: #{stderr}" unless status.success?

      # Attach the flac_temp_file to the upload's 'audio' ActiveStorage attachment
      upload.audio.attach(io: File.open(flac_temp_file.path), filename: "#{File.basename(temp_file.path)}.flac")

      # Ensure the FLAC temp file is deleted after use
      flac_temp_file.close
      flac_temp_file.unlink
    end
  end
end
