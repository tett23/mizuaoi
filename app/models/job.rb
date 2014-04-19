class Job < ActiveRecord::Base
  enum job_type: [:encode, :repair, :restructure_queue, :update_schema]

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
end