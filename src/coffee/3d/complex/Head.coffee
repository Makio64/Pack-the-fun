class Head extends THREE.Object3D

	constructor:()->
		loader = new THREE.JSONLoader();
		callback = ( geometry, materials ) =>
			@createScene( geometry, materials, 0, 0, 0 )
		loader.load( "./img/model/Mario64.js", callback )

		THREE.Object3D.call(@)
		@k = 0
		@ready = false
		return

	createScene:( geometry, materials, x, y, z, b )=>

		colors = [0xbe0000,0xFFFFFF,0xfddfad,0x6f4b33,0xFFFFFF,0xFF0000,0x6d0000,0x440000]
		for i in [0...geometry.faces.length] by 1
			f = geometry.faces[ i ]
			f.color.setHex( colors[f.materialIndex] );
		shader = THREE.MarioShader
		@uniforms = THREE.UniformsUtils.clone( shader.uniforms )
		@material = new THREE.ShaderMaterial(
			fragmentShader: shader.fragmentShader
			vertexShader: shader.vertexShader
			uniforms: @uniforms
			transparent: true
			vertexColors: THREE.FaceColors
			color: 0xffffff
			ambient: 0xffffff
			lights: true
			opacity: 0
		)

		m = new THREE.Matrix4()
		m.multiplyScalar( 43 )
		geometry.applyMatrix(m)

		@head = new THREE.Mesh( geometry, @material )
		@head.geometry.colorsNeedUpdate = true
		@head.position.set( x, y-40, z )
		@head.scale.set(.01,.01,.01)
		@add( @head )
		TweenLite.to(@head.rotation,1.3,{delay:.85, y : Math.PI*8,onComplete:()=>
			@ready = true
		})
		TweenLite.to(@head.position,1.1,{delay:.85, y : y,ease:Back.easeOut,onStart:()->
			new Snd("./sfx/woohoo.mp3",{autoplay:true})
		})
		TweenLite.to(@material,.4,{delay:.85, opacity:1})
		TweenLite.to(@head.scale,.6,{delay:.85, x:1, y:1, z:1, ease:Back.easeOut})

	hit:(hammer)=>
		#maxX = Math.min((hammer.right.position.x-100), @uniforms["maxX"].value)
		#TweenLite.to(@uniforms["maxX"],1.8,{ease:Back.easeOut,value:maxX})
		#minX = Math.max((hammer.left.position.x+100), @uniforms["minX"].value)
		#@uniforms["minX"].value = 
		# @head.uniforms["maxZ"].value -= .1
		# @head.uniforms["minZ"].value += .1 
		# @head.uniforms["maxY"].value -= .1
		# @head.uniforms["minY"].value += .1 
	
	update:(hammer)=>
		@k+=.05
		if !@ready
			return
		
		@position.y += Math.sin(@k)*.2
		switch hammer.state
			when "x"
				maxX = Math.min((hammer.right.position.x-100), @uniforms["maxX"].value)
				minX = Math.max((hammer.left.position.x+100), @uniforms["minX"].value)
				@uniforms["maxX"].value = maxX
				@uniforms["minX"].value = minX
				break
			when "y"
				maxY = Math.min((hammer.right.position.x-100), @uniforms["maxY"].value)
				minY = Math.max((hammer.left.position.x+100), @uniforms["minY"].value)
				@uniforms["maxY"].value = maxY
				@uniforms["minY"].value = minY
				break
			when "z"
				maxZ = Math.min((hammer.right.position.x-100), @uniforms["maxZ"].value)
				minZ = Math.max((hammer.left.position.x+100), @uniforms["minZ"].value)
				@uniforms["maxZ"].value = maxZ
				@uniforms["minZ"].value = minZ
				break

