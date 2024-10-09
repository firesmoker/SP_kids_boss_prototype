class_name PopupProgressBar extends ProgressBar
@onready var timer: Timer = $PopupTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = timer.wait_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = timer.time_left

func start_closing_timer(time: float = timer.wait_time) -> void:
	timer.wait_time = time
	max_value = timer.wait_time
	value = timer.wait_time
	timer.start()


func _on_popup_timer_timeout() -> void:
	timer.stop()
