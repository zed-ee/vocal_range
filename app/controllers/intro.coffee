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
    
  active: ->
    super
    if @mode == 'low'
      $("body > footer")[0].className = if @page == 'intro' then 'step1' else 'step2'
    else
      $("body > footer")[0].className = if @page == 'intro' then 'step4' else 'step5'
    
  next: ->
     @navigate(@next_page, trans: 'right')
module.exports = Intro