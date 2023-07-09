extends Node2D

@export var initial_scene: String
var current_scene_node: Node = null
var old_scene_node: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prepare_next_scene(initial_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_level_next_scene(next_scene_name: String) -> void:
	old_scene_node = current_scene_node
	prepare_next_scene(next_scene_name)
	current_scene_node.visible = false
	$AnimationPlayer.play("fade_in")
	

func prepare_next_scene(scene_name: String):
	var scene_path = "res://levels/" + scene_name + ".tscn"
	current_scene_node = load(scene_path).instantiate()
	call_deferred("add_child", current_scene_node)
	current_scene_node.next_scene_signal.connect(_on_level_next_scene)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"fade_in":
			old_scene_node.deconstruct()
			current_scene_node.visible = true
			$AnimationPlayer.play("fade_out")
		"fade_out":
			pass
