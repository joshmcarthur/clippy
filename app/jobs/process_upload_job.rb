##
# Initiates the batch processing operation for an upload
class ProcessUploadJob < ApplicationJob
  queue_as :default

  def perform(upload)
    GoodJob::Batch.enqueue(on_finish: ProcessUploadBatchJob, step: :start, upload: upload)
  end
end
