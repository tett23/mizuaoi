class LogsController < ApplicationController
  def job
  end

  def encode
    @logs = EncodeLog.list().page(params[:page] || 1)
    add_breadcrumbs('エンコードログ', url(:logs, :encode))
  end

  def disporsable
  end
end
