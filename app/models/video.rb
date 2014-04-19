class Video < ActiveRecord::Base
  belongs_to :series
  belongs_to :video_metadata

  def self.list()
    self.all().order(created_at: :desc, id: :desc)
  end

  def exists_ts?
  end

  def self.create_output_name(name, episode_number, episode_name, event_id)
    "#{name}#{episode_number ? '#'+episode_number.to_s : ''}#{episode_name ? "「#{episode_name}」" : ''}_#{event_id}.mp4"
  end
end
