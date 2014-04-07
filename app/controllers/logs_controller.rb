class LogsController < ApplicationController
  def job
  end

  def encode
    @logs = EncodeLog.list().page(params[:page] || 1)
  end

  def disporsable
  end
end
