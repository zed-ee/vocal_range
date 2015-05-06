Spine            = require('spine')
{Panel}          = require('spine.mobile')

class Intro extends Panel
  className:
    'startup'
    
  events:
    'tap .button': 'next'   
  constructor: ->
    super

    @render()

#  active:->
#    @render
    
  render: =>
    # Calculate currency conversion
    @html require('views/intro/index')(@)
  active: ->
    super
    $("body > footer")[0].className = @className
    
  next: ->
     @navigate('/intro_low', trans: 'right')
module.exports = Intro