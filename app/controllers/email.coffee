Spine            = require('spine')
{Panel}          = require('spine.mobile')

class IntroHigh extends Panel
  className:
    'email'
    
  events:
    'click .button': 'next'   
    
  constructor: ->
    super
    @render()
  
  render: (sent) =>
    # Calculate currency conversion
    if sent
      @html require('views/intro/email_sent')(@)
    else
      @html require('views/intro/email_form')(@)
    
  active: (params) =>
    @log "active", params
    super
    $("body > footer")[0].className = 'step9'
    @render(params.sent)
    
  next: ->
     @navigate('/email', "sent" ,trans: 'left')
module.exports = IntroHigh