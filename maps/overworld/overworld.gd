extends TileMap
# Provides the parent grid information about itself

# Tile mapping to enum
enum TILES {
	GRASS,
	DIRT,
	WATER
}

# Map grid size
const GRID_SIZE = Vector2(60,40)

# Tile info
const IMPASSSABLE = [WATER]
const ENCOUNTERABLE = [GRASS, DIRT]

const PLAYER_SPAWN = [2,2]




