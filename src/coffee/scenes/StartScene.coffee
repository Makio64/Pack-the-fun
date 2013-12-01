# This scene is an example
class StartScene extends AScene

	constructor:(stage)->
		super(stage)

		@state = 0
		@pause = true

		# START HERE
		@camera = main.camera
		@renderer = main.renderer
		@scene = main.scene
		@focus = main.focus
		@vignette = main.vignette
		@vignette2 = main.vignette2

		@camera.position.y = 150
		@camera.position.x = 0
		@camera.lookAt(@scene.position)

		# @hemiLight = new THREE.HemisphereLight( 0xffffff, 0xffffff, 0.6 );
		# @hemiLight.color.setHSL( 1, 1, 1 );
		# @hemiLight.groundColor.setHSL( 1, 1, 1 );
		# @hemiLight.position.set( 0, 200, 0 );
		# @scene.add( @hemiLight )	

		@pointLight = new THREE.PointLight( 0xFFFFFF, .7, 200)
		@pointLight.position.set( 100 , 30, 0)
		@scene.add( @pointLight )
		
		@pointLight = new THREE.PointLight( 0xFFFFFF, .7, 200)
		@pointLight.position.set( -100 , 30, 0)
		@scene.add( @pointLight )

		@pointLight = new THREE.PointLight( 0xFFFFFF, 1, 200)
		@pointLight.position.set( 0 , 100, 140)
		@scene.add( @pointLight )
		
		groundGeo = new THREE.PlaneGeometry( 10000, 10000, 100, 100 );
		for v in groundGeo.vertices
			v.z += Math.random()*40
			if Math.random() < 0.04 and Math.abs(v.z)+Math.abs(v.x)+Math.abs(v.y) > 900
				v.z += 50+Math.random()*300

		groundGeo.dynamic = true
		groundGeo.verticesNeedUpdate = true;
			
			
		groundMat = new THREE.MeshBasicMaterial( { color: 0xFFFFFF } );

		ground = new THREE.Mesh( groundGeo, groundMat );
		ground.rotation.x = -Math.PI/2;
		ground.position.y = -150;
		@scene.add( ground );
		@ground = ground

		ground2 = new THREE.Mesh( groundGeo, groundMat );
		ground2.rotation.x = -Math.PI/2;
		ground2.position.y = -150;
		ground2.position.z = -5000;
		@scene.add( ground2 );
		@ground2 = ground2

		# @trees = []

		# @gift = new Gift()
		# @gift.position.y += 50
		# @scene.add @gift
		# @moon = new Moon()
		# @moon.position.set(0,50,-400)
		# @scene.add @moon
		@wind = new Wind()
		@scene.add @wind
		# @fire = new Fire()
		@head = new Head()
		@scene.add(@head)
		@hammer = new Hammer(@)
		@scene.add(@hammer)
		# @scene.add @fire

		@mouseX = window.innerWidth / 2
		@mouseY = window.innerHeight / 2
		@camera.lookAt(@scene.position)

		@music = new Snd("./sfx/snow.mp3")
		@music.volume = 0
		@music.play()
		TweenLite.to(@music,2,{volume:0.3})
		@analyser = SndFX.instance.createAnalyser()
		@jsNode = SndFX.instance.createJavaScript()
		@jsNode.onaudioprocess = @onaudioprocess
		@analyser.connect(@jsNode)
		@music.connectTo(@analyser,false,false)
		
		document.addEventListener("mousemove",@mouseMove,false)
		document.addEventListener("mousedown",@mouseDown,false)

		return

	packGift:()=>
		@package = new Package()
		@scene.add(@package)
		TweenLite.to(Constant,1.3,{delay:.1,cameraZ : 200})
		Constant.vignette2Offset = 1.08
		Constant.vignette2Darkness = 0
		# TweenLite.to(Constant,1.2,{delay:convexRatio : 0.1})
		@ready = false
		TweenLite.to(@music,.5,{volume:0})
		$("#slogan").addClass("activate")
		fx = new Snd("./sfx/clear.mp3")
		fx.play()
		return

	mouseDown:(e)=>
		@hammer.hit(@onHit)
		# @fx.play()
		return

	onHit:()=>
		@head.hit(@hammer)
		Constant.convexRatio = 0.325
		return


	mouseMove:(e)=>
		@mouseX = e.pageX
		@mouseY = e.pageY
		return

	onEnter:()->		
		return

	update:(dt)=>
		if @pause 
			return

		# @hemiLight.color.setHex( Constant.hemiColor );
		# @hemiLight.groundColor.setHex( Constant.groundColor );

		# @ground.position.z+=20;
		# @ground2.position.z+=20;

		# if @ground.position.z == 5000
		# 	@ground.position.z = 1000
		# if @ground2.position.z == 5000
		# 	@ground2.position.z = 1000

		
		@vignette2.uniforms[ "offset" ].value += (Constant.vignette2Offset-@vignette2.uniforms[ "offset" ].value)*.16;
		@vignette2.uniforms[ "darkness" ].value += (Constant.vignette2Darkness-@vignette2.uniforms[ "darkness" ].value)*.16;
		
		Constant.convexRatio += (0.00-Constant.convexRatio)*0.09

		@head.update(@hammer)
		@wind.update(dt)
		# @fire.update(dt)
		# @gift.update(dt)
		# x = window.innerWidth - @mouseX
		@camera.position.x += ((@mouseX/window.innerWidth)*600-300 - @camera.position.x)*0.05
		@camera.position.y += ((@mouseY/window.innerHeight)*400 - @camera.position.y)*0.05
		@camera.position.z += (Constant.cameraZ-@camera.position.z) * 0.05
		@camera.lookAt(@scene.position)
		# @camera.position.set()

		# for t in @trees
		# 	t.update(dt)
		# 	t.position.z += 10
		# 	if t.position.z > 300
		# 		t.position.set(Math.random()*700-350,0,-800)
		# 		t.restart()
		# 		t.height = 0
			
		return

	onaudioprocess:()=>

		@pause = false

		array =  new Uint8Array(@analyser.frequencyBinCount)
		@analyser.getByteFrequencyData(array)
		average = @getAverage(array)

		# array2 =  new Uint8Array(@analyser.frequencyBinCount)
		# @analyser.getByteFrequencyData(array2)
		# average2 = @getAverage(array2)
		# if average > 30 and @trees.length < 10
		# 	t = new Tree()
		# 	t.position.set(Math.random()*700-350,0,-800)
		# 	@scene.add t
		# 	@trees.push t
			# @wind.addParticle()
		# for t in @trees
		# 	t.height += (average-t.height)*.12

		# if Constant.smoothBall
		# 	scale = @gift.scale.x+(average/70-@gift.scale.x)*.15
		# 	@gift.scale.set(scale,scale,scale)
		# else
		# 	scale = average/70
		# 	@gift.scale.set(scale,scale,scale)
		@vignette.uniforms[ "darkness" ].value += (average*.2-@vignette.uniforms[ "darkness" ].value)*Constant.brightnessEase;
		# @vignette.uniforms[ "offset" ].value += (average*.002-@vignette.uniforms[ "offset" ].value)*.45;
		@focus.uniforms[ "waveFactor" ].value += (average*Constant.convexRatio-@focus.uniforms[ "waveFactor" ].value)*Constant.convexEase;
		# @camera.position.z += (average*15-@camera.position.z)*.05;
		@camera.fov += (45+average*2.8-@camera.fov)*.65;
		# console.log @camera.fov

		# if average == 0 and @state != 0
		# 	Constant.vignette2Offset = 10
		# 	Constant.vignette2Darkness = 100

		# First note
		if average > 0 and @state == 0
			@state = 1
			@hammer.open()
		

		# console.log average, average2
		return
	
	getAverage:(array)->
		values = 0

		for i in [0...array.length] by 1
			values += array[i]

		return values / array.length