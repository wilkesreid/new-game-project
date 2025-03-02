extends Node

var friendlies = {
  'Knife': {
    'name': 'Knife',
    'head_sprite': preload('res://sprites/assets/1/Icons/1/Skillicon1_15.png'),
    'body_sprite': preload('res://sprites/assets/1/Frames/Frame_01.png'),
    'speed': 3,
    'max_size': 3,
    'abilities': [
      Ability.new({
        'name': 'Cut',
        'description': 'Deal 2 damage',
        'distance': 1,
        'damage': 2
      })
    ]
  },
  'Pistol': {
    'name': 'Pistol',
    'head_sprite': preload('res://sprites/assets/kenney_puzzle-pack-2/PNG/Tiles blue/tileBlue_08.png'),
    'body_sprite': preload('res://sprites/assets/1/Frames/Frame_01.png'),
    'speed': 2,
    'max_size': 3,
    'abilities': [
      Ability.new({
        'name': 'Shoot',
        'description': 'Deal 1 damage',
        'distance': 3,
        'damage': 1
      })
    ]
  },
  'Healer': {
    'name': 'Healer',
    'head_sprite': preload('res://sprites/assets/kenney_puzzle-pack-2/PNG/Tiles green/tileGreen_12.png'),
    'body_sprite': preload('res://sprites/assets/1/Frames/Frame_01.png'),
    'speed': 2,
    'max_size': 3,
    'abilities': [
      Ability.new({
        'name': 'Heal',
        'description': 'Add 1 body segment to target',
        'distance': 2,
        'damage': 0
      })
    ]
  },
  'Razor': {
    'name': 'Razor',
    'head_sprite': preload('res://sprites/assets/1/Icons/4/Skillicon4_15.png'),
    'body_sprite': preload('res://sprites/assets/1/Frames/Frame_01.png'),
    'speed': 3,
    'max_size': 3,
    'abilities': [
      Ability.new({
        'name': 'Slice',
        'description': 'Deal 3 damage',
        'distance': 1,
        'damage': 3
      })
    ]
  },
  'Pulse': {
    'name': 'Pulse',
    'head_sprite': preload('res://sprites/assets/kenney_puzzle-pack-2/PNG/Tiles blue/tileBlue_12.png'),
    'body_sprite': preload('res://sprites/assets/1/Frames/Frame_01.png'),
    'speed': 2,
    'max_size': 5,
    'abilities': [
      Ability.new({
        'name': 'Heal Wave',
        'description': 'Add 2 body segments to target',
        'distance': 2,
        'damage': 0
      })
    ]
  }
}

var level1 = ['Knife', 'Pistol', 'Healer']
var level2 = ['Razor', 'Pulse']