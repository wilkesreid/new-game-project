extends Node

var friendlies = {
  'Knife': {
    'name': 'Knife',
    'head_sprite': preload('res://contributions/knife.tres'),
    'body_sprite': preload('res://contributions/border.tres'),
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
    'head_sprite': preload('res://contributions/pistol.tres'),
    'body_sprite': preload('res://contributions/border.tres'),
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
    'head_sprite': preload('res://contributions/healer.tres'),
    'body_sprite': preload('res://contributions/border.tres'),
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
    'head_sprite': preload('res://contributions/razor.tres'),
    'body_sprite': preload('res://contributions/border.tres'),
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
    'head_sprite': preload('res://contributions/pulse.tres'),
    'body_sprite': preload('res://contributions/border.tres'),
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
  },
  'Bolt': {
    'name': 'Bolt',
    'head_sprite': preload('res://contributions/bolt.tres'),
    'body_sprite': preload('res://contributions/border.tres'),
    'speed': 5,
    'max_size': 3,
    'abilities': [
      Ability.new({
        'name': 'Dash',
        'description': 'Speed boost by 2 for 1 turn',
        'distance': 1,
        'damage': 0,
        'effect': {'speed_boost': 2, 'duration': 1}
      })
    ]
  },
  'Anchor': {
    'name': 'Anchor',
    'head_sprite': preload('res://contributions/anchor.tres'),
    'body_sprite': preload('res://contributions/border.tres'),
    'speed': 2,
    'max_size': 6,
    'abilities': [
      Ability.new({
        'name': 'Guard',
        'description': 'Block 2 damage for 1 turn',
        'distance': 2,
        'damage': 0,
        'effect': {'block_damage': 2, 'duration': 1}
      })
    ]
  },
  'Venom': {
    'name': 'Venom',
    'head_sprite': preload('res://contributions/venom.tres'),
    'body_sprite': preload('res://contributions/border.tres'),
    'speed': 3,
    'max_size': 4,
    'abilities': [
      Ability.new({
        'name': 'Poison Fang',
        'description': 'Deal 1 damage per turn for 3 turns',
        'distance': 1,
        'damage': 0,
        'damage_over_time': {'damage': 1, 'duration': 3}
      })
    ]
  },
  'Wraith': {
    'name': 'Wraith',
    'head_sprite': preload('res://contributions/wraith.tres'),
    'body_sprite': preload('res://contributions/border.tres'),
    'speed': 5,
    'max_size': 2,
    'abilities': [
      Ability.new({
        'name': 'Blink',
        'description': 'Teleport whole body in-shape if possible, destroying any enemy body segments that overlap',
        'distance': 3,
        'damage': 0,
        'effect': {'teleport': true, 'destroy_enemy_segments': true}
      })
    ]
  },
  'Leech': {
    'name': 'Leech',
    'head_sprite': preload('res://contributions/leech.tres'),
    'body_sprite': preload('res://contributions/border.tres'),
    'speed': 3,
    'max_size': 4,
    'abilities': [
      Ability.new({
        'name': 'Drain',
        'description': 'Steal 1 body segment from target and adds them to self',
        'distance': 1,
        'damage': 0,
        'effect': {'steal_segments': 1}
      })
    ]
  }
}

var level1 = ['Knife', 'Pistol', 'Healer']
var level2 = ['Razor', 'Pulse', 'Bolt', 'Anchor', 'Venom', 'Wraith', 'Leech']