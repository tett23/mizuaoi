module VideosHelper
  def video_class(video)
    add_classes = []

    add_classes << (video.is_encoded ? 'encoded' : 'unencoded')
    add_classes << (video.is_watched ? 'watched' : 'unwatched')

    add_classes.join(' ')
  end
end
