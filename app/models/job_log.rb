class JobLog < ActiveRecord::Base
  enum job_type: [:encode, :repair, :restructure_queue, :update_schema]
  belongs_to :video

  def self.list
    self.all().order(created_at: :desc, id: :desc)
  end
end
