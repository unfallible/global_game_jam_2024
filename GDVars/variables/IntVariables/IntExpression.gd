extends IntVar

class_name IntExpression

var _is_cache_valid: bool = false
var _cache: int
var _is_parsed_expression_valid: bool = false
var _parsed_expression: Expression = Expression.new()

@export var _expression: StringVar:
	get:
		return _expression
	set(value):
		if _expression is StringVar:
			_expression.changed.disconnect(_on_expression_changed)
		_expression = value
		if _expression is StringVar:
			_expression.changed.connect(_on_expression_changed)
		_on_expression_changed()

@export var _args: Array[VariableBase] = []:
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

func get_value() -> int:
	if !_is_parsed_expression_valid:
		var expression_args: Array[String] = ["args"]
		_parsed_expression.parse(_expression.get_value(), expression_args)
		_is_parsed_expression_valid = true
	if !_is_cache_valid:
		var variants: Array[Variant] = _args.map(func(x: VariableBase): return x.get_value())
		_cache = _parsed_expression.execute(variants)
		_is_cache_valid = true
	return _cache

func _on_variables_changed() -> void:
	var is_changed = _is_cache_valid
	_is_cache_valid = false
	if is_changed:
		emit_changed()

func _on_expression_changed() -> void:
	_is_parsed_expression_valid = false
	_on_variables_changed()
