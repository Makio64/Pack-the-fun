class Tree extends THREE.Object3D

	constructor:()->
		# @tick = 0
		# @tickDuration = 250
		@particles = []
		THREE.Object3D.call(@)

		angle = 0 
		step = M_2PI/6
		radius = 0
		radiusStep = .3

		@height = 0

		for i in [0...60] by 1
			@addParticle(angle,radius)
			angle += step
			# if i%6==0
			radius += radiusStep * 6
		
		return

	update:(dt)->
		# @tick += dt
		# if(@tick >= @tickDuration)
		# 	@tick = 0
		# 	@onTick()

		# @height = 2
		cHeight = 0
		k = 0
		stepHeight = @height/6

		for i in [@particles.length-1..0] by -1
			p = @particles[i]
			p.update()
			p.targetY = cHeight
			k++
			# if k%6==0
			cHeight += stepHeight
			# if p.isDie()
			# 	@remove(@particles.splice(i,1)[0])#.pop()
		
		return

	restart:()->
		for p in @particles
			p.position.y = 0

	onTick:()->
		@addParticle()
		return

	addParticle:(angle,radius)->
		p = new TreeParticle(angle,radius)
		@add(p)
		@particles.push(p)
		return
		

class TreeParticle extends Triangle

	constructor:(@angle,@radius)->
		# if Math.random()<.2
		super 0xFFFFFF, 1
		# else
		#	super 0x00FF00, .5
		# @vy = 0# .5
		# @angle = 0
		# @radius = 30
		@targetY = 0
		# @vz = 10
		@scale.set(.01,.01,.01)
		@update()
		return

	update:()->
		@angle += Math.PI/120
		# @radius -= .1
		# add velocity
		y = @position.y+(@targetY-@position.y)*.05
		@position.set(Math.cos(@angle)*@radius,y,Math.sin(@angle)*@radius)
		return

	isDie:()->
		return @radius <= 0