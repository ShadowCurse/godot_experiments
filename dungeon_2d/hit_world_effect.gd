extends GPUParticles2D

func _ready() -> void:
	$Timer.start(self.lifetime)


func _on_timer_timeout() -> void:
	self.queue_free()
