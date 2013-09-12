createTextCanvas = (text, color='black', font='Tahoma', size=20) ->
  cvs = document.createElement 'canvas'
  ctx = cvs.getContext '2d'
  ctx.font = "#{size}px #{font}"
  cvs.width = ctx.measureText(text).width
  cvs.height = Math.ceil size
  ctx.font = "#{size}px #{font}"
  ctx.fillStyle = color
  ctx.fillText text, 0, Math.ceil size*0.8
  cvs

createText2D = (text, color, font, size, segW, segH) ->
  cvs = createTextCanvas text, color, font, size
  tex = new THREE.Texture cvs
  tex.needsUpdate = yes
  msh = new THREE.Mesh(
    new THREE.PlaneGeometry( cvs.width, cvs.height, segW, segH ),
    new THREE.MeshBasicMaterial( map: tex, color: 0xffffff, transparent: true ))
  msh.scale.set 0.25, 0.25, 0.25
  msh.doubleSided = yes
  msh

renderer = new THREE.WebGLRenderer( antialias: true )
w = window.innerWidth
h = window.innerHeight
renderer.setSize w, h
document.body.appendChild renderer.domElement
renderer.setClearColorHex 0xffffff, 1.0

camera = new THREE.PerspectiveCamera 45, w/h, 1, 10000
camera.position.z = 220
camera.position.x = 0
camera.position.y = 15

scene = new THREE.Scene()
scene.fog = new THREE.FogExp2 0xffffff, 0.0035
scatterPlot = new THREE.Object3D()
scene.add scatterPlot
scatterPlot.rotation.y = 0.5

transForm = (x, y, z) ->
  [100*(x-0.5), 100*(y-0.5), 100*(0.5-z)]
newVertex = (x, y, z) ->
  new THREE.Vertex new THREE.Vector3 transForm(x, y, z)...
addLines = (vs, c=0x000000, lw=1, o3d=scatterPlot) ->
  lineGeo = new THREE.Geometry()
  for vx in vs
    lineGeo.vertices.push newVertex vx...
  line = new THREE.Line lineGeo, new THREE.LineBasicMaterial( color: c, lineWidth: lw )
  line.type = THREE.Lines
  o3d.add line
addLabel = (l, x, y, z, r=0, o3d=scatterPlot) ->
  l2d = createText2D l
  [ l2d.position.x, l2d.position.y, l2d.position.z ] = transForm x, y, z
  l2d.rotation.y = -Math.PI * r
  o3d.add l2d

vs = []
# Unit cube
for p in [[0,0,0], [0,1,1], [1,0,1], [1,1,0]]
  for i in [0..2]
    q = p[..]
    q[i] = (p[i] + 1) % 2
    vs.push vx for vx in [p,q]
# Line ticks with labels
for i in [0..2]
  for p, j in [[i/2,0,-0.05], [1.02,i/2,0], [-0.05,0,i/2]]
    q = p[..]
    k = if j is 0 then 2 else 0
    q[k] += 0.03
    vs.push vx for vx in [p,q]
    r = p[..]
    r[k] = if r[k]>1 then 1.1 else -0.1
    addLabel (i/2).toString(), r..., if j is 0 then 0.5 else 0
addLines vs, 0x808080

s = 1.25
# Cuts of hyperplane x+y+z=s with unit cube
vs = []
for i in [0..2]
  for k in [0..1]
    for j in [0..2] when j isnt i
      p = [s-1,s-1,s-1]
      p[i] = k
      p[j] = 1-k
      vs.push p
addLines vs

pointCount = 16384
pointGeo = new THREE.Geometry()
rfs = randFixedSum 3, pointCount, s, 0, 1
for rs, i in rfs
   [x, y, z] = transForm rs...
   pointGeo.vertices.push new THREE.Vertex new THREE.Vector3 x,y,z
   pointGeo.vertices[i].angle = Math.atan2 z,x
   pointGeo.vertices[i].radius = Math.sqrt x*x+z*z
   pointGeo.vertices[i].speed = (z/100)*(x/100)
   pointGeo.colors.push new THREE.Color().setHSV (x+50)/100, (z+50)/100, (y+50)/100
points = new THREE.ParticleSystem pointGeo, new THREE.ParticleBasicMaterial( vertexColors: yes, size: 1.0 )
scatterPlot.add points

renderer.render scene, camera
paused = false
last = new Date().getTime()
down = false
sx = 0
sy = 0

window.onmousedown = (ev) ->
  down = yes
  sx = ev.clientX
  sy = ev.clientY
window.onmouseup = () ->
  down = no
window.onmousemove = (ev) ->
  if down
    dx = ev.clientX - sx
    dy = ev.clientY - sy
    scatterPlot.rotation.y += dx*0.01
    camera.position.y += dy
    sx += dx
    sy += dy
animating = no
window.ondblclick = () ->
  animating = !animating
animate = (t) ->
  if !paused
    last = t
    if animating
      for u in pointGeo.vertices
        u.angle += u.speed * 0.01
        u.position.x = Math.cos(u.angle)*u.radius
        u.position.z = Math.sin(u.angle)*u.radius
      pointGeo.__dirtyVertices = true
    renderer.clear()
    camera.lookAt scene.position
    renderer.render scene, camera
  window.requestAnimationFrame animate, renderer.domElement
animate new Date().getTime()
onmessage = (ev) ->
  paused = (ev.data is 'pause')
