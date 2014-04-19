class Job < ActiveRecord::Base
  enum job_type: [:encode, :repair, :restructure_queue, :update_schema]

  def self.list()
    self.all().order(priority: :asc, id: :asc)
  end
end
