require "open3"

class ExtractAudioJob < ApplicationJob
  queue_as :default

  def perform(upload)
    return unless upload.audio_extractable?

    # Download the file to a temp file and process it
    upload.file.open do |temp_file|
      extract_audio(temp_file) do |output|
        # Attach the flac_temp_file to the upload's 'audio' ActiveStorage attachment
        upload.audio.attach(io: File.open(output.path), filename: "#{File.basename(output.path)}.flac")
      end
    end
  end

  private

  def extract_audio(input)
    # Create a temp file for the FLAC file
    flac_temp_file = Tempfile.new([File.basename(input.path), '.flac'])

    # Use ffmpeg to convert the downloaded file to FLAC
    _stdout, stderr, status = Open3.capture3("ffmpeg -i #{input.path} #{flac_temp_file.path}")

    # Raise an exception if the system command failed
    raise "Failed to extract FLAC file: #{stderr}" unless status.success?

    # Yield the output file to the block
    yield flac_temp_file

    # Ensure the FLAC temp file is deleted after use
    flac_temp_file.close
    flac_temp_file.unlink
  end
end
