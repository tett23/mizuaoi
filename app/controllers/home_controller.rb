class HomeController < ApplicationController
  def index
    @jobs = Job.list().limit(20)
    @videos = Video.list().limit(20)
    @logs = JobLog.list().limit(20)
  end
end
