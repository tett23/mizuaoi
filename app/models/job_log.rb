class JobLog < ActiveRecord::Base
  enum job_type: [:encode, :repair, :restructure_queue, :update_schema]
  belongs_to :video

  def self.list(type=nil)
    case type
    when :encode
      self.where(job_type: :encode).order(created_at: :desc, id: :desc)
    else
      self.all().order(created_at: :desc, id: :desc)
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
end
