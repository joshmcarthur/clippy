##
# Controller for creating clips from segments.
class ClipsController < ApplicationController
  def create
    @clip = Clip.create(transcript_id: transcript_id, range: clip_range)

    redirect_back fallback_location: @clip.upload
  end

  private

  def clip_param(key)
    params.require(:clip).require(key)
  end

  def clip_range
    clip_param(:starts)...clip_param(:ends)
  end

  def transcript_id
    clip_param(:transcript_id)
  end
end
