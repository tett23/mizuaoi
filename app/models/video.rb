class Video < ActiveRecord::Base
  belongs_to :series
  belongs_to :video_metadata
end
