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
  restart: ->
     @navigate('/', trans: 'left')
  next: ->
     @navigate('/email_form', trans: 'right')
module.exports = Results