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
  
  noteStrings: ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
    
  noteFromPitch: (frequency) ->
    noteNum = 12 * (Math.log(frequency / 440) / Math.log(2))
    note = Math.round(noteNum) + 69
    
    noteGroup = Math.floor(note/12)-1;
 
    return @noteStrings[note % 12] + noteGroup
    

  constructor: (mode, app)->
    @app = app
    @mode = mode
    @className = @mode + ' record'
    super
    @render()
    @result = 4e4 if mode == 'low'
    @result = -4e4 if mode == 'high'
    @note = ''
    
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
          async.eachSeries([10..1]
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
          if @mode == 'low' &&  @app.mic.pitch < @result
            @result = @app.mic.pitch
            @note = @noteFromPitch(@result)
          if @mode == 'high' &&  @app.mic.pitch > @result
            @result = @app.mic.pitch
            @note = @noteFromPitch(@result)
    
          callback()
    
    ], 
    (err, results) =>
      #@next()
      setTimeout( ->
        done();
      ,2000)
    )
    
  next: =>
    @navigate('/intro_high', trans: 'right') if @mode == 'low'
    @navigate('/results', trans: 'right') if @mode == 'high'
module.exports = Record