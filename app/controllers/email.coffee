Spine            = require('spine')
{Panel}          = require('spine.mobile')

class IntroHigh extends Panel
  className:
    'intro_low'
    
  events:
    'tap .button': 'next'   
    
  constructor: ->
    super
    @render()
  
  render: =>
    # Calculate currency conversion
    @html require('views/intro/email_form')(@)
    
  next: ->
     @navigate('/email_sent', trans: 'left')
module.exports = IntroHigh