extends Node

@export var mob_scene: PackedScene

func _ready():
	randomize()
	$UI/Retry.hide()

func _on_MobTimer_timeout():
	var mob = mob_scene.instantiate()
	$SpawnPath/SpawnLocation.progress_ratio = randf()
	var player_position = $Player.position
	add_child(mob)
	mob.initialize($SpawnPath/SpawnLocation.position, player_position)
	mob.connect("squashed", Callable($UI/ScoreLabel, "_on_Mob_squashed"))


func _on_Player_hit():
	$MobTimer.stop()
	$UI/Retry.show()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UI/Retry.visible:
		get_tree().reload_current_scene()
