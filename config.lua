Config = {}

Config.Locale = 'en'

-- Set the time (in minutes) during the player is outlaw
Config.Timer = 1

-- Set if show alert when player use gun
Config.GunshotAlert = true

-- Set if show when player do carjacking
Config.CarJackingAlert = true

-- Set if show when player fight in melee
Config.MeleeAlert = true

-- Show
Config.DeadAlert = true
Config.PanicAlert = true

-- In seconds
Config.BlipGunTime = 25

-- Blip radius, in float value!
Config.BlipGunRadius = 50.0

-- In seconds
Config.BlipMeleeTime = 25

-- Blip radius, in float value!
Config.BlipMeleeRadius = 50.0

-- In seconds
Config.BlipJackingTime = 25

-- Blip radius, in float value!
Config.BlipJackingRadius = 50.0

-- In seconds
Config.BlipPanicTime = 45

-- Blip radius, in float value!
Config.BlipPanicRadius = 75.0

-- In seconds
Config.BlipDeadTime = 25

-- Blip radius, in float value!
Config.BlipDeadRadius = 50.0

-- Show notification when cops steal too?
Config.ShowCopsMisbehave = true

-- Jobs in this table are considered as cops
Config.WhitelistedCops = {
	'police'
}

Config.WhitelistedPanic = {
	'police',
	'ambulance'
}

Config.WeaponBlacklist = {
	'WEAPON_GRENADE',
	'WEAPON_BZGAS',
	'WEAPON_MOLOTOV',
	'WEAPON_STICKYBOMB',
	'WEAPON_PROXMINE',
	'WEAPON_SNOWBALL',
	'WEAPON_PIPEBOMB',
	'WEAPON_BALL',
	'WEAPON_SMOKEGRENADE',
	'WEAPON_FLARE',
	'WEAPON_PETROLCAN',
	'WEAPON_FIREEXTINGUISHER',
	'WEAPON_HAZARDCAN',
	'WEAPON_RAYCARBINE',
	'WEAPON_STUNGUN'
}