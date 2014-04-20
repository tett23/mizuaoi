class VideosController < ApplicationController
  def index
    @videos = Video.list().page(params[:page] || 1)
    add_breadcrumbs('動画一覧', url(:videos, :index))
  end

  def show
    @video = Video.find(params[:id])
    error 404 if @video.nil?

    @logs = JobLog.list(:encode, {video_id: params[:id]}).page(params[:page] || 1)
    add_breadcrumbs('動画一覧', url(:videos, :index))
    add_breadcrumbs(@video.output_name, url(:videos, :show, :id=>@video.id))
  end

  def play
    @video = Video.find(params[:id])
    error 404 if @video.nil?

    add_breadcrumbs('動画一覧', url(:videos, :index))
    add_breadcrumbs(@video.output_name, url(:videos, :show, :id=>@video.id))
    add_breadcrumbs('再生', url(:videos, :play, :id=>@video.id))

    @sidebar = false
  end

  def edit
    @video = Video.find(params[:id])
    error 404 if @video.nil?
  end

  def update
    video = permited_params
    @video = Video.find(video[:id])
    error 404 if @video.nil?

    video[:output_name] = Video.create_output_name(video[:name], video[:episode_number], video[:episode_name], video[:event_id])
    @video.move_output_file(video[:output_name]) unless @video.output_name === video[:output_name]

    if Video.update(@video.id, video)
      redirect_to url_for(controller: :videos, action: :show, id: @video.id), flash: {success: "動画情報を編集しました"}
    else
      render action: :edit
    end
  end

  private
  def permited_params
    params.require(:video).permit(:id, :original_name, :name, :output_name, :episode_name, :episode_number, :repaired_ts, :is_encodable)
  end
end
