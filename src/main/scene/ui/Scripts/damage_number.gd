extends Marker2D

enum Mode{
	PHYSICAL,
	MAGIC
}

var text:
	set(v):
		$Label.text = str(float(v))
		text = v

var velocity = Vector2.ZERO
var gravity = Vector2.ZERO
var mass: float = 100

var type: String = "phy"

var is_critical: bool = false

func _ready() -> void:
	$AnimationPlayer.play("default")
	var target_scale = Vector2.ONE
	if type == "phy":
		$Label.modulate = Color.GREEN
	if type == "mag":
		$Label.modulate = Color.DODGER_BLUE
	if is_critical:
		$Label.modulate = Color.RED
		target_scale = Vector2(1.5, 1.5)
	var tween_scale = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_scale.tween_property(self, "scale", target_scale, 0.6).from(Vector2.ZERO)

	
func _process(delta: float) -> void:
	velocity += gravity * mass * delta
	position += velocity * delta


