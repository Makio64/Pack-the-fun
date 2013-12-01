class Package extends THREE.Object3D

	constructor:()->
		THREE.Object3D.call(@)

		geometry = new THREE.CubeGeometry(100,10,100,1,1,1)
		material = new THREE.MeshBasicMaterial({color:0xFF0000,opacity:0,transparent:true})
		# material.blending = THREE[ "CustomBlending" ];
		# material.blendSrc = THREE[ "SrcAlphaFactor" ];
		# material.blendDst = THREE[ "OneFactor" ];

		bottom = new THREE.Mesh(geometry,material)
		bottom.position.y = -200

		top = new THREE.Mesh(geometry,material)
		top.position.y = 200

		left = new THREE.Mesh(geometry,material)
		left.rotation.z = Math.PI/2
		left.position.x = -200

		right = new THREE.Mesh(geometry,material)
		right.rotation.z = Math.PI/2
		right.position.x = 200

		front = new THREE.Mesh(geometry,material)
		front.rotation.x = Math.PI/2
		front.position.z = -200

		back = new THREE.Mesh(geometry,material)
		back.rotation.x = Math.PI/2
		back.position.z = 200

		TweenLite.to(front.position,1.1,{z:-45,ease:Sine.easeOut})
		TweenLite.to(back.position,1.1,{z:45,ease:Sine.easeOut})

		TweenLite.to(left.position,1.1,{x:-45,ease:Sine.easeOut})
		TweenLite.to(right.position,1.1,{x:45,ease:Sine.easeOut})
		
		TweenLite.to(bottom.position,1.1,{y:-45,ease:Sine.easeOut})
		TweenLite.to(top.position,1.1,{y:45,ease:Sine.easeOut})
		
		TweenLite.to(material,1.1,{opacity:.75})

		@add(bottom)
		@add(top)
		@add(front)
		@add(back)
		@add(left)
		@add(right)


		geometry = new THREE.CubeGeometry(110,10,10,1,1,1)
		material = new THREE.MeshBasicMaterial({color:0xFFFFFF,opacity:0,transparent:true})
		# material.blending = THREE[ "CustomBlending" ];
		# material.blendSrc = THREE[ "SrcAlphaFactor" ];
		# material.blendDst = THREE[ "OneFactor" ];

		bottom = new THREE.Mesh(geometry,material)
		bottom.position.y = -210

		top = new THREE.Mesh(geometry,material)
		top.position.y = 210

		left = new THREE.Mesh(geometry,material)
		left.rotation.z = Math.PI/2
		left.position.x = -210

		right = new THREE.Mesh(geometry,material)
		right.rotation.z = Math.PI/2
		right.position.x = 210
		
		left2 = new THREE.Mesh(geometry,material)
		left2.rotation.y = Math.PI/2
		left2.position.x = -210

		right2 = new THREE.Mesh(geometry,material)
		right2.rotation.y = Math.PI/2
		right2.position.x = 210


		front = new THREE.Mesh(geometry,material)
		front.rotation.x = Math.PI/2
		front.position.z = -210

		back = new THREE.Mesh(geometry,material)
		back.rotation.x = Math.PI/2
		back.position.z = 210

		TweenLite.to(front.position,1.2,{delay:.4, z:-50 ,ease:Quad.easeOut})
		TweenLite.to(back.position,1.2,{delay:.4, z:50, ease:Quad.easeOut})

		TweenLite.to(left.position,1.2,{delay:.4, x:-50 ,ease:Quad.easeOut})
		TweenLite.to(right.position,1.2,{delay:.4, x:50, ease:Quad.easeOut})

		TweenLite.to(left2.position,1.2,{delay:.4, x:-50 ,ease:Quad.easeOut})
		TweenLite.to(right2.position,1.2,{delay:.4, x:50, ease:Quad.easeOut})
		
		TweenLite.to(bottom.position,1.2,{delay:.4, y:-50 ,ease:Quad.easeOut})
		TweenLite.to(top.position,1.2,{delay:.4, y:50, ease:Quad.easeOut})
		
		TweenLite.to(material,.7,{delay:.6, opacity:.75})

		@add(bottom)
		@add(top)
		@add(front)
		@add(back)
		@add(left)
		@add(right)
		@add(left2)
		@add(right2)

		@rotation.z = Math.PI/2
		
		return
