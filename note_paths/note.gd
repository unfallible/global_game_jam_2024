extends Node2D

@export var approach_rate: MutableFloat


func _ready():
    $AnimationPlayer.speed_scale = 1000.0 / approach_rate.get_value()
    $AnimationPlayer.play("move_note")


func _on_animation_player_animation_finished(anim_name):
    if anim_name == "move_note":
        queue_free()
