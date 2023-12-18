class_name  Room
extends Object

var grid_position : Vector2
var type : int # возможно стоит создать типизацию комнат для такого типа игр
var Doors = {"top": false,
			"bot": false,
			"left": false,
			"right": false}

func _init(_grid_position : Vector2, _type : int):
	grid_position = _grid_position
	type = _type
