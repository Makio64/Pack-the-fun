class Wind extends THREE.Object3D

	constructor:()->
		@tick = 0
		@tickDuration = 30
		@particles = []
		THREE.Object3D.call(@)
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
		p = new WindParticle()
		
		if Constant.windVertical
			p.position.x = Math.random()*900 - 450
			p.position.y = Math.random()*800+400
			p.position.z = Math.random()*900 - 350
		else
			p.position.x = Math.random()*700 - 350
			p.position.y = Math.random()*400
			p.position.z = -1000

		@add(p)
		@particles.push(p)
		return
		

class WindParticle extends Triangle

	constructor:()->
		super 0xFFFFFF, .2
		if Constant.windVertical
			@vx = Math.random()*.2 
			@vy = -Constant.windSpeed#Math.random()*10 - 5
			@vz = 0
		else
			@vx = 0#Math.random()*10 - 5
			@vy = 0#Math.random()*10 - 5
			@vz = Constant.windSpeed
		@scale.set(.07,.07,.07)
		return

	update:()->
		# add velocity
		@position.set(@position.x+@vx,@position.y+@vy,@position.z+@vz)
		return

	isDie:()->
		if Constant.windVertical
			return @position.y < -100
		else
			return @position.z > 1000