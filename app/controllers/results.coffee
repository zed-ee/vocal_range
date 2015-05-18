Spine            = require('spine')
{Panel}          = require('spine.mobile')

class Results extends Panel
  className:
    'results'
    
  events:
    'tap .link': 'restart'   
    'tap .button': 'next'   
    
  constructor: ->
    super
    #@render()

  active:(params) ->
    @log("Results", params)
    @params = params
    super
    @render()
    $("body > footer")[0].className = 'step8'
    
  render: =>
    # Calculate currency conversion
    @html require('views/intro/results')(@)
    @footer.html  require('views/intro/results_footer')(@)
    getScreenId( (error, sourceId, screen_constraints) =>
        @log "getScreenId", error, sourceId, screen_constraints
        # error    == null || 'permission-denied' || 'not-installed' || 'installed-disabled' || 'not-chrome'
        # sourceId == null || 'string' || 'firefox'

        screen_constraints = {
            video: {
                mandatory: {
                    chromeMediaSource: 'tab',
                    maxWidth: 1920,
                    maxHeight: 1080,
                    minAspectRatio: 1.77
                }
            }
        }
        
        screen_constraints.video.mandatory.chromeMediaSource = 'tab';
        screen_constraints.video.mandatory.chromeMediaSourceId = sourceId;
            
        navigator.getUserMedia = navigator.mozGetUserMedia || navigator.webkitGetUserMedia;
        navigator.getUserMedia(screen_constraints, (stream) ->
           $('video')[0].src = URL.createObjectURL(stream);
        ,  (error) ->
            console.error(error);
        );
    );
    
  restart: ->
     #@navigate('/', trans: 'left')
     window.location.reload()

  next: ->
     @navigate('/email', trans: 'right')
module.exports = Results