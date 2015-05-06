class JobLog < ActiveRecord::Base
  enum status: [:failure, :success, :in_progress]
  enum job_type: [:encode, :repair, :restructure_queue, :update_schema, :destroy_ts, :update_output_name, :get_program]
  belongs_to :video

  def self.list(type=nil, conditions={})
    case type
    when :encode
      self.where({job_type: :encode}.merge(conditions)).order(created_at: :desc, id: :desc).preload(:video)
    else
      self.where(conditions).order(created_at: :desc, id: :desc).preload(:video)
    end
  end

  def output_size
    encode_size = self.parsed_arguments[:encode_size]
    return '' if encode_size.blank?
    encode_size.symbolize_keys!

    "#{encode_size[:width]}x#{encode_size[:height]}"
  end

  def parsed_arguments
    return {} unless self.arguments.is_a?(String)
    parsed = YAML.load(self.arguments)
    return {} unless parsed

    parsed.symbolize_keys
  end

  def process_time
    finish_or_now = self.finish_at.blank? ? Time.now : self.finish_at.to_time
    secs = (finish_or_now.to_i - self.start_at.to_time.to_i).to_i rescue 0

    Time.now.midnight.advance(:seconds => secs).strftime('%T') # 経過時間を求める
  end
end
