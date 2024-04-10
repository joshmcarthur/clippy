##
# Application-wide helpers
module ApplicationHelper
  def from_search?
    referer = URI.parse(request.referer)
    referer.host == request.host && referer.path == search_uploads_path
  rescue URI::InvalidURIError
    false
  end
end
