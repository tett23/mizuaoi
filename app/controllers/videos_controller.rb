class VideosController < ApplicationController
  def index
    @videos = Video.list().page(params[:page] || 1)
  end

  def show
    @video = Video.find(params[:id])
    error 404 if @video.nil?

    @logs = EncodeLog.logs(@video)
    add_breadcrumbs('動画一覧', url(:videos, :index))
    add_breadcrumbs(@video.output_name, url(:videos, :show, :id=>@video.id))
  end

  def play
  end
end
