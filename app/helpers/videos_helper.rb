module VideosHelper
  def video_class(video)
    add_classes = []

    add_classes << (video.is_encoded ? 'bg-success' : 'bg-warning')
    add_classes << (video.is_watched ? 'watched' : 'unwatched')

    add_classes.join(' ')
  end

  def video_path(video)
    'http://192.168.1.102/movie/frogbit/'+URI.encode(video.output_name)
  end
end
