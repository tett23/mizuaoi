class EncodeLog < ActiveRecord::Base
  def self.logs(video)
    where(:all, conditions: {
        video_id: video.id
      }
    ).order(created_at: :desc)
  end
end
