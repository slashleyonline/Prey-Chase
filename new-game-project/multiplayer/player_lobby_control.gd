extends Control

var game_id
@export var ready_play: bool = false
@onready var check = $ReadyCheck/CheckBox

func _enter_tree() -> void:
	set_multiplayer_authority(int(name))
	set_label(int(name))
func _ready() -> void:
	ready_play = check.button_pressed

func set_label(id: int):
	var id_label = $ID/Label
	id_label.text = str(id)
	game_id = id


func _on_check_box_toggled(toggled_on: bool) -> void:
	ready_play = toggled_on
