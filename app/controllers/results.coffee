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
    window.addEventListener('message',  (event) =>
      @log "back", event.data
    );    
    $("html").attr("extensionCalled",1);
    
  render: =>
    # Calculate currency conversion
    @html require('views/intro/results')(@)
    @footer.html  require('views/intro/results_footer')(@)
    window.postMessage('screenshot', '*');
    window.postMessage('get-sourceId', '*');

    
  restart: ->
     #@navigate('/', trans: 'left')
     window.location.reload()

  next: ->
     @navigate('/email', trans: 'right')
module.exports = Results