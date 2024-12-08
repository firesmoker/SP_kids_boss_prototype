extends Node
class_name AnimationHelper

static func play_animation_until_frame(animation_player: AnimationPlayer, animation_name: String, target_frame: float) -> void:
	var animation: Animation = animation_player.get_animation(animation_name)
	var frame_rate: float = animation.fps  # Get the animation's frames per second
	var target_time: float = target_frame / frame_rate  # Convert frame to time
	
	animation_player.play(animation_name)  # Start the animation

	while animation_player.current_animation_position < target_time:
		await animation_player.get_tree().idle_frame  # Wait for the next frame
	animation_player.stop()  # Stop the animation
	animation_player.seek(target_time, true)  # Ensure it stops exactly at the target frame

static func play_animation_sprite_until_frame(animation_sprite: AnimatedSprite2D, animation_name: String, target_frame: int) -> void:
	animation_sprite.play(animation_name)  # Start playing the animation

	while animation_sprite.frame < min(animation_sprite.sprite_frames.get_frame_count(animation_name), target_frame) - 1:
		await animation_sprite.get_tree().process_frame  # Wait for the next frame
	animation_sprite.stop()  # Stop the animation
	animation_sprite.frame = target_frame  # Ensure it stops at the exact target frame
	
# Scale up
static func scale_up(tween: Tween, node: Node) -> void:
	tween.tween_property(node, "scale", Vector2(1.5, 1.5), 0.5)  # Adjusted to match the argument count

# Scale down
static func scale_down(tween: Tween, node: Node) -> void:
	tween.tween_property(node, "scale", Vector2(1, 1), 0.5)  # Adjusted to match the argument count

# Toggle between scaling up and down
static func bounce_scale(node: Node) -> void:
	var tween: Tween = node.create_tween()
	scale_up(tween, node)
	await tween.finished
	scale_down(tween, node)
	await tween.finished
