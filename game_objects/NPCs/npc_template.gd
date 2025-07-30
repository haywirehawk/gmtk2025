extends Node2D

@export var dialogArray: Array[String] = ["Hello!"]
var isInTrigger = false
var dialogCurrentIndex = 0;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$TextHolder.visible = true
		dialogCurrentIndex = 0
		$TextHolder/RichTextLabel.text = dialogArray[dialogCurrentIndex]
		isInTrigger = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$TextHolder.visible = false
		isInTrigger = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") && isInTrigger:
		dialogCurrentIndex = dialogCurrentIndex + 1
		if dialogCurrentIndex > dialogArray.size() - 1:
			dialogCurrentIndex = 0;
		$TextHolder/RichTextLabel.text = dialogArray[dialogCurrentIndex]
