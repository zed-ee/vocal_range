Spine            = require('spine')
{Panel}          = require('spine.mobile')

class PlayLow extends Panel
  className:
    'play'
    
  events:
    'tap .button': 'next'   
  elements:
    "audio": "audio"
    
  constructor: (mode)->
    @mode = mode
    @className = @mode + ' play'
    super
    @render()
    
  
  render: =>
    # Calculate currency conversion
    @html require('views/intro/play')(@)
    
  active: =>
    super
    setTimeout ( =>
      @audio[0].currentTime =0
      @audio[0].play()
      setTimeout ( =>
        @audio[0].pause()
        @next()
        ), 6500
    ), 200
    
  next: ->
     @log('/intro2_'+@mode)
     @navigate('/intro2_'+@mode, trans: 'right')
     
module.exports = PlayLow