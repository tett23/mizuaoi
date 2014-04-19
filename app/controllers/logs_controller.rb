class LogsController < ApplicationController
  def job
    @logs = JobLog.list().page(params[:page] || 1)
    add_breadcrumbs('ジョブログ', url(:logs, :job))
  end

  def show
    @log = JobLog.find(params[:id])
    add_breadcrumbs('ジョブログ', url(:logs, :job))
    add_breadcrumbs(@log.id, url(:logs, :show, id: @log.id))
  end

  def encode
    @logs = EncodeLog.list().page(params[:page] || 1)
    add_breadcrumbs('エンコードログ', url(:logs, :encode))
  end

  def disporsable
  end
end
