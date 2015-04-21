Spine            = require('spine')
{Panel}          = require('spine.mobile')

class Results extends Panel
  className:
    'results'
    
  events:
    'tap .link': 'restart'   
    'tap .buton': 'next'   
    
  constructor: ->
    super
    #@render()
  
  active:(params) ->
    @log("Results", params)
    @params = params
    super
    @render()
    
  render: =>
    # Calculate currency conversion
    @html require('views/intro/results')(@)
    
  restart: ->
     @navigate('/', trans: 'left')
  next: ->
     @navigate('/email_form', trans: 'right')
module.exports = Results