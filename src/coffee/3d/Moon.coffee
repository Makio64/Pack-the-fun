class Moon extends THREE.Mesh
	
	constructor:()->
		@geometry = new THREE.SphereGeometry(120,30,30)
		@material = new THREE.MeshBasicMaterial({color:0, opacity:1})
		THREE.Mesh.call(@, @geometry, @material)
		return

	dispose:()=>
		@geometry = null
		@material = null
		super
		return

