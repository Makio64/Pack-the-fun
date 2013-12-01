class Fire extends THREE.Object3D

	constructor:()->
		@tick = 0
		@tickDuration = 130
		@particles = []
		THREE.Object3D.call(@)
		@k = 0
		return

	update:(dt)->
		@tick += dt
		if(@tick >= @tickDuration)
			@tick = 0
			@onTick()
		for i in [@particles.length-1..0] by -1
			p = @particles[i]
			p.update()
			if p.isDie()
				@remove(@particles.splice(i,1)[0])#.pop()
		
		return

	onTick:()->
		@addParticle()
		return

	addParticle:()->
		@k += M_2PI/20
		p = new FireParticle()
		p.position.set(Math.cos(@k)*50-150, 0, -1000 )
		@add(p)
		@particles.push(p)

		p = new FireParticle()
		p.position.set(Math.sin(@k)*50+150, 0, -1000 )
		@add(p)
		@particles.push(p)
		return
		

class FireParticle extends Triangle

	constructor:()->
		super 0xFFFFFF, .1
		@vx = 0
		@vy = 0
		@vz = 50
		@scale.set(.8,.8,.8)
		return

	update:()->
		# add velocity
		@position.set(@position.x+@vx,@position.y+@vy,@position.z+@vz)
		return

	isDie:()->
		return @position.z > 1000