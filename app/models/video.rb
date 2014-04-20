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
    "#{name}#{episode_number.blank? ? '' : '#'+episode_number.to_s}#{"「#{episode_name}」" unless episode_name.blank?}_#{event_id}.mp4"
  end

  def move_output_file(destination)
    return if !self.is_encoded && self.saved_directory.blank?

    FileUtils.mv(File.join(self.saved_directory, self.output_name), File.join(self.saved_directory, destination))
    self.output_name = destination
    self.save()
  end

  def self.search(query)
    keywords = query.strip.split(/\s/).map do |k|
      k.strip
    end
    return [] if keywords.size.zero?

    conditions = keywords.map do |k|
      'program LIKE ?'
    end
    keywords = keywords.map do |k|
      "%#{k}%"
    end

    self.where(conditions.join(" AND "), *keywords).order(created_at: :desc, id: :desc)
  end
end
