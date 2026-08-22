class_name OreData
extends RefCounted

enum Rarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }

const ORES := {
	"space_trash": {
		"name": "Space Trash", "rarity": Rarity.COMMON,
		"min_price": 1.0, "max_price": 10.0, "weight": 1.0,
	},
	"copper": {
		"name": "Copper", "rarity": Rarity.UNCOMMON,
		"min_price": 1.0, "max_price": 10.0, "weight": 1.0,
	},
	"iron": {
		"name": "Iron", "rarity": Rarity.RARE,
		"min_price": 50.0, "max_price": 100.0, "weight": 4.0,
	},
	"platinum": {
		"name": "Platinum", "rarity": Rarity.EPIC,
		"min_price": 200.0, "max_price": 500.0, "weight": 10.0,
	},
	"lithium": {
		"name": "Lithium", "rarity": Rarity.LEGENDARY,
		"min_price": 1000.0, "max_price": 2500.0, "weight": 25.0,
	},
}
