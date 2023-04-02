extends Spatial


const N = 1 					# binary 0001
const E = 2 					# binary 0010
const S = 4 					# binary 0100
const W = 8 					# binary 1000

var cell_walls = {
	Vector2(0, -1): N, 			# cardinal directions for NESW
	Vector2(1, 0): E,
	Vector2(0, 1): S, 
	Vector2(-1, 0): W
}

var map = []

onready var MiniMap = get_node('/root/Game/UI/VP/Map_Container/MiniMap')

var tiles = [
	preload("res://Maze/Tile00.tscn")	# all the tiles we created
	,preload("res://Maze/Tile01.tscn")
	,preload("res://Maze/Tile02.tscn")
	,preload("res://Maze/Tile03.tscn")
	,preload("res://Maze/Tile04.tscn")
	,preload("res://Maze/Tile05.tscn")
	,preload("res://Maze/Tile06.tscn")
	,preload("res://Maze/Tile07.tscn")
	,preload("res://Maze/Tile08.tscn")
	,preload("res://Maze/Tile09.tscn")
	,preload("res://Maze/Tile10.tscn")
	,preload("res://Maze/Tile11.tscn")
	,preload("res://Maze/Tile12.tscn")
	,preload("res://Maze/Tile13.tscn")
	,preload("res://Maze/Tile14.tscn")
	,preload("res://Maze/Tile15.tscn")
]

var minitiles = [
	preload("res://MiniMap/MapTile00.tscn")	# all the tiles we created
	,preload("res://MiniMap/MapTile01.tscn")
	,preload("res://MiniMap/MapTile02.tscn")
	,preload("res://MiniMap/MapTile03.tscn")
	,preload("res://MiniMap/MapTile04.tscn")
	,preload("res://MiniMap/MapTile05.tscn")
	,preload("res://MiniMap/MapTile06.tscn")
	,preload("res://MiniMap/MapTile07.tscn")
	,preload("res://MiniMap/MapTile08.tscn")
	,preload("res://MiniMap/MapTile09.tscn")
	,preload("res://MiniMap/MapTile10.tscn")
	,preload("res://MiniMap/MapTile11.tscn")
	,preload("res://MiniMap/MapTile12.tscn")
	,preload("res://MiniMap/MapTile13.tscn")
	,preload("res://MiniMap/MapTile14.tscn")
	,preload("res://MiniMap/MapTile15.tscn")
]


var tile_size = 2 						# 2-meter tiles
var mini_size = 64						#tile size in pixels
var width = 25  						# width of map (in tiles)
var height = 25  						# height of map (in tiles)

onready var Key = preload('res://Key/Key.tscn')
onready var Exit = preload('res://Exit/Exit.tscn')

func _ready():
	randomize()
	make_maze()
	var key = Key.instance()
	key.translate(Vector3(width*tile_size-2,1,0))
	add_child(key)
	var exit = Exit.instance()
	exit.translate(Vector3(0,0.5,height*tile_size-2))
	add_child(exit)
	
func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
	
func make_maze():
	var unvisited = []  # array of unvisited tiles
	var stack = []
	# fill the map with solid tiles
	for x in range(width):
		map.append([])
		map[x].resize(height)
		for y in range(height):
			unvisited.append(Vector2(x, y))
			map[x][y] = N|E|S|W 		# 15
	var current = Vector2(0, 0)
	unvisited.erase(current)
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			var dir = next - current
			var current_walls = map[current.x][current.y] - cell_walls[dir]
			var next_walls = map[next.x][next.y] - cell_walls[-dir]
			map[current.x][current.y] = current_walls
			map[next.x][next.y] = next_walls
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
	for x in range(width):
		for z in range(height):
			var tile = tiles[map[x][z]].instance()
			tile.translate(Vector3(x*tile_size,0,z*tile_size))
			tile.name = "Tile_" + str(x) + "_" + str(z)
			add_child(tile)
			var tile2 = minitiles[map[x][z]].instance()
			tile2.position = (Vector2(x,z)*mini_size)
			tile2.name = "MTile_" + str(x) + "_" + str(z)
			MiniMap.add_child(tile2)
