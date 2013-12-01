class Gift extends THREE.Mesh

	constructor:()->
		@geometry = new THREE.SphereGeometry(30,20,20)

		# Shaders
		shader = THREE.SpiritShader
		console.log shader
		@uniforms = THREE.UniformsUtils.clone( shader.uniforms )
		@uniforms[ "tDiffuse" ].value = THREE.ImageUtils.loadTexture( "./img/textures/crystal-13.jpg" )

		@material = new THREE.ShaderMaterial(
			fragmentShader: shader.fragmentShader
			vertexShader: shader.vertexShader
			uniforms: @uniforms
			transparent: true
		)


		# @material = new THREE.MeshBasicMaterial({color:0xFFFFFF, opacity:.4})
		THREE.Mesh.call(@, @geometry, @material)
		return

	update:()->
		@uniforms["iGlobalTime"].value++
		return

	dispose:()=>
		@geometry = null
		@material = null
		super
		return