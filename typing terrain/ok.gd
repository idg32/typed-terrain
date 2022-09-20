extends Spatial

var sample_hz = 22050.0 # Keep the number of samples to mix low, GDScript is not super fast.
var pulse_hz =Vector3(440.0,0.0,0.0)
var phase = 0.0
var nomrlz = 0.0
var playback: AudioStreamPlayback = null # Actual playback stream, assigned in _ready().
var time = 1
var iel = 1
var record = false
onready var record_set_device = get_node("RECORD")
var effect
var recording = null


func _fill_buffer(del):
	var increment = Vector3.ZERO
	increment = $MeshInstance.result / float($Control/Panel2/VBoxContainer/Count_Sample_HZ.text)
	time += 1 * float($Control/Panel2/VBoxContainer/Time_Delta.text)
	nomrlz = $MeshInstance.retry.length() * float($Control/Panel2/VBoxContainer/Piano_Len.text)
	if int(time) % int( clamp(abs(nomrlz),1.0,440.0 ) * int($MeshInstance.result.length() + 1)) == 1:
		iel += 1
		time = 2
	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		#playback.push_frame(Vector2.ONE * sin(phase * time) * float($MeshInstance.result.y) / (phase  + $MeshInstance.result.x)  )  # Audio frames are stereo.		
		playback.push_frame((Vector2.ONE * sin(phase * (TAU) - phase  - $MeshInstance.result.x) * time ) + (Vector2.ONE * cos(phase * time) * float($MeshInstance.result.y) / (phase  + $MeshInstance.result.x)  )) # Audio frames are stereo.
		phase =  (phase - increment.x /( increment.y +  1.0) * nomrlz / 3) - (333.0 / (iel / 100  + 1.0))# - float($Control/Panel/HSlider.value)
		phase += increment.z * del - increment.z
		phase -= increment.x / del / iel
		#phase -= int(nomrlz + 1 / TAU)
		#phase += pow(sin(increment.x - increment.y) + pow(increment.z,2) / cosh(increment.x - increment.y+ pow(increment.z,-1) * 2),PI * 2)# * float($Control/Panel2/VBoxContainer/Piano_Len.text)
		to_fill -= 1
		$Control/Panel/Label.text = str(nomrlz)
	iel %= int(max(int($Control/Panel2/VBoxContainer/Oscilator_Scaling.text),1.0))
	iel += 1

func _process(_delta):
	$Player.set_volume_db(float($Control/Panel/HSlider.value))
	$RECORD.set_volume_db(float($Control/Panel/HSlider.value))
	
	_fill_buffer(_delta)
	if effect.is_recording_active():
		recording = effect.get_recording()
#	recordingeffectmaster.set_recording_active(false)  #to stop recording
	 #I would set the path with a filedialog 
	
	if Input.is_action_just_released("save") && recording != null:
		save_game()

	# We get the index of the "Record" bus.
func save_game():
	var save_path = "user://" + str($Control/TextEdit.text.split(" ")[0]) + str(nomrlz)
	print(save_path)
	print(recording.save_to_wav(save_path))
	get_node("Control/Panel3/RichTextLabel").text = "RECORDING, SAVED! \n"	
	recording = null

func _ready():
	$Player.stream.mix_rate = sample_hz # Setting mix rate is only possible before play().
	playback = $Player.get_stream_playback()
#	_fill_buffer() # Prefill, do before play() to avoid delay.
	$Player.play(0.0)
	# And use it to retrieve its first effect, which has been defined
	# as an "AudioEffectRecord" resource.
	effect = AudioServer.get_bus_effect(0,0)
	print(effect)


func _on_Button_button_up():
	record = true
	effect.set_recording_active(record)
	print(record)
	$Timer.set_wait_time($Player.stream.get_length())
	$Timer.start()
	get_node("Control/Panel3/RichTextLabel").text = "RECORDING -> " + str(record) + "\n"


func _on_Save_pressed():
	save_game()


func _on_Timer_timeout():
	if record: 		
		record = false
		effect.set_recording_active(record)
		get_node("Control/Panel3/RichTextLabel").text = "RECORDING -> " + str(record) + "\n"
