class LoadScene extends AScene


	constructor:(stage)->
		super(stage)
		return


	onEnter:()->
		@loadData()
		return

	loadData:()=>
		loader = new THREE.JSONLoader();
		loader.load( "./img/model/Mario64.js", @loadSound )
		return

	loadSound:()=>
		urlList = [
			"./sfx/snow.mp3"
			"./sfx/machine.mp3"
			"./sfx/woohoo.mp3"
			"./sfx/ooh.mp3"
			"./sfx/clear.mp3"
		]
		SndFX.instance.load(urlList,@onSoundLoaded)
		return


	onSoundLoaded:()=>
		$("#loading .t2").addClass("activate")#.html("CLICK TO OPEN IT! ^_^")
		$("#loading .t1").addClass("removed")
		document.addEventListener("click",@onClick, false)
		return

	onClick:()=>
		document.removeEventListener("click",@onClick, false)
		$("#loading").addClass("removed")
		$("#loading2").addClass("removed")
		setTimeout(@travel,350)
		return

	travel:()=>
		SceneTraveler.getInstance().travelTo(new StartScene(@stage))