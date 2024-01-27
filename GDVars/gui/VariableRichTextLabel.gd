extends Label

class_name VariableRichTextLabel

var _is_cache_valid: bool = false
var _is_parsed_expression_valid: bool = false
var _parsed_expression: Expression = Expression.new()

#@export var _expression: StringVar:
	#get:
		#return _expression
	#set(value):
		#if _expression is StringVar:
			#_expression.changed.disconnect(_on_expression_changed)
		#_expression = value
		#if _expression is StringVar:
			#_expression.changed.connect(_on_expression_changed)
		#_on_expression_changed()
@export var _expression: String: #This is parsed as a godot Expression. As an example, if the first element of args is a StringVar with the valuen "World" then '"Hello %s!" % args[0]' will evaluate to 'Hello World!'
	get:
		return _expression
	set(value):
		_expression = value
		_on_expression_changed()

@export var _args: Array[VariableBase] = []: #These variables are passed into the expression as an array called args 
	get:
		return _args
	set(value):
		if _args is Array[VariableBase]:
			for arg: VariableBase in _args:
				arg.changed.disconnect(_on_variables_changed)
		_args = value
		if _args is Array[VariableBase]:
			for arg: VariableBase in _args:
				arg.changed.connect(_on_variables_changed)
		_on_variables_changed()

func _on_variables_changed() -> void:
	_is_cache_valid = false

func _on_expression_changed() -> void:
	_is_parsed_expression_valid = false
	_on_variables_changed()

func _update_text() -> void:
	if !_is_parsed_expression_valid:
		var expression_args: Array[String] = ["args"]
		_parsed_expression.parse(_expression, expression_args)
		_is_parsed_expression_valid = true
	if !_is_cache_valid:
		var variants: Array[Variant] = [_args.map(func(x: VariableBase): return x.get_value())]
		text = _parsed_expression.execute(variants)
		_is_cache_valid = true
		
# Called when the node enters the scene tree for the first time.
func _ready():
	_update_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_text()
