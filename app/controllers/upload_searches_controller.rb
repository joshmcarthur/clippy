class UploadSearchesController < ApplicationController
  def show
    term = params[:q].presence
    return redirect_to root_path if term.blank?

    @search = UploadSearch.new(term: term)
    @uploads = @search.results

    render template: "uploads/index"
  end
end
