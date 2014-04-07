class Video < ActiveRecord::Base
  belongs_to :series
  belongs_to :video_metadata

  def self.list()
    self.all().order(created_at: :desc, id: :desc)
  end

  def exists_ts?
  end
end
