extends Node3D

signal entered

@export var locked: bool = true

@onready var door = $Interactable
@onready var door_inside = $door/vRAT

func _ready():
	door.interacted.connect(on_door_interacted)
	
func on_door_interacted():
	if not locked or Global.player.has_key:
		door_inside.open_door()
		door.queue_free()


func _on_area_3d_body_entered(body):
	entered.emit()
