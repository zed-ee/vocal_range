Spine            = require('spine')
{Panel}          = require('spine.mobile')

class Intro extends Panel
  className:
    'intro x'
    
  events:
    'tap .button': 'next'   
    
  constructor: (params)->
    @mode = params.mode 
    @page = params.page
    @next_page = params.next_page
    
    @className = @mode + ' ' + @page
    #Intro.className = @className
    @log(params, @className,@next_page)
    super
    @render()
  
  render: =>
    # Calculate currency conversion
    @html require('views/intro/intro')(@)
    
  next: ->
     @navigate(@next_page, trans: 'right')
module.exports = Intro