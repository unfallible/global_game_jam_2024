extends Node2D


func _ready():
    pass
    
    # Evil await code for debugging :)
    #await get_tree().create_timer(1.0).timeout
    #spawn_note(4)


func _input(event):
    pass


func spawn_note(note_index: int):
    var note_scene: Resource = preload("res://note_paths/note.tscn")
    var note_instance: Node2D = note_scene.instantiate()
    match note_index:
        0: $Goal/NoteSpawn00.add_child(note_instance)
        1: $Goal/NoteSpawn01.add_child(note_instance)
        2: $Goal/NoteSpawn02.add_child(note_instance)
        3: $Goal/NoteSpawn03.add_child(note_instance)
        4: $Goal/NoteSpawn04.add_child(note_instance)
        5: $Goal/NoteSpawn05.add_child(note_instance)
