require('lib/setup')

Spine   = require('spine')
{Stage} = require('spine.mobile')
{Panel}          = require('spine.mobile')
Startup = require('controllers/startup')
Intro = require('controllers/intro')
Play = require('controllers/play')
Record = require('controllers/record')
Results = require('controllers/results')
Email = require('controllers/email')

Microphone = require('models/microphone')

class App extends Stage.Global
  events:
    'tap .set_lang': 'set_lang'   
    'tap .restart': 'restart'   
  
  set_lang: (e) =>
    @log(e)
    @navigate('/'+window.lang, trans: 'right')
    window.lang = if window.lang == 'en' then 'et' else 'en'
    @lang = window.lang
    @log(window.lang)
    @intro.active()
    
  restart: (e) =>
    @navigate('/', trans: 'right')
    
  constructor: (params)->
    super
    @mic = null
    @spectrum  = $('<canvas id="view1"></canvas>')
    @wave  = $('<canvas class="wave"></canvas>')
    @header.append(@wave)
    #@header.append(@spectrum)
    @app_data = params.data
    @intro = new Startup
    @introLow = new Intro(mode:'low',page: 'intro', next_page: '/play_low')
    @PlayLow = new Play('low')
    @intro2Low = new Intro(mode:'low',page: 'intro2', next_page: '/record_low')
    @RecordLow = new Record('low', @)
    @IntroHigh = new Intro(mode:'high',page: 'intro', next_page: '/play_high')
    @PlayHigh = new Play('high')
    @intro2High = new Intro(mode:'high',page: 'intro2', next_page: '/record_high')
    @RecordHigh = new Record('high', @)
    @Results = new Results
    @EmailForm = new  Email

    setTimeout(=>
      @mic = new Microphone(@wave)
    ,500)
    @setLang = new Panel
    @intro.active()
    
    
    @routes
      '/':        (params) -> @intro.active(params)
      '/en':        (params) -> @intro.active(params)
      '/et':        (params) -> @intro.active(params)
      '/intro_low': (params) -> @introLow.active(params)
      '/play_low': (params) -> @PlayLow.active(params)
      '/intro2_low': (params) -> @intro2Low.active(params)
      '/record_low': (params) -> @RecordLow.active(params)
      '/intro_high': (params) -> @IntroHigh.active(params)
      '/play_high': (params) -> @PlayHigh.active(params)
      '/intro2_high': (params) -> @intro2High.active(params)
      '/record_high': (params) -> @RecordHigh.active(params)
      '/results': (params) => @Results.active( 'low': @RecordLow.result, 'high': @RecordHigh.result)
      '/email_form': (params) -> @EmailForm.active(params)
    @footer.html require('views/intro/footer')
    #@navigate('/results', trans: 'right')
       
module.exports = App