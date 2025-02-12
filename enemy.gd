class_name Enemy extends Unit

func _ready():
  Enemies.enemies.append(self)
  super()
