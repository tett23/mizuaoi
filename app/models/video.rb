class Video < ActiveRecord::Base
  belongs_to :series
  belongs_to :video_metadata

  def self.list()
    self.all().order(created_at: :desc, id: :desc)
  end

  def exists_ts?
    File.exists?(ts_path)
  end

  def ts_path
    File.join(Mizuaoi::Application.config.ts_dir, self.original_name)
  end

  def self.create_output_name(name, episode_number, episode_name, event_id)
    "#{name}#{episode_number ? '#'+episode_number.to_s : ''}#{episode_name ? "「#{episode_name}」" : ''}_#{event_id}.mp4"
  end

  def move_output_file(destination)
    return unless !self.is_encoded

    FileUtils.mv(File.join(self.saved_directory, self.output_name), File.join(self.saved_directory, destination))
    self.output_name = destination
    self.save()
  end
end
