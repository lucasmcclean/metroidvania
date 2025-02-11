class_name Level
extends TileMapLayer

@export var limit_right: int
@export var limit_bottom: int

# The positional coordinates where the scene will connect to the prior scene.
# conn_start_x is implied to be 0
@export var conn_start_y: int

# The positional coordinates where the scene will connect to the next scene.
@export var conn_end_x: int
@export var conn_end_y: int
