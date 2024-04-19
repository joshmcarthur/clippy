##
# Controller for creating clips from segments.
class ClipsController < ApplicationController
  def create
    @clip = Clip.create(
      transcript_id: transcript_id,
      start_time: clip_param(:starts),
      end_time: clip_param(:ends))

    redirect_back fallback_location: @clip.upload
  end

  def destroy
    @clip = Clip.destroy(params[:id])

    redirect_back fallback_location: @clip.upload
  end

  private

  def clip_param(key)
    params.require(:clip).require(key)
  end

  def transcript_id
    clip_param(:transcript_id)
  end
end
