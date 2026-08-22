class_name UpgradeData
extends RefCounted

const UPGRADES := {
	"speed": {
		"name": "Engine Speed",
		"description": "Maximum movement speed.",
		"levels": [
			{ "cost": 0,    "value": 125.0 },
			{ "cost": 500,  "value": 160.0 },
			{ "cost": 1500, "value": 200.0 },
			{ "cost": 4000, "value": 260.0 },
		],
	},
	"thrust": {
		"name": "Thrusters",
		"description": "Reduces the speed penalty from towed cargo weight.",
		"levels": [
			{ "cost": 0,    "value": 1.0 },
			{ "cost": 1000, "value": 0.7 },
			{ "cost": 3000, "value": 0.45 },
			{ "cost": 7000, "value": 0.25 },
		],
	},
	"laser_damage": {
		"name": "Laser Damage",
		"description": "Damage per hit.",
		"levels": [
			{ "cost": 0,    "value": 5.0 },
			{ "cost": 600,  "value": 8.0 },
			{ "cost": 1800, "value": 12.0 },
		],
	},
	"laser_focus": {
		"name": "Targeting Array",
		"description": "Fewer weak points to hit per attack.",
		"levels": [
			{ "cost": 0,    "value": 4 },
			{ "cost": 700,  "value": 3 },
			{ "cost": 2000, "value": 2 },
		],
	},
}
