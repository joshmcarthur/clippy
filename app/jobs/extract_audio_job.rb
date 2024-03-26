require "open3"

class ExtractAudioJob < ApplicationJob
  queue_as :default
  SEGMENT_SIZE = 10.minutes.to_i

  def perform(upload)
    return unless upload.audio_extractable?

    # Ensure we reset segments
    upload.audio_segments.destroy_all

    # Download the file to a temp file and process it
    upload.file.open do |temp_file|
      extract_audio(temp_file) do |output|
        attach_audio(upload, output.pop)
        attach_segments(upload, output)
      end
    end
  end

  private

  def attach_audio(upload, audio)
    upload.audio.attach(io: File.open(audio), filename: File.basename(audio))
  end

  def attach_segments(upload, segments)
    total_duration = 0
    segments.each_with_index do |segment, index|
      segment = upload.audio_segments.create!(sequence_number: index, audio: File.open(segment))
      segment.audio.analyze
      duration = segment.audio.metadata[:duration]

      segment.update!(
        duration: duration,
        time: total_duration..(total_duration += duration)
      )
    end
  end

  def extract_audio(input)
    # Create a temp file for the encoded audio segment files
    temp_dir = Pathname.new(Dir.mktmpdir)

    # Use ffmpeg to extract the audio from the downloaded file in 10 minute chunks, as well as an overall
    # audio file for the entire input
    # -i the input path
    # -vn disable video
    # -c:a copy copy the audio codec as-is
    # -map 0:a map all audio streams from the input
    # -f segment output format
    # -segment_time  segment time in seconds
    # -reset_timestamps reset timestamps within the segment
    # -map 0:a map all audio streams from the input again
    #

    _stdout, stderr, status = Open3.capture3(
      ["ffmpeg -y -i #{input.path} -vn -c:a libmp3lame -b:a 128k -map 0:a -f segment -segment_time #{SEGMENT_SIZE}",
      " -reset_timestamps 1 #{temp_dir.join("audio-%03d.mp3")} -map 0:a #{temp_dir.join("audio.mp3")}"].join(" "))

    # Raise an exception if the system command failed
    raise "Failed to extract audio file: #{stderr}" unless status.success?

    # Yield the output file to the block
    yield Dir.glob("#{temp_dir}/*.mp3")

    FileUtils.rm_rf(temp_dir)
  end
end
