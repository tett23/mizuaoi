class VideosController < ApplicationController
  def index
    @videos = Video.list().page(params[:page] || 1)
  end

  def show
  end

  def play
  end
end
