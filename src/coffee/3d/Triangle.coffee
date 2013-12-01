class Triangle extends THREE.Mesh

	@initGeometry3D = ()->
		geometry = new THREE.CylinderGeometry(0, 100, 100, 4, false)
		# geometry.faceVertexUvs.splice(9,4)
		# geometry.faces.splice(9,4)		

		geometry.elementsNeedUpdate = true
		geometry.uvsNeedUpdate = true

		m = new THREE.Matrix4()
		m.makeTranslation(1,100,1)
		geometry.applyMatrix(m)
		geometry2 = new THREE.CylinderGeometry(0, 100, -100, 4, false)
		# geometry2.faceVertexUvs.splice(9,4)
		# geometry2.faces.splice(9,4)		

		THREE.GeometryUtils.merge(geometry,geometry2)

		# geometry3 = new THREE.CylinderGeometry(0, 60, 60, 4, false)
		# m = new THREE.Matrix4()
		# m.makeTranslation(1,60,1)
		# geometry3.applyMatrix(m)
		# geometry3.faceVertexUvs.splice(9,3)
		# geometry3.faces.splice(9,3)		

		# geometry4 = new THREE.CylinderGeometry(0, 60, -60, 4, false)
		# geometry4.faceVertexUvs.splice(9,3)
		# geometry4.faces.splice(9,3)		
		# THREE.GeometryUtils.merge(geometry3,geometry4)

		# THREE.GeometryUtils.merge(geometry,geometry3)
		geometry.computeCentroids()
		geometry.mergeVertices()
		geometry.computeFaceNormals()
		geometry.computeVertexNormals()
		geometry.computeBoundingSphere()
		geometry.computeMorphNormals()
		geometry.computeTangents()
		geometry.computeBoundingSphere()
		return geometry

	@initGeometry2D = ()->

		geometry = new THREE.Geometry()
		geometry.vertices.push( new THREE.Vector3( 100, 0, 0 ) )
		geometry.vertices.push( new THREE.Vector3( -100, 0, 0 ) )
		geometry.vertices.push( new THREE.Vector3( 0, 100, 0 ) )

		face 	= new THREE.Face3( 0, 2, 1 )

		geometry.faces.push( face )
		
		geometry.faceVertexUvs[0].push([
			new THREE.Vector2(0, 0),
			new THREE.Vector2(1, 0),
			new THREE.Vector2(0, 1)
		]);

		geometry.computeCentroids()
		geometry.mergeVertices()
		geometry.computeFaceNormals()
		geometry.computeVertexNormals()
		geometry.computeBoundingSphere()
		geometry.computeMorphNormals()
		geometry.computeTangents()
		geometry.computeBoundingSphere()

		return geometry


	@geometry2D = Triangle.initGeometry2D()
	@geometry3D = Triangle.initGeometry3D()
	@materials = {}

	constructor:(color = 0xff0000*Math.random(),opacity=.3, is3D = null, f1 = 100,f2 = -100,f3 = 100,f4=0)->

		is3D ?= Math.random()>.5

		if !is3D
			geometry = Triangle.geometry2D
		else 
			geometry = Triangle.geometry3D

		# s = color+"_"+opacity
		# if Triangle.materials[s] != undefined
		# 	@material = Triangle.materials.s
		# else
		# 	Triangle.materials[s] = @material

		@material = new THREE.MeshBasicMaterial({ color:color, opacity:opacity})
		@material.blending = THREE[ "CustomBlending" ];
		@material.blendSrc = THREE[ "SrcAlphaFactor" ];
		@material.blendDst = THREE[ "OneFactor" ];
		@material.transparent = true;

		THREE.Mesh.call(@, geometry, @material)