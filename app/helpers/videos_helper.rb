module VideosHelper
  def video_class(video)
    add_classes = []

    add_classes << (video.is_encoded ? 'bg-success' : 'bg-warning')
    add_classes << (video.is_watched ? 'watched' : 'unwatched')

    add_classes.join(' ')
  end

  def video_path(video)
    Mizuaoi::Application.config.video_host+URI.encode(video.output_name)
  end
end
