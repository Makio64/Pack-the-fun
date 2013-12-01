main = null

class Main

	scene 			: null
	camera 			: null
	renderer 		: null
	dt 				: 0
	lastTime 		: 0
	pause 			: false

	constructor:()->
		
		# if !Detector.webgl
		# 	Detector.addGetWebGLMessage()
		
		@camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 10000)
		@camera.position.set(0,0,300)
		@scene = new THREE.Scene()
		@scene.fog = new THREE.Fog(0x051b32, 0.0001, 1000)
		@scene.add @camera
		@renderer = new THREE.WebGLRenderer(
			antialias: true
			precision: "highp"
			maxLights: 10
			stencil: false
			preserveDrawingBuffer: false
		)
		@renderer.autoClear = true
		@renderer.setClearColor( 0x051b32 )
		@renderer.setSize window.innerWidth, window.innerHeight
		@renderer.shadowMapEnabled = false
		@renderer.shadowMapSoft = false
		@renderer.gammaInput = true
		@renderer.gammaOutput = true
		$("#main").append( @renderer.domElement )

		@ambient = new THREE.AmbientLight(0x1b2a38)
		@scene.add( @ambient )

		#postprocessing

		vignette = new THREE.ShaderPass( THREE.VignetteShader )
		vignette.uniforms[ "offset" ].value = 0.09;
		vignette.uniforms[ "darkness" ].value = 8.4;

		vignette2 = new THREE.ShaderPass( THREE.VignetteShader )
		vignette2.uniforms[ "offset" ].value = 100;
		vignette2.uniforms[ "darkness" ].value = 10;

		focus = new THREE.ShaderPass( THREE.FocusShader )
		focus.uniforms[ "screenWidth" ].value = window.innerWidth;
		focus.uniforms[ "screenHeight" ].value = window.innerHeight;
		focus.uniforms[ "waveFactor" ].value = 0.001;
		focus.uniforms[ "sampleDistance" ].value = 0.6;

		fxaa = new THREE.ShaderPass( THREE.FXAAShader )
		fxaa.uniforms[ "resolution" ].value.set(1 / (window.innerWidth / window.devicePixelRatio), 1 / (window.innerHeight / window.devicePixelRatio));
		# mirror = new THREE.ShaderPass( THREE.MirrorShader )
		# mirror.uniforms[ "screenWidth" ].value = window.innerWidth;
		# mirror.uniforms[ "screenHeight" ].value = window.innerHeight;
		# mirror.uniforms[ "waveFactor" ].value = 0.001;
		# mirror.uniforms[ "sampleDistance" ].value = 0.6;

		film = new THREE.FilmPass( 0.55, 0.015, 648, false )
		
		@focus = focus
		@film = film
		@vignette = vignette
		@vignette2 = vignette2
		@fxaa = fxaa

		rtParams = {
			minFilter: THREE.LinearFilter,
			magFilter: THREE.LinearFilter,
			format: THREE.RGBFormat,
			stencilBuffer: true
		}

		@renderPass = new THREE.RenderPass( @scene, @camera )

		@rendererTarget =  new THREE.WebGLRenderTarget(window.innerWidth*window.devicePixelRatio, window.innerHeight*window.devicePixelRatio
		@composer = new THREE.EffectComposer( @renderer, @rendererTarget, rtParams));
		@composer.addPass( @renderPass )
		@composer.addPass( @fxaa )
		# @composer.addPass( mirror )
		@composer.addPass( @vignette )
		@composer.addPass( @focus )
		@composer.addPass( @vignette2 )
		@composer.addPass( @film )
		film.renderToScreen = true

		SceneTraveler.getInstance().travelTo(new LoadScene(@stage))
		@lastTime = Date.now()

		window.focus()

		Constant.addGui()

		requestAnimationFrame( @animate )
		return

	animate:()=>
		if @pause
			t = Date.now()
			# dt = t - @lastTime
			@lastTime = t
			return
		
		# @focus.uniforms[ "waveFactor" ].value += 0.001;
		t = Date.now()
		dt = t - @lastTime
		requestAnimationFrame( @animate )

		SceneTraveler.getInstance().currentScene.update(dt)
		# @renderer.render( @scene, @camera )
		@renderer.setClearColor( Constant.setClearColor )
		@composer.render(0.01)
		@ambient.color.setHex( Constant.setClearColor )
		@lastTime = t

		return

	resize:()=>
		if @camera
			@renderer.setSize(window.innerWidth,window.innerHeight)
			@composer.setSize(window.innerWidth * window.devicePixelRatio, window.innerHeight * window.devicePixelRatio);
			@camera.aspect = window.innerWidth / window.innerHeight
			@camera.updateProjectionMatrix()
			@focus.uniforms[ "screenWidth" ].value = window.innerWidth*window.devicePixelRatio;
			@focus.uniforms[ "screenHeight" ].value = window.innerHeight*window.devicePixelRatio;
			@fxaa.uniforms[ "resolution" ].value.set(1 / (window.innerWidth / window.devicePixelRatio), 1 / (window.innerHeight / window.devicePixelRatio));


		return

$(document).ready ->
	main = new Main()
	
	$(window).blur(()->
		main.pause = true
		cancelAnimationFrame(main.animate)
	)

	$(window).focus(()->
		requestAnimationFrame( main.animate )
		main.lastTime = Date.now()
		main.pause = false
	)

	$(window).resize(()=>
		main.resize()
	)
	return