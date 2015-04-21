class Mic
  @MIN_SAMPLES = 0
  @tracks = null;
  @buf = new Float32Array(1024);  
  constructor: (canvas) ->
    @waveWidth = parseInt($("canvas").css("width"));
    @waveHeight = parseInt($("canvas").css("height"));
    $("canvas").attr('width', @waveWidth);
    $("canvas").attr('height', @waveHeight);
    
    @waveCanvas = canvas[0].getContext("2d");
    @waveCanvas.strokeStyle = "#00897b"
    @waveCanvas.lineWidth = 1;
        
    @audioContext = new AudioContext();
    @analyser = @audioContext.createAnalyser();
    @analyser.fftSize = 2048;
    @rafID = null;
    @pitchEl = null
    @mode = 'low'
    
    #@analyserView1 = new AnalyserView("view1");
    #@analyserView1.setAnalysisType(ANALYSISTYPE_FREQUENCY)

    window.requestAnimationFrame = window.webkitRequestAnimationFrame if (!window.requestAnimationFrame)
    
    @getUserMedia(
    	{
            "audio": {
                "mandatory": {
                    "googEchoCancellation": "false",
                    "googAutoGainControl": "false",
                    "googNoiseSuppression": "false",
                    "googHighpassFilter": "false"
                },
                "optional": []
            },
        }, @gotStream)
       
  enable:(el, mode) ->
    console.log "mic, enable",el, mode
    @pitchEl = el
    @mode = mode
    @pitch = 1e10 if mode == 'low'
    @pitch = -1e10 if mode == 'high'
  disable:() ->  
    console.log "mic, disable"
    @pitchEl = null
    
  getUserMedia: (dictionary, callback) ->
    navigator.getUserMedia = 
      navigator.getUserMedia ||
      navigator.webkitGetUserMedia ||
      navigator.mozGetUserMedia;
    navigator.getUserMedia(dictionary, callback, (e) ->
      console.log(e)
    );
    
   
  gotStream: (stream) =>
    # Create an AudioNode from the stream.
    @mediaStreamSource = @audioContext.createMediaStreamSource(stream);

    # Connect it to the destination.
    @analyser = @audioContext.createAnalyser();
    @analyser.fftSize = 1024;
    @mediaStreamSource.connect( @analyser );
    if @analyserView1
      @freqByteData = new Uint8Array(@analyser.frequencyBinCount);
      @analyserView1.initByteBuffer(@analyser);
      @history1 = new CircularBuffer(500, @analyser.frequencyBinCount)
      @history2 = new CircularBuffer(10, @analyser.frequencyBinCount)
    
    @updatePitch();
    
  updatePitch: (time) =>
    #@analyserView1.doFrequencyAnalysis(@analyser);
    @analyser.smoothingTimeConstant = 0.75;
    @analyser.getByteFrequencyData(@freqByteData);
    if @analyserView1
      @history1.push(@freqByteData)
      @history2.push(@freqByteData)
      @analyserView1.freqByteData=@history1.avg()
      @analyserView1.drawGL();
    #window.requestAnimationFrame(@updatePitch);
    
    cycles = [];

    @analyser.getFloatTimeDomainData(Mic.buf);
    ac = @autoCorrelate(Mic.buf, @audioContext.sampleRate);
    # TODO: Paint confidence meter on canvasElem here.

    
    @waveCanvas.clearRect(0, 0, @waveWidth, @waveHeight);
    for i in [0..10]
      @waveCanvas.beginPath();
      for x in [0..@waveWidth]
        y = Math.sin(x / @waveWidth *12 + 30)
        @waveCanvas.lineTo(x, y*Mic.buf[i*10]*800+ @waveHeight/2)
      @waveCanvas.stroke();
#    $("h1").html(Mic.buf[0]*200)
#    $("h2").html(ac)

    if ac > 0
      @pitch = Math.min(@pitch, Math.round(ac)) if @mode == 'low';
      @pitch = Math.max(@pitch, Math.round(ac)) if @mode == 'high';
    

    @rafID = window.requestAnimationFrame(@updatePitch);
    @pitchEl.html(@pitch + "Hz") if @pitchEl
    
    
  autoCorrelate: (buf, sampleRate) ->
    SIZE = buf.length;
    MAX_SAMPLES = Math.floor(SIZE / 2);
    best_offset = -1;
    best_correlation = 0;
    rms = 0;
    foundGoodCorrelation = false;
    correlations = new Array(MAX_SAMPLES);

    for i in [0..SIZE]
        val = buf[i];
        rms += val * val;
    
    rms = Math.sqrt(rms / SIZE);
    if (rms < 0.01) # not enough signal
        return -1;

    lastCorrelation = 1;
    for offset in [Mic.MIN_SAMPLES..MAX_SAMPLES]
        correlation = 0;

        for i in [0..MAX_SAMPLES]
            correlation += Math.abs((buf[i]) - (buf[i + offset]));
        
        correlation = 1 - (correlation / MAX_SAMPLES);
        correlations[offset] = correlation; # store it, for the tweaking we need to do below.
        if ((correlation > 0.9) && (correlation > lastCorrelation)) 
            foundGoodCorrelation = true;
            if (correlation > best_correlation) 
                best_correlation = correlation;
                best_offset = offset;
            
        else if (foundGoodCorrelation) 
            # short-circuit - we found a good correlation, then a bad one, so we'd just be seeing copies from here.
            # Now we need to tweak the offset - by interpolating between the values to the left and right of the
            # best offset, and shifting it a bit.  This is complex, and HACKY in this code (happy to take PRs!) -
            # we need to do a curve fit on correlations[] around best_offset in order to better determine precise
            # (anti-aliased) offset.
            #
            # we know best_offset >=1, 
            # since foundGoodCorrelation cannot go to true until the second pass (offset=1), and 
            # we can't drop into this clause until the following pass (else if).
            shift = (correlations[best_offset + 1] - correlations[best_offset - 1]) / correlations[best_offset]
            return sampleRate / (best_offset + (8 * shift))
        
        lastCorrelation = correlation;
    
    if (best_correlation > 0.01) 
        # console.log("f = " + sampleRate/best_offset + "Hz (rms: " + rms + " confidence: " + best_correlation + ")")
        return sampleRate / best_offset;
    
    return -1;
    # var best_frequency = sampleRate/best_offset;

module.exports = Mic