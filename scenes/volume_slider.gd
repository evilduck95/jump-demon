extends HSlider

@export
var initial_value: float
@export 
var bus_name: String

var bus_index: int

func _ready() -> void:  
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	value = load_value()
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	

func _on_value_changed(updated_value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(updated_value))
	save_value()

func save_value():
	var configFile = ConfigFile.new()
	configFile.load("user://options.txt")
	configFile.set_value("volume", str(bus_name), value)
	configFile.save("user://options.txt")
	
func load_value() -> float:
	var configFile = ConfigFile.new()
	var err = configFile.load("user://options.txt")
	if err != OK:
		print("Opening config file for loading failed: " + str(err))
		return 1
	return configFile.get_value("volume", str(bus_name), 1)
