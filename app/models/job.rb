class Job < ActiveRecord::Base
  enum job_type: [:encode, :repair, :restructure_queue, :update_schema, :destroy_ts]

  def self.list()
    self.all().order(priority: :asc, id: :asc)
  end

  def self.new_priority
    last_item = self.all().order(priority: :desc, id: :desc).first

    if last_item.nil?
      0
    else
      last_item.priority + 1
    end
  end

  def video
    video_id = self.parsed_arguments[:video_id]
    return nil if video_id.blank?

    Video.find_by_id(video_id)
  end

  def parsed_arguments
    return {} unless self.arguments.is_a?(String)
    parsed = YAML.load(self.arguments)
    return {} unless parsed

    parsed.symbolize_keys
  end

  def self.already_queue?(job_type, video_id)
    not self.where(job_type: Job.job_types[:destroy_ts]).find do |job|
      job.parsed_arguments[:video_id] == video_id
    end.nil?
  end
end
