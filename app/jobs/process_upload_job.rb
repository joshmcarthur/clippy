##
# Initiates the batch processing operation for an upload
class ProcessUploadJob < ApplicationJob
  queue_as :default

  ##
  # Define the pipeline of stages that the upload will go through
  # Each key in this map represents a processing stage of the upload,
  # and the value represents the method name to invoke to move the upload
  # to the next stage.
  PIPELINE = {
    pending: :start,
    started: :extract_audio,
    extracting_audio: :transcribe,
    transcribing: :collate,
    collating: :summarise,
    summarising: :complete
  }.freeze

  ##
  # Process the upload, moving it through the processing pipeline.
  # @arg upload [Upload] the upload to process
  # @arg reset [Boolean] whether to reset the upload to the pending stage before processing
  def perform(upload, reset: false)
    reset(upload) if reset
    process(upload)
  end

  private

  def process(upload)
    send(PIPELINE.fetch(upload.processing_stage.to_sym), upload) until upload.complete?
  end

  def reset(upload)
    upload.update!(
      processing_ended_at: nil,
      processing_started_at: nil,
      processing_stage: :pending
    )
  end

  def start(upload)
    upload.update!(processing_started_at: Time.zone.now)
  end

  def complete(upload)
    upload.update!(processing_ended_at: Time.zone.now, processing_stage: :complete)
  end

  def extract_audio(upload)
    upload.extracting_audio!
    ExtractAudioJob.perform_now(upload)
  end

  def transcribe(upload)
    upload.transcribing!
    upload.audio_segments.map do |segment|
      Thread.new do
        TranscribeAudioSegmentJob.perform_now(segment)
      end
    end.each(&:join)
  end

  def collate(upload)
    upload.collating!
    CollateAudioSegmentsJob.perform_now(upload)
  end

  def summarise(upload)
    upload.summarising!
    [SummariseFullTextJob, SummariseEntitiesJob, SummariseNotesJob].map do |job|
      Thread.new do
        job.perform_now(upload)
      end
    end.each(&:join)
  end
end
