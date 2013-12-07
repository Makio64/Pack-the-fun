class Hammer extends THREE.Object3D

	constructor:(@scene)->
		@limit = 140
		@state = "x"

		THREE.Object3D.call(@)

		geometry = new THREE.CubeGeometry(180,60,60,1,1,1)
		geometry2 = new THREE.CubeGeometry(20,150,150,1,1,1)
		m = new THREE.Matrix4()
		m.makeTranslation(-100,1,1)
		geometry2.applyMatrix(m)
		THREE.GeometryUtils.merge(geometry,geometry2)

		@material = new THREE.MeshBasicMaterial({color:0,opacity:0,transparent:true})
		
		@left = new THREE.Mesh(geometry,@material)
		@left.position.x = -@limit-80
		@left.rotation.z = Math.PI
		@add(@left)

		@right = new THREE.Mesh(geometry,@material)
		@right.position.x = @limit+80
		@add(@right)

		@blocked = true
		
		return

	open:()->
		TweenLite.to(@material,.6,{delay:1.6, opacity:.2,onComplete:()=>
			@blocked = false
		})
		TweenLite.to(@left.position,.7,{delay:1.6, x : -@limit-30})
		TweenLite.to(@right.position,.7,{delay:1.6, x : @limit+30})


	hit:(callback)->
		if @blocked
			return
		if @state == "x"
			@limit -= 10
		@fx = new Snd("./sfx/machine.mp3")
		@fx.play()

		@blocked = true
		TweenLite.to(@right.position,.3,{x:@limit,onComplete:callback,ease:Quad.easeOut})
		TweenLite.to(@right.position,.7,{x:@limit+30,delay:.3,onComplete:@unlock,ease:Quad.easeOut})
		TweenLite.to(@left.position,.3,{x:-@limit,ease:Quad.easeOut})
		TweenLite.to(@left.position,.7,{x:-@limit-30,delay:.3,ease:Quad.easeOut})

		return


	unlock:()=>
		switch(@state)
			when "x"
				@state = "y"
				TweenLite.to(@rotation,.4,{z:Math.PI/2})
		
			when "y"
				@state = "z"
				TweenLite.to(@rotation,.4,{z:0,y:Math.PI/2})

			when "z"
				@state = "x"
				@limit -= 30
				TweenLite.to(@rotation,.4,{y:0})
	
		if @limit <= 100
			@scene.packGift()
			TweenLite.to(@material,.6,{delay:.1,opacity:0})
			TweenLite.to(@left.position,.7,{x : -@limit-80})
			TweenLite.to(@right.position,.7,{x : @limit+80})
		else
			@blocked = false