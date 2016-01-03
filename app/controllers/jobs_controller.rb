class JobsController < ApplicationController
  def index
    @jobs = Job.list().page(params[:page] || 1)
    video_ids = @jobs.map do |job|
      job.video_id
    end.compact
    @videos = Video.find(video_ids).inject({}) do |h, video|
      h[video.id] = video

      h
    end
    add_breadcrumbs('ジョブ一覧', :jobs, :index)
  end

  def new
    @job = Job.new
    @job.priority = Job.new_priority
    add_breadcrumbs('新規ジョブ', :jobs, :new)
  end

  def create
    job = permited_params
    job[:job_type] = job[:job_type].to_i
    @job = Job.create(job)

    if @job.persisted?
      redirect_to url_for(controller: :jobs, action: :index), flash: {success: "created job: #{@job.job_type}"}
    else
      render action: :new
    end
  end

  def edit
    @job = Job.find(params[:id])
    error 404 if @job.nil?
    add_breadcrumbs('ジョブ一覧', :jobs, :index)
    add_breadcrumbs('ジョブ編集: '+params[:id], :jobs, :edit)
  end

  def update
    job = permited_params
    @job = Job.find(job[:id])
    error 404 if @job.nil?

    @job.job_type = job[:job_type].to_i
    @job.arguments = job[:arguments]
    @job.priority = job[:priority]
    @job.scheduled_on = job[:scheduled_on]
    @job.save()

    if @job.persisted?
      redirect_to url_for(controller: :jobs, action: :index), flash: {success: "created job: #{@job.job_type}"}
    else
      render action: :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    error 404 if @job.nil?

    @job.destroy
    redirect_to url_for(controller: :jobs, action: :index), flash: {success: "destroy job: #{params[:id]}"}
  end

  def destroy_ts
    job = params.require(:job)
    job[:arguments][:video_id] = job[:arguments][:video_id].to_i
    job[:arguments] = job[:arguments].to_h.to_yaml
    job[:priority] = Job.new_priority
    job.permit!
    job = Job.create(job.to_h)

    if job.persisted?
      render json: true
    else
      render json: false
    end
  end

  def create_by
    job = {
      arguments: params[:arguments],
      priority: Job.new_priority
    }
    #job = Job.create(job)
    if job.persisted?
      redirect_to request.referer, flash: {success: ""}
    else
      redirect_to request.referer, flash: {success: ""}
    end
  end

  def update_queue
    params[:order].map do |job_id|
      job_id.to_i
    end.zip((0..params[:order].size-1).to_a) do |job_id, priority|
      Job.update(job_id, priority: priority+1)
    end

    render json: true
  end

  private
  def permited_params
    params.require(:job).permit(:id, :job_type, :arguments, :priority, :scheduled_on)
  end
end
