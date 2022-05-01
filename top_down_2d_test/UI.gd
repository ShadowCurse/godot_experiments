extends Control

onready var player: KinematicBody2D = get_parent().get_node("Player")

func update_health_bar(new_value):
	$HealthBar/Tween.interpolate_property($HealthBar, "value", $HealthBar.value, new_value, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$HealthBar/Tween.start()


func _on_Player_health_change(new_hp: int):
	var bar_len = $HealthBar.max_value - $HealthBar.min_value
	var hp_percentage = float(new_hp) / float(player.max_health)
	var hp_bar_val = (bar_len * hp_percentage) + $HealthBar.min_value
	update_health_bar(hp_bar_val)
