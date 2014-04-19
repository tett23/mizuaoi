class Job < ActiveRecord::Base
  enum job_type: [:encode, :repair, :restructure_queue, :update_schema]

  def self.list()
    self.all().order(priority: :asc, id: :asc)
  end

  def self.new_priority
    self.all().order(priority: :desc, id: :desc).first.priority + 1
  end
end
