class TsController < ApplicationController
  def index
    identification_codes = Dir.entries(Mizuaoi::Application.config.ts_dir).map do |item|
      item.gsub(/(\d+)\-.+$/, '\1')
    end.uniq
    video_ids = Video.list(identification_code: identification_codes).map do |video|
      video.id
    end
    @logs = JobLog.list(:encode, video_id: video_ids).group(:video_id).page(params[:page] || 1)

    add_breadcrumbs('未削除TS一覧', :ts, :index)
  end

  def show
  end
end
