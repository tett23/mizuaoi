class Cast
  @initializeCastApi: (mediaUrl) =>
    @isAvailable = false
    @mediaUrl = mediaUrl
    apiConfig = new chrome.cast.ApiConfig(@sessionRequest(), @sessionListener, @receiverListener)
    chrome.cast.initialize(apiConfig, @onInitSuccess, @onError)

  @sessionListener: (e) =>
    session = e
    return [] unless session.media?

    @onRequestSessionSuccess(session)
    @onMediaDiscovered('onRequestSessionSuccess', session.media[0])

  @getMedia: =>
    mediaInfo = new chrome.cast.media.MediaInfo(@mediaUrl)
    mediaInfo.contentType = 'video/mp4'
    mediaInfo.metadata = new chrome.cast.media.GenericMediaMetadata()
    mediaInfo.customData = null
    mediaInfo.streamType = chrome.cast.media.StreamType.BUFFERED
    mediaInfo.textTrackStyle = new chrome.cast.media.TextTrackStyle()
    mediaInfo.duration = null
    #mediaInfo.tracks = tracks

    mediaInfo

  @receiverListener: (e) ->
    if e == chrome.cast.ReceiverAvailability.AVAILABLE
      @listener = e

  @onInitSuccess: () ->
    console.log 'onInitSuccess'
    chrome.cast.requestSession(@onRequestSessionSuccess, @onLaunchError, @onInitError, @onInitError)

  @onInitError: (e) ->
    console.log 'onInitError'
    console.log arguments

  @sessionRequest: (applicationId) =>
    applicationId = applicationId || chrome.cast.media.DEFAULT_MEDIA_RECEIVER_APP_ID

    new chrome.cast.SessionRequest(applicationId)

  @onRequestSessionSuccess: (session) ->
    @session = session
    request = new chrome.cast.media.LoadRequest(@getMedia())
    session.loadMedia(request, @onMediaDiscovered.bind(window, 'getMedia'), @onMediaError)

  @onMediaDiscovered: (how, media) =>
    media.addUpdateListener(@onMediaStatusUpdate)
    media.play()
    @currentMedia = media
    @isAvailable = true

  @onMediaError: =>
    console.log 'onMediaError'
    console.log arguments

  @onMediaStatusUpdate: =>
    console.log 'onMediaStatusUpdate'
    console.log arguments

  @onLaunchError: =>
    console.log 'onLaunchError'
    console.log arguments

  @pause: =>
    @currentMedia.pause()
  @seek: (currentTime) =>
    seek = new chrome.cast.media.SeekRequest()
    seek.currentTime = currentTime
    @currentMedia.seek(seek)
  @play: =>
    @currentMedia.play()

window['__onGCastApiAvailable'] = (loaded, errorInfo) ->
  mediaUrl = document.getElementsByTagName('source')[0].attributes['src'].value
  mediaUrl = 'http://' + document.domain  + mediaUrl unless mediaUrl.match(/^http/)
  setTimeout(Cast.initializeCastApi(mediaUrl), 1000)

  video = document.getElementsByTagName('video')[0]
  video.addEventListener 'pause', (e) ->
    console.log 'pause'
    console.log Cast.isAvailable
    if Cast.isAvailable
      Cast.pause()
  video.addEventListener 'seeked', (e) ->
    if Cast.isAvailable
      Cast.seek(video.currentTime)
  video.addEventListener 'play', (e) ->
    if Cast.isAvailable
      Cast.seek(video.currentTime)
      Cast.play()
