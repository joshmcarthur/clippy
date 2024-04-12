##
# Application-wide helpers
module ApplicationHelper
  def from_search?
    referer = URI.parse(request.referer)
    referer.host == request.host && referer.path == search_uploads_path
  rescue URI::InvalidURIError
    false
  end

  def describe_play_time(seconds)
    Time.at(seconds).utc.strftime("%H:%M:%S")
  end

  def describe_play_time_range(from_seconds, to_seconds)
    [describe_play_time(from_seconds), describe_play_time(to_seconds)].join(" - ")
  end
end
