extends MeshInstance


onready var txt_listing = [
	{
		"1": 0,
		"2": 1,
		"3": 2,		
		"A": 0.1,
		"B": 0.4,
		"C": 0.3,
		"D": 0.7,
		"E": 0.13,
		"F": 0.46,
		"G": 0.78,
		"H": 0.3,
		"I": 0.479,
		"J": 0.3,
		"K": 0.701,
		"L": 0.97,
		"M": 0.1187,
		"N": 0.78901,
		"O": 0.3,
		"P": 0.6,
		"Q": 0.789101,
		"R": 0.7987356,
		"S": 0.13542,
		"T": 7.8,
		"U": 3.5,
		"V": 9.7,
		"W": 1.7,
		"X": 3.4,
		"Y": 7.0,
		"Z": 2.0,
		" ": 0.0,
		"": 0.0,
		"'": -3.0,
		"!": -5.7,
		".": -1.3
	}
]

var time = 1
var iel = 0.1

var result = Vector3(0.0,0.1,0.2)
var ersele = Vector3(1.0,1.0,1.0)

var retry = Vector3.ZERO 
onready var decision = [
	1,
	2,
	3
]
onready var trial = 0

func check_for_number(txt):
	trial = decision[int(txt + 3.02) % 3]

func parse_the_text(txt):
	var parsing = [""]
	for numb in range(0,txt.length()):
		parsing.push_back(txt[numb])
		if txt[numb] is int:
			check_for_number(txt)
	return parsing

func decimator(amt):
	if trial == 1:
		return Vector3(amt,0.0,0.0)
	elif trial == 2:
		return Vector3(0.0,amt,0.0)
	elif trial == 3:
		return Vector3(0.0,0.0,amt)

func _process(delta):
#		playback.push_frame(Vector2.ONE * sin(phase * TAU)) # Audio frames are stereo.
#		playback2.push_frame(Vector2.ONE * sin(phase2 * PI)) # Audio frames are stereo.
	mesh.surface_get_material(0).set_shader_param("com_txt",lerp(mesh.surface_get_material(0).get_shader_param("com_txt"),result, 0.0012))	
	#mesh.surface_get_material(0).set_shader_param("com_txt",lerp(mesh.surface_get_material(0).get_shader_param("com_txt"),Vector3((result.x),result.y,pow(result.z,1.0/3.0)), 0.03))
	#scale_object_local(lerp(Vector3.ZERO,ersele,0.0001378))


func set_uniform_com_txt(letter):
	ersele = Vector3.ZERO
	retry = Vector3(0.0,0.0,0.0)
	var parsing = parse_the_text(letter.to_upper())
	for numb in range(0,parsing.size()):
		if txt_listing[0].has(parsing[numb]) :
			var deci = floor(rand_range(-1.0,1.0))
			if deci == 0: deci+= 1.0
			check_for_number(txt_listing[0][parsing[numb]])		
			retry += decimator(txt_listing[0][parsing[numb]] * 1.5)
	result = Vector3(retry.x,clamp(retry.y,0.0,30.0),retry.z)
	print(result)
	ersele = Vector3(float((int(retry.x) / 13) % 13 + 1),1.0 ,float(int(parsing.size()) % 12 + 1))
	#result /= ersele * 0.03
	print(ersele)
	result = Vector3(result.x - result.z * float(time / 3),result.y - result.z / 222.0,0.0)
	result.x = (1.0 * sin(result.x* TAU))
	result.z = 0.0
	result.y = (1.0 * sin(result.y * PI))
#	look_at(get_parent().translation,Vector3.UP)


