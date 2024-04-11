##
# Controller for creating clips from segments.
class ClipsController < ApplicationController
  def create
    @clip = Clip.create_from_segments(start_segment, end_segment)

    redirect_back fallback_location: @clip.upload
  end

  private

  def start_segment
    Segment.find(params.require(:clip).require(:start_segment_id))
  end

  def end_segment
    Segment.find(params.require(:clip).require(:end_segment_id))
  end
end
