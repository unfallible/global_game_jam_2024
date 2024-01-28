extends Node2D

@export var approach_rate: IntVar
@export var note_index: int
var in_hit_window: bool = false
var key_string: String
var success: bool = false
var failure: bool = false

func _ready():
    $AnimationPlayer.speed_scale = 1000.0 / approach_rate.get_value()
    $AnimationPlayer.play("move_note")
    match note_index:
        0: key_string = "NoteKey00"
        1: key_string = "NoteKey01"
        2: key_string = "NoteKey02"
        3: key_string = "NoteKey03"
        4: key_string = "NoteKey04"
        5: key_string = "NoteKey05"

func _process(event):
    if not success and not failure and in_hit_window and Input.is_action_pressed(key_string):
        $NoteBar/Regular.visible = false
        $NoteBar/Success.visible = true
        success = true

func _on_animation_player_animation_finished(anim_name):
    if anim_name == "move_note":
        queue_free()

func start_hit_window():
    in_hit_window = true

func end_hit_window():
    in_hit_window = false
    if not success:
        $NoteBar/Regular.visible = false
        $NoteBar/Failure.visible = true
        failure = true
    
