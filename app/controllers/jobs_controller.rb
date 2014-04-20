class JobsController < ApplicationController
  def index
    @jobs = Job.list().page(params[:page] || 1)
  end

  def new
    @job = Job.new
    @job.priority = Job.new_priority
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
    job[:priority] = Job.new_priority
    job.permit!
    job = Job.create(params[:job])
    if job.persisted?
      redirect_to request.referer, flash: {success: "#{job.video.output_name}のTS削除ジョブを追加"}
    else
      redirect_to request.referer, flash: {success: "#{job.video.output_name}のTS削除ジョブの追加に失敗"}
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
