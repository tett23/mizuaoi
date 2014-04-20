class SearchController < ApplicationController
  def index
    @videos = Video.search(params[:query]).page(params[:page] || 1)
  end
end
