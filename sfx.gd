extends Node

var audio_node : Node

func play(path):
  audio_node.find_child(path).play()
