extends Marker2D

enum Mode{
	PHYSICAL,
	MAGIC
}

var text:
	set(v):
		$Label.text = str(int(v))
		text = v

var velocity = Vector2.ZERO
var gravity = Vector2.ZERO
var mass: float = 100

var type: String = "phy"

var is_critical: bool = false

func _ready() -> void:
	$AnimationPlayer.play("default")
	if type == "phy":
		$Label.modulate = Color.ORANGE_RED
	if type == "mag":
		$Label.modulate = Color.DODGER_BLUE
	if is_critical:
		$Label.modulate = Color.BLACK

	
func _process(delta: float) -> void:
	velocity += gravity * mass * delta
	position += velocity * delta


