class EncodeLog < ActiveRecord::Base
  belongs_to :video

  def self.logs(video)
    where(:all, conditions: {
        video_id: video.id
      }
    ).order(created_at: :desc)
  end

  def self.list()
    self.all().order(created_at: :desc, id: :desc)
  end

  def output_size
    (self.width && self.height) ? "#{self.width}x#{self.height}" : nil
  end
end
