extends Node

var money: int = 0

func _ready():
  GameSignal.connect("money_picked_up", self, "_on_money_picked_up")

func _on_money_picked_up(value: int) -> void:
  money += value
  GameSignal.emit_signal("money_changed")
