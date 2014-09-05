class LogsController < ApplicationController
  def job
    @logs = JobLog.list().page(params[:page] || 1)
    add_breadcrumbs('ジョブログ', :logs, :job)
  end

  def show
    @log = JobLog.find(params[:id])
    add_breadcrumbs('ジョブログ', :logs, :job)
    add_breadcrumbs(@log.id, :logs, :show, id: @log.id)
  end

  def encode
    @logs = JobLog.list(:encode).page(params[:page] || 1)
    add_breadcrumbs('エンコードログ', :logs, :encode)
  end

  def disporsable
  end
end
