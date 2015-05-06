class HomeController < ApplicationController
  def index
    @jobs = Job.list().limit(20)
    @videos = Video.list().limit(20)
    video_ids = @jobs.map do |job|
      job.video_id
    end.compact
    @job_videos = Video.find(video_ids).inject({}) do |h, video|
      h[video.id] = video

      h
    end
    @logs = JobLog.list().limit(20)
  end
end
