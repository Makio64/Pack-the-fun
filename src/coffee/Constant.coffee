class Constant

	@convexRatio = .0
	@convexEase = .45
	@brightnessEase = .45
	@vignette2Offset = .22
	@vignette2Darkness = 3.3
	@smoothBall = false
	@cameraZ = 400
	@clearColor = 0x051b32
	@hemiColor = 0xffffff
	@groundColor = 0xffffff
	@windSpeed = 2
	@windVertical = true

	@addGui:()->
		# Constant.gui = new dat.GUI()
		# Constant.gui.add(@,"convexRatio").min(0).max(30).step(0.001)
		# Constant.gui.add(@,"smoothBall")
		# Constant.gui.add(@,"vignette2Offset").min(0).max(10).step(0.01)
		# Constant.gui.add(@,"vignette2Darkness").min(0).max(100).step(.1)
		# Constant.gui.add(@,"cameraZ").min(0).max(2000).step(1)
		# Constant.gui.addColor(@,"clearColor")
		# Constant.gui.addColor(@,"hemiColor")
		# Constant.gui.addColor(@,"groundColor")
		# Constant.gui.add(@,"windSpeed").min(0).max(40).step(1)