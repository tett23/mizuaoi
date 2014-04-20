class TsController < ApplicationController
  def index
    identification_codes = Dir.entries(Mizuaoi::Application.config.ts_dir).map do |item|
      item.gsub(/(\d+)\-.+$/, '\1')
    end.uniq
    @videos = Video.list(identification_code: identification_codes).page(params[:page] || 1)
  end

  def show
  end
end
