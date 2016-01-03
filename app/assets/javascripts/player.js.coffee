class Player
  @defaultOptions = {
    autoPlay: false
  }

  constructor: (video, player, options) ->
    @options = options || @defaultOptions
    @video = video
    @player = player
    @isPlay = false

    @addEventListeners()

  addEventListeners: ->
    @player.getElementsByClassName('play')[0].addEventListener 'click', @togglePlay
    @player.getElementsByClassName('seek_bar')[0].addEventListener 'click', @seek
    @player.getElementsByClassName('mute')[0].addEventListener 'click', @mute
    @player.getElementsByClassName('volume')[0].addEventListener 'click', @volume
    @player.getElementsByClassName('full_screen')[0].addEventListener 'click', @fullScreen
    @player.getElementsByClassName('play_chromecast')[0].addEventListener 'click', @playChromecast

  togglePlay: =>
    if @isPlay == false
      @video.play()
      @isPlay = true
    else
      @video.pause()
      @isPlay = false
  seek: =>
  currentTime: =>
  mute: =>
  volume: =>
  fullScreen: =>
  playChromecast: =>
    window['__onGCastApiAvailable'] = (loaded, errorInfo) ->
      mediaUrl = @video.getElementsByTagName('source')[0].attributes['src'].value
      mediaUrl = 'http://' + document.domain  + mediaUrl unless mediaUrl.match(/^http/)
      setTimeout(Cast.initializeCastApi(mediaUrl), 1000)

      video = document.getElementsByTagName('video')[0]
      video.addEventListener 'pause', (e) ->
        console.log 'pause'
        console.log Cast.is_available
        if Cast.is_available
          Cast.pause()
      video.addEventListener 'seeked', (e) ->
        if Cast.is_available
          Cast.seek(video.currentTime)
      video.addEventListener 'play', (e) ->
        if Cast.is_available
          Cast.seek(video.currentTime)
          Cast.play()

window.Player = Player
