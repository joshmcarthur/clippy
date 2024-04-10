class ClipsController < ApplicationController
  def create
    @clip = Clip.create(clip_params)

    redirect_back fallback_location: @clip.upload
  end

  private

  def clip_params
    params.require(:clip).permit(:start_segment_id, :end_segment_id)
  end
end
