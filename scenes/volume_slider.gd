extends HSlider

@export
var initial_value: float
@export 
var bus_name: String

var bus_index: int

func _ready() -> void:  
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	
func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func save_data():
	var configFile = ConfigFile.new()
	var err = configFile.load("user://options")
	if err != OK:
		print("Opening config file failed: " + str(err))
		return
	configFile.set_value("volume", str(bus_name), value)
	configFile.save("user://options")
