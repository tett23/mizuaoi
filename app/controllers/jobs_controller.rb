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

  private
  def permited_params
    params.require(:job).permit(:id, :job_type, :arguments, :priority, :scheduled_on)
  end
end
