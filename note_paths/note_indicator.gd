extends Node2D

@export var note_index: int
var key_string: String

func _ready():
    match note_index:
        0: key_string = "NoteKey00"
        1: key_string = "NoteKey01"
        2: key_string = "NoteKey02"
        3: key_string = "NoteKey03"
        4: key_string = "NoteKey04"
        5: key_string = "NoteKey05"

func _process(event):
    if Input.is_action_pressed(key_string):
        $Pressed.visible = true
    else:
        $Pressed.visible = false
        
