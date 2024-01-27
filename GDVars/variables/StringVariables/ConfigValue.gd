extends StringVar

class_name ConfigValue

var _config: ConfigFile = ConfigFile.new()

@export_file("*.ini") var _configFilename: String:
	get:
		return _configFilename
	set(value):
		_configFilename = value
		if _config.load(_configFilename) != OK:
			print("Error reading %s" % _configFilename)
		_on_var_changed()

@export var _section: StringVar:
	get:
		return _section
	set(value):
		if (_section is StringVar):
			_section.changed.disconnect(_on_var_changed)
		_section = value
		if (_section is StringVar):
			_section.changed.connect(_on_var_changed)
		_on_var_changed()

@export var _key: StringVar:
	get:
		return _key
	set(value):
		if (_key is StringVar):
			_key.changed.disconnect(_on_var_changed)
		_key = value
		if (_key is StringVar):
			_key.changed.connect(_on_var_changed)
		_on_var_changed()

var _cache: String
var _is_cache_valid: bool = false

func get_value() -> String:
	if (!_is_cache_valid):
		var configurationVal: Variant = _config.get_value(_section.get_value(), _key.get_value())
		_cache = configurationVal if configurationVal is String else _cache
		_is_cache_valid = true
	return _cache

func _on_var_changed() -> void:
	_is_cache_valid = false
	emit_changed()
