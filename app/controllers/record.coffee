Spine            = require('spine')
{Panel}          = require('spine.mobile')
async            = require('async/lib/async')

class Record extends Panel
  className:
    'record'
    
  events:
    'tap .button': 'next'   
  events:
    'webkitAnimationEnd .radial-timer-half': 'stoptimer'   
    
  elements:
    '.countdown': 'countdown'
    
  constructor: (mode, app)->
    @app = app
    @mode = mode
    @className = @mode + ' record'
    super
    @render()
    @result = 4e4 if mode == 'low'
    @result = -4e4 if mode == 'high'
    
  stoptimer: (e) ->
    e.currentTarget.style.webkitAnimationPlayState = "paused";
 
  render: =>
    # Calculate currency conversion
    @html require('views/intro/record')(@)
    
  active: =>
    #reset
    k = 1
    super
    $(".retries li").removeClass('active');
    $(".results li").removeClass('active').html("");
    async.eachSeries([1, 2, 3],(i, cb) =>
      @log(Date(),"retry",1)
      @retry(i, cb)
    , (err) =>
      @log(Date(),"all done")
      @next()
      
  )
    
  retry: (k, done) =>
    async.series([
      # initial sleep
      (callback) =>
        $(".retries li:nth-child("+k+")").addClass('active');
        $(".countdown li").removeClass('active');
        @log(Date(),"countdown")
        setTimeout( ->
            console.log(Date(),"countdown")
            callback();
          ,2000)
      ,
      # countdown
      (callback) =>
        async.eachSeries([1, 2, 3]
          ,(i, cb) ->
            $(".countdown li:nth-child("+i+")").addClass('active');
            console.log(Date(), "tick",i )
            setTimeout( ->
              cb();
            , 1000)
          , (err) ->
            console.log(Date(),"launch")
            callback()
        )
      #timer
      ,(callback) =>
          $(".timer").show()
          @app.mic.enable($(".record h1"), @mode);
          async.eachSeries([15..1]
            ,(i, cb) ->
              $(".timer .counter").html(i);
              console.log(Date(), "tack",i )
              setTimeout( ->
                cb();
              , 1000)
            , (err) ->
              console.log(Date(),"launch")
              callback()
          )      
      #show result
      ,(callback) =>
          $(".timer").hide()
          @app.mic.disable();
          $(".results li:nth-child("+k+")").addClass('active').text(@app.mic.pitch + "Hz");
          @result = Math.min(@result, @app.mic.pitch) if @mode == 'low';
          @result = Math.max(@result, @app.mic.pitch) if @mode == 'high';
    
          callback()
    
    ], 
    (err, results) =>
      #@next()
      done()
    )
    
  next: =>
    @navigate('/intro_high', trans: 'right') if @mode == 'low'
    @navigate('/results', trans: 'right') if @mode == 'high'
module.exports = Record