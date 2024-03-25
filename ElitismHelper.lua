local Users = {}
local Timers = {}
local TimerData = {}
local TimersMelee = {}
local TimerMeleeData = {}
local CombinedFails = {}
local FailByAbility = {}
local activeUser = nil
local AddonVersion = "0.13.40"
local playerUser = GetUnitName("player", true).."-"..GetRealmName():gsub(" ", "")
local defaultElitismHelperDBValues = {
	Loud = true,
	Threshold = 30,
	OutputMode = "default",
	EndOfDungeonMessage = true
}

local addonName, addonTable = ...;

local OutputModes = {
	["default"] = 0,
	["party"] = 1,
	["yell"] = 2,
	["self"] = 3,
}

local Spells = {

	-- Debug
	--[] = 20, -- ()
	--[=====[ --]=====] -- Currently disabled for this seasons / Don't remove, possibly used in a future rotation

	--[252144] = 1,
	--[190984] = 1,		 -- DEBUG Druid Wrath
	--[285452] = 1,		 -- DEBUG Shaman Lava Burst
	--[188389] = 1,		 -- DEBUG Shaman Flame Shock

	-- Affixes
	[209862] = 20, -- Volcanic Plume (Environment)
	[226512] = 20, -- Sanguine Ichor (Environment)
	[240448] = 20, -- Quaking (Environment)
	[343520] = 20, -- Storming (Environment)
	[350163] = 20, -- Melee (Spiteful Shade)


	-- [**Dragonflight**]
	-- Affixes seasons

	[394873] = 20, -- Lightning Strike (Season 1 Thundering)
	[396411] = 20, -- Primal Overload (Season 1 Thundering)

	--[=====[
	-- Uldaman: Legacy of Tyr
	[369811] = 20, -- Brutal Slam (Hulking Berserker)
	[369854] = 20, -- Throw Rock (Burly Rock-Thrower)
	[382576] = 20, -- Scorn of Tyr (Earthen Guardian)

	[369573] = 20, -- Heavy Arrow (Baelog, The Lost Dwarves)
	[369792] = 20, -- Skullcracker (Eric "The Swift", The Lost Dwarves)
	[375286] = 20, -- Searing Cannonfire (The Lost Dwarves)
	[377825] = 20, -- Burning Pitch (The Lost Dwarves)
	[369703] = 20, -- Thundering Slam (Bromach)
	[368996] = 20, -- Purging Flames (Emberon)
	[369029] = 20, -- Heat Engine (Emberon)
	[369052] = 20, -- Seeking Flame (Vault Keeper, Emberon)
	[376325] = 20, -- Eternity Zone (Chrono-Lord Deios)
	[377561] = 20, -- Time Eruption (Chrono-Lord Deios)

	-- Neltharus
	[372459] = 20, -- Burning (Environment)
	[382708] = 20, -- Volcanic Guard (Qalashi Warden)
	[372583] = 20, -- Binding Spear, Impact (Qalashi Hunter)
	--[373540] = 20, -- Binding Spear, periodic (Qalashi Hunter) - should this be tracked?
	[376186] = 20, -- Eruptive Crush, Area (Overseer Lahar)
	[383928] = 20, -- Eruptive Crush, Projectiles (Overseer Lahar)
	[395427] = 20, -- Burning Roar (Overseer Lahar)
	[372372] = 20, -- Magma Fist (Qalashi Trainee)
	[379410] = 20, -- Throw Lava (Qalashi Lavabearer)
	[372208] = 20, -- Djaradin Lava (Qalashi Lavabearer)
	[372203] = 20, -- Scorching Breath (Qalashi Irontorch)
	[372293] = 20, -- Conflagrant Battery (Irontorch Commander)
	[378831] = 20, -- Explosive Concoction (Qalashi Plunderer)

	[373756] = 20, -- Magma Wave (Chargath, Bane of Scales)
	[375397] = 20, -- Lava Splash (Chargath, Bane of Scales)
	[375061] = 20, -- Blazing Eruption (Forgemaster Gorek)
	[375241] = 20, -- Forgestorm (Forgemaster Gorek)
	[374397] = 20, -- Heated Swings, Jump (Forgemaster Gorek) - TODO which one is correct?
	[374517] = 20, -- Heated Swings, Jump (Forgemaster Gorek) - TODO which one is correct?
	[381482] = 20, -- Forgefire (Forgemaster Gorek)
	[375071] = 20, -- Magma Lob (Magmatusk)
	[375204] = 20, -- Liquid Hot Magma (Magmatusk)
	[375449] = 20, -- Blazing Charge (Magmatusk)
	[375535] = 20, -- Lava Wave (Magmatusk)
	[377204] = 20, -- The Dragon's Kiln (Warlord Sargha)
	[377477] = 20, -- Burning Ember (Warlord Sargha)
	[377542] = 20, -- Burning Ground (Warlord Sargha)
	[391773] = 20, -- The Dragon's Eruption (Warlord Sargha)

	-- Brackenhide Hollow
	[368297] = 20, -- Toxic Trap, Trigger (Bonebolt Hunter)
	[368299] = 20, -- Toxic Trap, Area (Bonebolt Hunter)
	[382556] = 20, -- Ragestorm (Bracken Warscourge)
	[384673] = 20, -- Spreading Rot (Decay Ritual, Environment)
	[378055] = 20, -- Burst (Decaying Slime)
	[378054] = 20, -- Withering Away! (Decaying Slime)
	[374569] = 20, -- Burst (Monstrous Decay)
	[373943] = 20, -- Stomp (Wilted Oak)
	[385303] = 20, -- Teeth Trap (Environment)
	[385524] = 20, -- Sentry Fire (Environment)
	[385805] = 20, -- Violent Whirlwind (Stinkbreath)
	[379425] = 20, -- Rotting Creek (Environment)
	[383392] = 20, -- Rotting Surge, Impact (Filth Caller)
	[383399] = 20, -- Rotting Surge, periodic (Filth Caller)

	[377830] = 20, -- Bladestorm (Rira Hackclaw)
	[384148] = 20, -- Ensnaring Trap (Gutshot)
	[384558] = 20, -- Bounding Leap (Rotfang Hyena, Gutshot)
	[376797] = 20, -- Decay Spray (Treemouth)
	[373944] = 20, -- Rotburst Totem, Spawn (Decatriarch Wratheye)
	[376170] = 20, -- Choking Rotcloud, Frontal (Decatriarch Wratheye)
	[376149] = 20, -- Choking Rotcloud, Area (Decatriarch Wratheye)
	[379425] = 20, -- Decaying Fog (Environment, Decatriarch Wratheye)

	-- Halls of Infusion
	[374075] = 20, -- Seismic Slam (Primalist Geomancer)
	[393444] = 20, -- Spear Flurry / Gushing Wound (Refti Defender)
	--[374045] = 20, -- Expulse (Containment Apparatus) - no indicator
	[375215] = 20, -- Cave In (Curious Swoglet)
	[374563] = 20, -- Dazzle (Dazzling Dragonfly)
	[374741] = 20, -- Magma Crush (Flamecaller Aymi)
	[375080] = 20, -- Whirling Fury (Squallbringer Cyraz)
	[385168] = 20, -- Thunderstorm (Primalist Galesinger) - TODO is first tick avoidable?
	[375384] = 20, -- Rumbling Earth (Primalist Earthshaker)
	[383204] = 20, -- Crashing Tsunami (Environment)
	[390290] = 20, -- Flash Flood (Infuser Sariya)

	[383935] = 20, -- Spark Volley (Watcher Irideus)
	[389446] = 20, -- Nullifying Pulse (Nullification Device, Watcher Irideus)
	[385691] = 20, -- Belly Slam (Gulping Goliath)
	[386757] = 20, -- Hailstorm (Khajin the Unyielding)
	[386562] = 20, -- Glacial Surge (Khajin the Unyielding)
	[386295] = 20, -- Avalanche (Khajin the Unyielding)
	[390118] = 20, -- Frost Cyclone (Khajin the Unyielding)
	[387474] = 20, -- Infused Globule, Impact (Primal Tsunami)
	[387359] = 20, -- Waterlogged (Primal Tsunami)
	[387363] = 20, -- Infused Globule, Explosion (Primal Tsunami)
	[388786] = 20, -- Rogue Waves (Primal Tsunami)

	--[=====[ 
	-- Algeth'ar Academy
	[388884] = 20, -- Arcane Rain (Spellbound Scepter)
	[388957] = 20, -- Riftbreath (Arcane Ravager)
	[378011] = 20, -- Deadly Winds (Guardian Sentry)
	[377516] = 20, -- Dive Bomb (Territorial Eagle)
	[377524] = 20, -- Dive Bomb (Alpha Eagle)
	[377383] = 20, -- Gust (Alpha Eagle)
	[390918] = 20, -- Seed Detonation (Vile Lasher)
	[387932] = 20, -- Astral Whirlwind (Algeth'ar Echoknight)

	[385970] = 20, -- Arcane Orb, Spawn (Vexamus)
	[386201] = 20, -- Corrupted Mana (Vexamus) - TODO is first tick avoidable?
	[388546] = 20, -- Arcane Fissure, Swirly (Vexamus)
	[377034] = 20, -- Overpowering Gust (Crawth)
	[376449] = 20, -- Firestorm (Crawth)
	[393122] = 20, -- Roving Cyclone (Crawth)
	[388799] = 20, -- Germinate (Overgrown Ancient)
	[388625] = 20, -- Branch Out (Overgrown Ancient)
	[388822] = 20, -- Power Vacuum (Echo of Doragosa)
	[374361] = 20, -- Astral Breath (Echo of Doragosa)
	[389007] = 20, -- Arcane Rift / Wild Energy (Echo of Doragosa)
	[388996] = 20, -- Energy Eruption (Echo of Doragosa)
	
		-- The Azure Vault
	[370766] = 20, -- Crystalline Rupture (Crystal Thrasher)
	[371021] = 20, -- Splintering Shards, Aura (Crystal Thrasher)
	[375649] = 20, -- Infused Ground (Arcane Tender)
	[375591] = 20, -- Sappy Burst (Volatile Sapling / Bubbling Sapling)
	[371352] = 20, -- Forbidden Knowledge (Unstable Curator)
	[387067] = 20, -- Arcane Bash (Arcane Construct)
	[374868] = 20, -- Unstable Power (Astral Attendant)
	[386536] = 20, -- Null Stomp (Nullmagic Hornswog)

	[374523] = 20, -- Stinging Sap (Leymor)
	[386660] = 20, -- Erupting Fissure (Leymor)
	[374582] = 20, -- Explosive Brand, Area (Leymor)
	[385579] = 20, -- Ancient Orb (Azureblade)
	[390462] = 20, -- Ancient Orb Fragment (Azureblade)
	[389855] = 20, -- Unstable Magic (Draconic Image / Draconic Illusion, Azureblade)
	[387150] = 20, -- Frozen Ground (Telash Greywing)
	[384699] = 20, -- Crystalline Roar (Umbrelskul)
	[385078] = 20, -- Arcane Eruption (Umbrelskul)
	[385267] = 20, -- Crackling Vortex (Umbrelskul)
	
		-- Ruby Life Pools
	[372696] = 20, -- Excavating Blast (Primal Juggernaut)
	[372697] = 20, -- Jagged Earth (Primal Juggernaut)
	[373458] = 20, -- Stone Missile (Primal Terrasentry)
	[372088] = 20, -- Blazing Rush, Hit (Defier Draghar)
	[372796] = 20, -- Blazing Rush, DoT (Defier Draghar)
	[385292] = 20, -- Molten Steel (Defier Draghar)
	[378968] = 20, -- Flame Patch (Scorchling)
	[373973] = 20, -- Blaze of Glory, AoE (Primalist Flamedancer)
	[373977] = 20, -- Blaze of Glory, Projectile (Primalist Flamedancer)
	[391727] = 20, -- Storm Breath (Thunderhead)
	[391724] = 20, -- Flame Breath (Flamegullet)
	[373614] = 20, -- Burnout (Blazebound Destroyer)
	--[385311] = 20, -- Thunderstorm (Primalist Shockcaster) - no indicator
	--[392406] = 20, -- Thunderclap (Storm Warrior) - TODO probably not avoidable for melee
	[392399] = 20, -- Crackling Detonation (Primal Thundercloud)

	[384024] = 20, -- Hailbombs, Projectiles (Melidrussa Chillworm)
	[372863] = 20, -- Ritual of Blazebinding (Kokia Blazehoof)
	[372811] = 20, -- Molten Boulder, Projectile (Kokia Blazehoof)
	[372819] = 20, -- Molten Boulder, Explosion (Kokia Blazehoof)
	[372820] = 20, -- Scorched Earth (Kokia Blazehoof)
	[373087] = 20, -- Burnout (Blazebound Firestorm, Kokia Blazehoof)
	[381526] = 20, -- Roaring Firebreath (Kyrakka)
	[384773] = 20, -- Flaming Embers (Kyrakka)
	
		-- The Nokhud Offensive
	[384868] = 20, -- Multi-Shot (Nokhud Longbow)
	[384479] = 20, -- Rain of Arrows (Nokhud Longbow)
	[384336] = 20, -- War Stomp (Nokhud Plainstomper / Nokhud Lancemaster / Nokhud Defender)
	[386028] = 20, -- Thunder Clap (Primalist Thunderbeast)
	[384882] = 20, -- Stormsurge Lightning (Stormsurge Totem)
	[386694] = 20, -- Stormsurge (Stormsurge Totem)
	[386912] = 20, -- Stormsurge Cloud (Stormsurge Totem)
	[396376] = 20, -- Chant of the Dead (Ukhel Deathspeaker)
	[387611] = 20, -- Necrotic Eruption (Ukhel Corruptor)
	[387629] = 20, -- Rotting Wind (Desecrated Ohuna)
	[388451] = 20, -- Stormcaller's Fury (Environment)
	[382233] = 20, -- Broad Stomp (Nokhud Defender / Batak)
	[382274] = 20, -- Vehement Charge (Nokhud Defender / Balara)
	[374711] = 20, -- Ravaging Spear (Nokhud Warspear / Balara)

	[385916] = 20, -- Tectonic Stomp (Granyth)
	[386920] = 20, -- Raging Lightning (The Raging Tempest)
	[391967] = 20, -- Electrical Overload (The Raging Tempest)
	[386916] = 20, -- The Raging Tempest (The Raging Tempest)
	[388104] = 20, -- Ritual of Desecration (Environment)
	[385193] = 20, -- Earthsplitter (Maruuk) - TODO which is correct?
	[384960] = 20, -- Earthsplitter (Maruuk) - TODO which is correct?
	[395669] = 20, -- Aftershock (Maruuk)
	[386063] = 20, -- Frightful Roar (Maruuk)
	[386037] = 20, -- Gale Arrow, Whirls (Teera)
	[376685] = 20, -- Iron Stampede (Balakar Khan) - TODO which is correct?
	[376688] = 20, -- Iron Stampede (Balakar Khan) - TODO which is correct?
	[375943] = 20, -- Upheaval (Balakar Khan)
	[376737] = 20, -- Lightning (Balakar Khan)
	[376892] = 20, -- Crackling Upheaval (Balakar Khan)
	[376899] = 20, -- Crackling Cloud (Balakar Khan) - TODO is first tick avoidable?
	--]=====]

	-- Dawn of the Infinite: Galakrond's Fall
	[419447] = 20, -- Bronze Radiance (Environment)
	[419380] = 20, -- Timeline Conflux, small Swirlies (Environment)
	[419383] = 20, -- Timeline Conflux, big Swirlies (Environment)
	[412065] = 20, -- Timerip (Epoch Ripper)
	[414032] = 20, -- Errant Time (Environment)
	[413332] = 20, -- Sand Zone (Environment)
	[415773] = 20, -- Temporal Detonation (Interval)
	[413536] = 20, -- Untwist, Swirly (Timestream Anomaly)
	[413618] = 20, -- Timeless Curse (Infinite Infiltrator)
	[419526] = 20, -- Loose Time (Environment)
	[412810] = 20, -- Blight Spew (Risen Dragon)

	[401794] = 20, -- Withering Sandpool, Area (Chronikar)
	[403088] = 20, -- Eon Shatter (Chronikar)
	[405970] = 20, -- Eon Fragment (Chronikar)
	[403259] = 20, -- Residue Blast (Chronikar)
	[404650] = 20, -- Fragments of Time (Manifested Timeways)
	[407147] = 20, -- Blight Seep (Blight of Galakrond)
	[407027] = 20, -- Corrosive Expulsion (Blight of Galakrond)
	[408008] = 20, -- Necrotic Winds, Tornado (Ahnzon, Blight of Galakrond)
	[408177] = 20, -- Incinerating Blightbreath (Dazhak, Blight of Galakrond)
	[409287] = 20, -- Rending Earthspikes (Iridikron)
	[414376] = 20, -- Punctured Ground (Iridikron)
	[409642] = 20, -- Pulverizing Exhalation (Iridikron)
	[409969] = 20, -- Stone Dispersion (Iridikron)

	-- Dawn of the Infinite: Murozond's Rise
	[412137] = 20, -- Temporal Strike (Valow, Timesworn Keeper)
	[412131] = 20, -- Orb of Contemplation (Leirai, Timesworm Maiden)
	[412242] = 20, -- Shrouding Sandstorm, Hit (Spurlok, Timesworn Sentinel)
	[413618] = 20, -- Timeless Curse (Infinite Watchkeeper / Infinite Saboteur / Infinite Diversionist / Infinite Slayer)
	[419328] = 20, -- Infinite Schism, Swirlies (Timeline Marauder)
	[409038] = 20, -- Displacement (Infinite Protector / Infinite Warder, Bronze Temple Run)
	[413536] = 20, -- Untwist, Swirly (Timestream Anomaly)
	[411610] = 20, -- Bubbly Barrage (Time-Lost Waveshaper)
	[412225] = 20, -- Electro-Juiced Gigablast (Time-Lost Aerobot)
	[412181] = 20, -- Bombing Run (Time-Lost Aerobot)
	[413428] = 20, -- Time Beam, Swirlies (Pendule)
	[419517] = 20, -- Chronal Eruption (Chronaxie)
	[407312] = 20, -- Volatile Mortar (Alliance Destroyer / Horde Destroyer)
	[407315] = 20, -- Embers (Alliance Destroyer / Horde Destroyer)
	[407317] = 20, -- Shrapnel Shell (Alliance Destroyer / Horde Destroyer)
	[407313] = 20, -- Shrapnel (Alliance Destroyer / Horde Destroyer)
	[419629] = 20, -- Kaboom! (Dwarven Bomber)
	[407715] = 20, -- Kaboom! (Goblin Sapper)
	[407125] = 20, -- Sundering Slam (Alliance Knight / Horde Raider)
	[417002] = 20, -- Consecration (Paladin of the Silver Hand)
	[407906] = 20, -- Earthquake (Horde Farseer)
	[419526] = 20, -- Loose Time (Environment)

	[400597] = 20, -- Infinite Annihilation (Tyr, the Infinite Keeper)
	[403724] = 20, -- Consecrated Ground (Tyr, the Infinite Keeper)
	[404365] = 20, -- Dragon's Breath (Morchie)
	[413208] = 20, -- Sand Buffeted (Morchie)
	[412769] = 20, -- Anachronistic Decay (Familiar Face, Morchie)
	[410238] = 20, -- Bladestorm (Anduin Lothar / Grommash Hellscream, Time-Lost Battlefield)
	[418056] = 20, -- Shockwave (Anduin Lothar, Time-Lost Battlefield)
	[408228] = 20, -- Shockwave (Grommash Hellscream, Time-Lost Battlefield)
	[417026] = 20, -- Blizzard (Alliance Conjuror, Time-Lost Battlefield)
	[407123] = 20, -- Rain of Fire (Horde Warlock, Time-Lost Battlefield)
	[416265] = 20, -- Infinite Corruption, small Swirlies (Chrono-Lord Deios)
	[416266] = 20, -- Infinite Corruption, big Swirlies (Chrono-Lord Deios)
	[417413] = 20, -- Temporal Scar (Chrono-Lord Deios)


	-- [**Shadowlands**]

	-- Affixes seasons

	--[342494] = 20,		-- Belligerent Boast (Season 1 Prideful)
	--[356414] = 20,		-- Frost Lance (Season 2 Oros)
	--[358894] = 20,		-- Cold Snap (Season 2 Oros)
	--[358897] = 20,		-- Cold Snap (Season 2 Oros)
	--[355806] = 20,		-- Massive Smash (Season 2 Soggodon)
	--[355737] = 20,		-- Scorching Blast (Season 2 Arkolath)
	--[355738] = 20,		-- Scorching Blast DoT (Season 2 Arkolath)
	--[366288] = 20,		-- Force Slam (Season 3 Urh Dismantler)
	--[366409] = 20,		-- Fusion Beam (Season 3 Vy Interceptor)
	--[373513] = 20,		-- Shadow Eruption (Season 4 Zul'gamux)
	--[373429] = 20,		-- Carrion Swarm (Season 4 Nathrezim Infiltrator)
	
	--[=====[ 
	-- Mists of Tirna Scithe
	[321968] = 20,		-- Bewildering Pollen (Tirnenn Villager)
	[323137] = 20,		-- Bewildering Pollen (Tirnenn Villager)
	[325027] = 20,		-- Bramble Burst (Drust Boughbreaker)
	[326022] = 20,		-- Acid Globule (Spinemaw Gorger)
	[340300] = 20,		-- Tongue Lashing (Mistveil Gorgegullet)
	[340304] = 20,		-- Poisonous Secretions (Mistveil Gorgegullet)
	[340311] = 20,		-- Crushing Leap (Mistveil Gorgegullet)
	[331743] = 20,		-- Bucking Rampage (Mistveil Guardian)
	[331748] = 20,		-- Back Kick (Mistveil Guardian)
	[340160] = 20,		-- Radiant Breath (Mistveil Matriarch)
	
	--id ? [323177] = 20,		-- Tears of the Forest (Ingra Maloch)
	[323250] = 20,		-- Anima Puddle (Droman Oulfarran)
	[321834] = 20,		-- Dodge Ball (Mistcaller)
	[336759] = 20,		-- Dodge Ball (Mistcaller)
	[321893] = 20,		-- Freezing Burst (Mistcaller)
	[321828] = 20,		-- Patty Cake (Mistcaller)
	[322655] = 20,		-- Acid Expulsion (Tred'ova)
	[326309] = 20,		-- Decomposing Acid (Tred'ova)
	[326263] = 20,		-- Anima Shedding (Tred'ova)
	
	-- De Other Side
	[334051] = 20,		-- Erupting Darkness (Death Speaker)
	[328729] = 20,		-- Dark Lotus (Risen Cultist)
	[333250] = 20,		-- Reaver (Risen Warlord)
	[342869] = 20,		-- Enraged Mask (Enraged Spirit)
	[333790] = 20,		-- Enraged Mask (Enraged Spirit)
	[332672] = 20,		-- Bladestorm (Atal'ai Deathwalker)
	[323118] = 20,		-- Blood Barrage (Hakkar the Soulflayer)
	[331933] = 20,		-- Haywire (Defunct Dental Drill)
	[331398] = 20,		-- Volatile Capacitor (Volatile Memory)
	[331008] = 20,		-- Icky Sticky (Experimental Sludge)
	[323569] = 20,		-- Spilled Essence (Environment - Son of Hakkar boss version)
	[332332] = 20,		-- Spilled Essence (Environment - Son of Hakkar trash version)
	[323136] = 20,		-- Anima Starstorm (Runestag Elderhorn)
	[345498] = 20,		-- Anima Starstorm (Runestag Elderhorn)
	[340026] = 20,		-- Wailing Grief (Mythresh, Sky's Talons)
	[332729] = 20,		-- Malefic Blast (Environment - Dealer's Hallway)

	[324010] = 20,		-- Eruption (Millificent Manastorm)
	[320723] = 20,		-- Displaced Blastwave (Dealer Xy'exa)
	[320727] = 20,		-- Displaced Blastwave (Dealer Xy'exa)
	[320232] = 20,		-- Explosive Contrivance (Dealer Xy'exa)
	[334913] = 20,		-- Master of Death (Mueh'zala)
	[325691] = 20,		-- Cosmic Collapse (Mueh'zala)
	[335000] = 20,		-- Stellar Cloud (Mueh'zala)


	-- Spires of Ascension
	--[323786] = 20,		-- Swift Slice (Kyrian Dark-Praetor)
	[323740] = 20,		-- Impact (Forsworn Squad-Leader)
	[336447] = 20,		-- Crashing Strike (Forsworn Squad-Leader)
	[336444] = 20,		-- Crescendo (Forsworn Helion)
	[328466] = 20,		-- Charged Spear (Lakesis / Klotos)
	[336420] = 20,		-- Diminuendo (Klotos / Lakesis)

	[331251] = 20,		-- Deep Connection (Azules / Kin-Tara)
	[317626] = 20,		-- Maw-Touched Venom (Azules)
	-- [321034] = 20,		-- Charged Spear (Kin-Tara) Cannot be avoided
	[324662] = 20,		-- Ionized Plasma (Multiple) Can this be avoided?
	[324370] = 20,		-- Attenuated Barrage (Kin-Tara)
	[324141] = 20,		-- Dark Bolt (Ventunax)
	[323372] = 20,		-- Empyreal Ordnance (Oryphrion)
	[323792] = 20,		-- Anima Field (Oryphrion)
	[323943] = 20,		-- Run Through (Devos)
	-- [] = 20,		-- Seed of the Abyss (Devos) ???


	-- The Necrotic Wake
	[324391] = 20,		-- Frigid Spikes (Skeletal Monstrosity)
	[324381] = 20,		-- Chill Scythe / Reaping Winds (Skeletal Monstrosity)
	[323957] = 20,		-- Animate Dead (Zolramus Necromancer - summons Warrior)
	[324026] = 20,		-- Animate Dead (Zolramus Necromancer - summons Crossbowman)
	[324027] = 20,		-- Animate Dead (Zolramus Necromancer - summons Mage)
	[320574] = 20,		-- Shadow Well (Zolramus Sorcerer)
	[333477] = 20,		-- Gut Slice (Goregrind)
	[345625] = 20,		-- Death Burst (Nar'zudah)
	[327240] = 20,		-- Spine Crush (Loyal Creation)

	-- id ?[320637] = 20,		-- Fetid Gas (Blightbone)
	[319897] = 20,		-- Land of the Dead (Amarth - summons Crossbowman)
	[319902] = 20,		-- Land of the Dead (Amarth - summons Warrior)
	[333627] = 20,		-- Land of the Dead (Amarth - summons Mage)
	[321253] = 20,		-- Final Harvest (Amarth)
	[333489] = 20,		-- Necrotic Breath (Amarth)
	[333492] = 20,		-- Necrotic Ichor (Amarth apply by Necrotic Breath)
	[320365] = 20,		-- Embalming Ichor (Surgeon Stitchflesh)
	[320366] = 20,		-- Embalming Ichor (Surgeon Stitchflesh)
	[327952] = 20,		-- Meat Hook (Stitchflesh)
	[327100] = 20,		-- Noxious Fog (Stitchflesh)
	[328212] = 20,		-- Razorshard Ice (Nalthor the Rimebinder)
	[320784] = 20,		-- Comet Storm (Nalthor the Rimebinder)
	[321956] = 20,		-- Comet Storm (Nalthor the Rimebinder) (this one is for Dark Exiled players)


	-- Plaguefall
	[320072] = 20,		-- Toxic Pool (Decaying Flesh Giant)
	[330513] = 20,		-- Doom Shroom DoT (Environment)
	[327552] = 20,		-- Doom Shroom (Environment)
	-- id ?[335882] = 20,		-- Clinging Infestation (Fen Hatchling)
	[330404] = 20,		-- Wing Buffet (Plagueroc)
	-- id ?[320040] = 20,		-- Plagued Carrion (Decaying Flesh Giant)
	[344001] = 20,		-- Slime Trail (Environment)
	[318949] = 20,		-- Festering Belch (Blighted Spinebreaker)
	[320576] = 20,		-- Obliterating Ooze (Virulax Blightweaver)
	[319120] = 20,		-- Putrid Bile (Gushing Slime)
	[327233] = 20,		-- Belch Plague (Plagebelcher)
	[320519] = 20,		-- Jagged Spines (Blighted Spinebreaker)
	[328501] = 20,		-- Plague Bomb (Environment)
	[328986] = 20,		-- Violent Detonation (Environment - Unstable Canister)
	[330135] = 20,		-- Fount of Pestilence (Environment - Stradama's Slime)

	[324667] = 20,		-- Slime Wave (Globgrog)
	[326242] = 20,		-- Slime Wave DoT (Globgrog)
	[333808] = 20,		-- Oozing Outbreak (Doctor Ickus)
	[329217] = 20,		-- Slime Lunge (Doctor Ickus)
	[330026] = 20,		-- Slime Lunge (Doctor Ickus)
	[322475] = 20,		-- Plague Crash (Environment Margrave Stradama)


	-- Theater of Pain
	[342126] = 20,		-- Brutal Leap (Dokigg the Brutalizer)
	[337037] = 20,		-- Whirling Blade (Nekthara the Mangler) ?? TODO: Which one is correct?
	[336996] = 20,		-- Whirling Blade (Nekthara the Mangler) ?? TODO: Which one is correct?
	[317605] = 20,		-- Whirlwind (Nekthara the Mangler and Rek the Hardened)
	[332708] = 20,		-- Ground Smash (Heavin the Breaker)
	[334025] = 20,		-- Bloodthirsty Charge (Haruga the Bloodthirsty)
	[333301] = 20,		-- Curse of Desolation (Nefarious Darkspeaker)
	[333297] = 20,		-- Death Winds (Nefarious Darkspeaker)
	[331243] = 20,		-- Bone Spikes (Soulforged Bonereaver)
	[331224] = 20,		-- Bonestorm (Soulforged Bonereaver)
	[330592] = 20,		-- Vile Eruption (back) (Rancid Gasbag)
	[330608] = 20,		-- Vile Eruption (front) (Rancid Gasbag)
	[321039] = 20,		-- Disgusting Burst (Disgusting Refuse and Blighted Sludge-Spewer)
	[321041] = 20,		-- Disgusting Burst (Disgusting Refuse and Blighted Sludge-Spewer)

	[317231] = 20,		-- Crushing Slam (Xav the Unfallen)
	[339415] = 20,		-- Deafening Crash (Xav the Unfallen)
	[320729] = 20,		-- Massive Cleave (Xav the Unfallen)
	[318406] = 20,		-- Tenderizing Smash (Gorechop)
	[323406] = 20,		-- Jagged Gash (Gorechop)
	-- id ?[323542] = 20,		-- Oozing (Gorechop)
	[317367] = 20,		-- Necrotic Volley (Kul'tharok)
	[319639] = 20,		-- Grasping Hands (Kul'tharok)
	[323681] = 20,		-- Dark Devastation (Mordretha)
	[339550] = 20,		-- Echo of Battle (Mordretha)
	[323831] = 20,		-- Death Grasp (Mordretha)
	[339751] = 20,		-- Ghostly Charge (Mordretha)


	-- Sanguine Depths
	[334563] = 20,		-- Volatile Trap (Dreadful Huntmaster)
	[320991] = 20,		-- Echoing Thrust (Regal Mistdancer)
	[320999] = 20,		-- Echoing Thrust (Regal Mistdancer Mirror)
	[322418] = 20,		-- Craggy Fracture (Chamber Sentinel)
	[334378] = 20,		-- Explosive Vellum (Research Scribe)
	[323573] = 20,		-- Residue (Fleeting Manifestation)
	[334615] = 20,		-- Sweeping Slash (Head Custodian Javlin)
	[322212] = 20,		-- Growing Mistrust (Vestige of Doubt)

	[328494] = 20,		-- Sintouched Anima (Executor Tarvold)
	[325885] = 20,		-- Anguished Cries (Z'rali)
	[323810] = 20,		-- Piercing Blur (General Kaal)


	-- Halls of Atonement
	[325523] = 20,		-- Deadly Thrust (Depraved Darkblade)
	[325799] = 20,		-- Rapid Fire (Depraved Houndmaster)
	[326440] = 20,		-- Sin Quake (Shard of Halkias)
	[326997] = 20,		-- Powerful Swipe (Stoneborn Slasher)
	[326891] = 20,		-- Anguish (Inquisitor Sigar)

	[322945] = 20,		-- Heave Debris (Halkias)
	[324044] = 20,		-- Refracted Sinlight (Halkias)
	[319702] = 20,		-- Blood Torrent (Echelon)
	[319703] = 20,		-- Blood Torrent (Echelon)
	[329340] = 20,		-- Anima Fountain (High Adjudicator Aleez)
	[338013] = 20,		-- Anima Fountain (High Adjudicator Aleez)
	[323126] = 20,		-- Telekinetic Collision (Lord Chamberlain)
	[329113] = 20,		-- Telekinteic Onslaught (Lord Chamberlain)
	[327885] = 20,		-- Erupting Torment (Lord Chamberlain)
	[323236] = 20,		-- Unleashed Suffering (Lord Chamberlain)


	-- Tazavesh: Streets of Wonder
	[355903] = 20,		-- Disruption Grenade (Customs Security)
	[356011] = 20,		-- Beam Splicer (Armored Overseer / Tracker Zo'Korss)
	[355306] = 20,		-- Rift Blast (Portalmancer Zo'honn)
	[357019] = 20,		-- Lightshard Retreat (Cartel Wiseguy)
	[355502] = 20,		-- Shocklight Barrier (Environment)
	[355476] = 20,		-- Shock Mines (Commander Zo'far)
	[355487] = 20,		-- Lethal Force (Commander Zo'far)

	[348366] = 20,		-- Armed Security (Zo'phex)
	[357799] = 20,		-- Bounced! (Zo'gron)
	[350921] = 20,		-- Crowd Control (Zo'gron)
	[356482] = 20,		-- Rotten Food (Zo'gron)
	[346329] = 20,		-- Spilled Liquids (P.O.S.T. Master)
	[349801] = 20,		-- Grand Consumption (Alcruux)
	[349663] = 20,		-- Grip of Hunger (Alcruux)
	[349999] = 20,		-- Anima Detonation (Achillite) TODO avoidable?
	[351070] = 20,		-- Venting Concussion (Achillite) TODO avoidable?
	[349989] = 20,		-- Volatile Anima TODO verify
	[350090] = 20,		-- Whirling Annihilation (Venza Goldfuse)
	[347481] = 20,		-- Shuri (So'azmi)


	-- Tazavesh: So'leah's Gambit
	[355423] = 20,		-- Volatile Pufferfish (Murkbrine Fishmancer)
	[355465] = 20,		-- Boulder Throw (Coastwalker Goliath)
	[355581] = 20,		-- Crackle (Stormforged Guardian)
	[355584] = 20,		-- Charged Pulse (Stormforged Guardian)
	[356260] = 20,		-- Tidal Burst (Hourglass Tidesage)
	[357228] = 20,		-- Drifting Star (Adorned Starseer)

	--[346828] = 20,	-- Sanitizing Field (Hylbrande) - more like a wipe mechanic
	[356796] = 20,		-- Runic Feedback (Hylbrande)
	[346960] = 20,		-- Purged by Fire (Hylbrande)
	[346961] = 20,		-- Purging Field (Hylbrande)
	[347094] = 20,		-- Titanic Crash (Hylbrande)
	[347149] = 20,		-- Infinite Breath (Timecap'n Hooktail)
	[347370] = 20,		-- Cannon Barrage (Timecap'n Hooktail)
	[358947] = 20,		-- Burning Tar (Timecap'n Hooktail)
	[347151] = 20,		-- Hook Swipe (Timecap'n Hooktail)
	[354334] = 20,		-- Hook'd! (Timecap'n Hooktail)
	--[?] = 20,			-- Deadly Seas (Timecap'n Hooktail) (oneshot from going in water, debuff?)
	[351101] = 20,		-- Energy Fragmentation (So'leah)
	[351646] = 20,		-- Hyperlight Nova (So'leah)
	--]=====]


	-- [**Battle for Azeroth**] 
	
	-- Waycrest Manor
	[264531] = 20,		--- Shrapnel Trap (Maddened Survivalist)
	[264476] = 20,		--- Tracking Explosive (Crazed Marksman)
	[260569] = 20,		--- Wildfire (Soulbound Goliath)
	[265407] = 20,		--- Dinner Bell (Banquet Steward)
	[264923] = 20,		--- Tenderize (Raal the Gluttonous)
	[264712] = 20,		--- Rotten Expulsion (Raal the Gluttonous)
	[272669] = 20,		--- Burning Fists (Soulbound Goliath)
	[278849] = 20,		--- Uproot (Coven Thornshaper)
	[264040] = 20,		--- Uprooted Thorns (Coven Thornshaper)
	[265757] = 20,		--- Splinter Spike (Matron Bryndle)
	[264150] = 20,		--- Shatter (Thornguard)
	[268387] = 20,		--- Contagious Remnants (Lord Waycrest)
	[268308] = 20,		--- Discordant Cadenza (Lady Waycrest

	-- Atal'Dazar
	[253666] = 20,		--- Fiery Bolt (Dazar'ai Juggernaught)
	[257692] = 20,		--- Tiki Blaze (Environment)
	[255620] = 20,		--- Festering Eruption (Reanimated Honor Guard)
	[258723] = 20,		--- Grotesque Pool (Renaimated Honor Guard)
	[250259] = 20,		--- Toxic Leap (Vol'kaal)
	[250022] = 20,		--- Echoes of Shadra (Yazma)
	[250585] = 20, 		--- Toxic Pool (Vol'kaal)
	[250036] = 20,		--- Shadowy Remains (Echoes of Shadra)
	[255567] = 20,		--- Frenzied Charge (T'lonja)
	--[=====[
	-- The Underrot
	[265540] = 20, -- Rotten Bile (Fetid Maggot)
	[265542] = 20, -- Rotten Bile (Fetid Maggot)
	[265019] = 20, -- Savage Cleave (Chosen Blood Matron)
	[278789] = 20, -- Wave of Decay (Living Rot)
	[265665] = 20, -- Foul Sludge (Living Rot)
	[265511] = 20, -- Spirit Drain (Spirit Drain Totem, Bloodsworn Defiler)
	[272609] = 20, -- Maddening Gaze (Faceless Corruptor)
	[272469] = 20, -- Abyssal Slam (Abyssal Reach, Faceless Corruptor)

	[261498] = 20, -- Creeping Rot (Elder Leaxa)
	[264757] = 20, -- Sanguine Feast (Elder Leaxa)
	[260312] = 20, -- Charge (Cragmaw the Infested)
	[259720] = 20, -- Upheaval (Sporecaller Zancha)
	--[259714] = 20, -- Decaying Spores, Hit (Sporecaller Zancha) - might be necessary to eat
	[269843] = 20, -- Vile Expulsion, Impact (Unbound Abomination)
	[269838] = 20, -- Vile Expulsion, periodic (Unbound Abomination)
	[270108] = 20, -- Rotting Spore (Unbound Abomination)


	-- Freehold
	[258673] = 20, -- Azerite Grenade (Irontide Crackshot)
	[257426] = 20, -- Brutal Backhand (Irontide Enforcer)
	[258779] = 20, -- Sea Spout (Irontide Oarsman)
	[274400] = 20, -- Duelist Dash (Cutwater Duelist)
	[274389] = 20, -- Rat Traps (Vermin Trapper)
	[295945] = 20, -- Rat Traps (Vermin Trapper)
	[257757] = 20, -- Goin' Bananas (Bilge Rat Buccaneer)
	[276061] = 20, -- Boulder Throw (Irontide Crusher)
	[258199] = 20, -- Ground Shatter (Irontide Crusher)
	[257737] = 20, -- Thundering Squall (Irontide Stormcaller)
	[257871] = 20, -- Blade Barrage (Irontide Buccaneer)

	[258773] = 20, -- Charrrrrge (Sharkbait, Skycap'n Kragg)
	[257274] = 20, -- Vile Coating (Sharkbait, Skycap'n Kragg)
	[272046] = 20, -- Dive Bomb (Sharkbait, Skycap'n Kragg)
	[256594] = 20, -- Barrel Smash (Captain Raoul, Council o' Captains)
	[258352] = 20, -- Grapeshot (Captain Eudora, Council o' Captains)
	[267523] = 20, -- Cutting Surge (Captain Jolly, Council o' Captains) - not active in DF S2
	[272374] = 20, -- Whirlpool of Blades, Impact (Captain Jolly, Council o' Captains) - not active in DF S2
	[272397] = 20, -- Whirlpool of Blades, periodic (Captain Jolly, Council o' Captains) - not active in DF S2
	[278467] = 20, -- Caustic Freehold Brew (Rummy Mancomb, Council o' Captains)
	[257902] = 20, -- Shell Bounce (Ludwig Von Tortollan, Ring of Booty)
	[256546] = 20, -- Shark Tornado (Trothak, Ring of Booty)
	--[256477] = 20, -- Shark Toss (Trothak, Ring of Booty) - TODO is this avoidable?
	[256552] = 20, -- Flailing Shark (Trothak, Ring of Booty)
	[256706] = 20, -- Rearm (Trothak, Ring of Booty)
	[268287] = 20, -- Rotten Food (Booty Fanatic, Ring of Booty)
	[257310] = 20, -- Cannon Barrage (Harlan Sweete)
	[257963] = 20, -- Cannon Barrage (Harlan Sweete) - TODO ID?
	[257460] = 20, -- Fiery Debris (Harlan Sweete)
	[413146] = 20, -- Swiftwind Saber (Harlan Sweete)
	[257293] = 20, -- Swiftwind Saber (Harlan Sweete) - TODO ID?
	[257315] = 20, -- Black Powder Bomb (Irontide Grenadier, Harlan Sweete)

	-- Operation: Mechagon - Junkyard
	[300816] = 20,		-- Slimewave (Slime Elemental)
	[300188] = 20,		-- Scrap Cannon (Weaponized Crawler)
	[300427] = 20,		-- Shockwave (Scrapbone Bully)
	[294890] = 20,		-- Gryro-Scrap (Malfunctioning Scrapbot)
	[300129] = 20,		-- Self-Destruct Protocol (Malfunctioning Scrapbot)
	[300561] = 20,		-- Explosion (Scrapbone Trashtosser)
	[299475] = 20,		-- B.O.R.K (Scraphound)
	[299535] = 20,		-- Scrap Blast (Pistonhead Blaster)
	[301680] = 20,		-- Rapid Fire (Mechagon Cavalry)

	[297283] = 20,		-- Cave In (King Gobbamak)
	[298940] = 20,		-- Bolt Buster (Naeno Megacrash)
	[295552] = 20,		-- Cannon Blast (HK-8 Aerial Oppression Unit)
	[296150] = 20,		-- Vent Blast (HK-8 Aerial Oppression Unit - Environment)


	-- Operation: Mechagon - Workshop
	[294128] = 20,		-- Rocket Barrage (Rocket Tonk)
	[293861] = 20,		-- Anti-Personnel Squirrel (Anti-Personnel Squirrel)
	[294324] = 20,		-- Mega Drill (Waste Processing Unit)
	[295168] = 20,		-- Capacitor Discharge (Blastatron X-80)
	[293986] = 20,		-- Sonic Pulse (Blastatron X-80)

	[285020] = 20,		-- Whirling Edge (The Platinum Pummeler)
	[282943] = 20,		-- Piston Smasher (Tussle Tonks - Environmnet)
	[283422] = 20,		-- Maximum Thrust (Gnomercy 4.U.)
	[291930] = 20,		-- Air Drop (K.U-J.0)
	[291949] = 20,		-- Venting Flames (K.U-J.0)
	[294954] = 20,		-- Self-Trimming Hedge (Machinist's Garden)
	[285443] = 20,		-- "Hidden" Flame Cannon (Machinist's Garden)
	[285460] = 20,		-- Discom-BOMB-ulator (Machinist's Garden)
	[294869] = 20,		-- Roaring Flame (Machinist's Garden)
	[291915] = 20,		-- Plasma Orb (King Mechagon)
	--]=====]


	-- [**Legion**] 

	-- Black Rook Hold
	[197821] = 20,		-- Felblazed Ground (Illysanna Ravencrest, AoE Ground from Eye Beams)
	[197521] = 20,		-- Blazing Trail (Illysanna Ravencrest)
	[198820] = 20,		-- Dark Blast (Latosius)
	[199567] = 20,		-- Dark Obliteration (Image of Latosius)
	[200256] = 20,		-- Phased Explosion (Arcane Minion)
	[198781] = 20,		-- Whirling Blade (Lord Kur'talos Ravencrest)
	[196517] = 20,		-- Swirling Scythe (Amalgam of Souls)
	[222397] = 20,		-- Boulder Crush (Environment)
	[198501] = 20,		-- Fel Vomitus (Smashspite the Hateful)
	[201062] = 20,		-- Bowled Over! (Wyrmtonge Scavanger)
	[200914] = 50,		-- Indigestion (Wyrmtonge Scavanger)
	
	
	-- Darkheart Thicket
	[204402] = 20,		-- Star Shower (Dreadsoul Ruiner)
	[201273] = 10,		-- Blood Bomb (Bloodtainted Fury)
	[201227] = 20,		-- Blood Assault (Bloodtainted Fury)
	[201123] = 20,		-- Root Burst (Vilethorn Blossom)
	[198386] = 20,		-- Primal Rampage (Archdruid Glaidalis)
	[201191] = 20,      -- Dreadburst (Red Blood Blobs)
	[191326] = 20,		-- Breath of Corruption (Dresaron)
	[198408] = 20,		-- Nightfall (Archdruid Glaidalis)
	[218759] = 20,		-- Corruption Pool (Festerhide Grizzly)
	[200771] = 20,		-- Propelling Charge (Crazed Razorbeak)
	[198916] = 20,		-- Vile Burst (Vile Mushroom)
		--[=====[
	-- Neltharion's Lair
	[183407] = 20, -- Acid Splatter (Vileshard Crawler)
	[183465] = 20, -- Viscid Bile (Tarspitter Lurker)
	[226388] = 20, -- Rancid Ooze (Tarspitter Luker)
	[226287] = 20, -- Crush (Vileshard Chunk)
	[183088] = 20, -- Avalanche, Frontal (Mightstone Breaker)
	[183100] = 20, -- Avalanche, Rocks (Mightstone Breaker)
	[186576] = 20, -- Petrifying Cloud (Petrifying Totem, Blightshard Shaper)
	[202089] = 20, -- Scorch (Burning Geode)
	--[183566] = 20, -- Rancid Pool (Rotdrool Grabber, Stoneclaw Grubmaster) - not really avoidable

	[198028] = 20, -- Crystalline Ground (Rokmora)
	[188169] = 20, -- Razor Shards (Rokmora)
	[192800] = 20, -- Choking Dust (Blightshard Skitter, Rokmora)
	[198475] = 20, -- Strike of the Mountain (Ularogg Cragshaper)
	[210166] = 20, -- Toxic Retch, Area (Naraxas)
	[199705] = 20, -- Devouring (Naraxas)
	[200338] = 20, -- Crystal Spikes (Dargrul)
	[217090] = 20, -- Magma Wave, Initial (Dargrul)
	[200404] = 20, -- Magma Wave, Final (Dargrul)
	[216407] = 20, -- Lava Geyser (Dargrul)


	-- Court of Stars
	[209027] = 20, -- Quelling Strike (Duskwatch Guard)
	[209477] = 20, -- Wild Detonation (Mana Wyrm)
	[212031] = 20, -- Charged Blast (Bound Energy)
	[209404] = 20, -- Seal Magic (Duskwatch Arcanist)
	[211391] = 20, -- Felblaze Puddle (Legion Hound) - TODO is first tick avoidable?

	[206574] = 20, -- Resonant Slash, Front (Patrol Captain Gerdo)
	[206580] = 20, -- Resonant Slash, Back (Patrol Captain Gerdo)
	[219498] = 20, -- Streetsweeper (Patrol Captain Gerdo)
	[209378] = 20, -- Whirling Blades (Imacu'tya, Talixae Flamewreath)
	[207979] = 20, -- Shockwave (Jazshariu, Talixae Flamewreath)
	[397903] = 20, -- Crushing Leap (Jazshariu, Talixae Flamewreath)
	[207887] = 20, -- Infernal Eruption, Impact (Talixae Flamewreath)
	[211457] = 20, -- Infernal Eruption, Area (Talixae Flamewreath)
	[209628] = 20, -- Piercing Gale (Advisor Melandrus)
	[209630] = 20, -- Piercing Gale (Image of Advisor Melandrus, Advisor Melandrus)
	[209667] = 20, -- Blade Surge (Advisor Melandrus)


	-- Halls of Valor

	[198903] = 20, -- Crackling Storm (Storm Drake)
	[210875] = 20, -- Charged Pulse (Stormforged Sentinel)
	[199818] = 20, -- Crackle (Stormforged Sentinel)
	[199210] = 20, -- Penetrating Shot (Valarjar Marksman)
	[192565] = 20, -- Cleansing Flames (Valarjar Purifier)
	[191508] = 20, -- Blast of Light (Valarjar Aspirant)
	[199337] = 20, -- Bear Trap (Valarjar Trapper)
	[199146] = 20, -- Bucking Charge (Gildedfur Stag)
	[199090] = 20, -- Rumbling Stomp (Angerhoof Bull)

	[193234] = 20, -- Dancing Blade (Hymdall)
	[193260] = 20, -- Static Field (Storm Drake, Hymdall)
	[188395] = 20, -- Ball Lightning (Storm Drake, Hymdall)
	[192206] = 20, -- Sanctify, Orb (Olmyr the Enlightened / Hyrja) - TODO does separate tracking work?
	--[215457] = 20, -- Sanctify, Group Explosion (Olmyr the Enlightened / Hyrja)
	[193827] = 20, -- Ragnarok (God-King Skovald)
	[193702] = 20, -- Infernal Flames (God-King Skovald)
	[198263] = 20, -- Radiant Tempest (Odyn)
	[198088] = 20, -- Glowing Fragment (Odyn)
	[198412] = 20, -- Feedback (Odyn)
	

	-- Return to Karazhan: Lower
	[228001] = 20,		-- Pennies From Heaven (Ghostly Philanthropist)
	[227917] = 20,		-- Poetry Slam (Ghostly Understudy)
	[227925] = 20,		-- Final Curtain (Ghostly Understudy)
	[238606] = 20,		-- Arcane Eruption (Arcane Warden)
	[228625] = 20,		-- Banshee Wail (Wholesome Host / Wholesome Hostess)
	[227977] = 20,		-- Flashlight (Skeletal Usher)
	--[241774] = 20,		-- Shield Smash (Phantom Guardsman) TODO avoidable?
	[228603] = 20,		-- Charge (Spectral Charger)

	[227568] = 20,		-- Burning Leg Sweep (Toe Knee, Opera Hall: Westside Story)
	[227480] = 20,		-- Flame Gale (Toe Knee, Opera Hall: Westside Story)
	[227799] = 20,		-- Wash Away (Mrrgria, Opera Hall: Westside Story)
	[228221] = 20,		-- Severe Dusting (Babblet, Opera Hall: Beautiful Beast)
	[227645] = 20,		-- Spectral Charge (Midnight)
	[227339] = 20,		-- Mezair (Midnight)
	[227651] = 20,		-- Iron Whirlwind (Baron Rafe Dreuger)
	[227473] = 20,		-- Whirling Edge (Lord Robin Daris)
	[227672] = 20,		-- Will Breaker (Lord Crispin Ference)

	-- Return to Karazhan: Upper
	[229563] = 20,		-- Knight Move (Knight)
	[229298] = 20,		-- Knight Move (Knight)
	[229559] = 20,		-- Bishop Move (Bishop)
	[229384] = 20,		-- Queen Move (Queen)
	[229568] = 20,		-- Rook Move (Rook)
	[229427] = 20,		-- Royal Slash (King)
	[242894] = 20,		-- Unstable Energy (Damaged Golem)
	[227806] = 20,		-- Ceaseless Winter (Shade of Medivh)
	[227620] = 20,		-- Arcane Bomb (Mana Devourer)
	[229248] = 20,		-- Fel Beam (Command Ship, Viz'aduum the Watcher)
	[229285] = 20,		-- Bombardment (Command Ship, Viz'aduum the Watcher)
	[229151] = 20,		-- Disintegrate (Viz'aduum the Watcher)
	[229161] = 20,		-- Explosive Shadows (Viz'aduum the Watcher)
	[227465] = 20,		-- Power Discharge (The Curator)
	[227285] = 20,		-- Power Discharge (The Curator)
	[229988] = 20,		-- Burning Tile (Wrathguard Flamebringer)
	--]=====]
	
	
	-- [**Warlords of Draenor**] 
	--[=====[
	-- Shadowmoon Burial Grounds
	[152688] = 20, -- Shadow Rune (Environment)
	[152690] = 20, -- Shadow Rune (Environment)
	[152696] = 20, -- Shadow Rune (Environment)
	[152854] = 20, -- Void Sphere (Shadowmoon Loyalist) - TODO which is correct?
	[152855] = 20, -- Void Sphere (Shadowmoon Loyalist) - TODO which is correct?
	[398154] = 20, -- Cry of Anguish (Defiled Spirit)
	[394524] = 20, -- Void Eruptions (Void Spawn)
	[153395] = 20, -- Body Slam (Carrion Worm)

	[153232] = 20, -- Daggerfall (Sadana Bloodfury)
	[153373] = 20, -- Daggerfall (Sadana Bloodfury) - TODO is this relevant?
	[153224] = 20, -- Shadow Burn (Sadana Bloodfury)
	[152800] = 20, -- Void Vortex (Nhallish)
	[153070] = 20, -- Void Devastation (Nhallish)
	[153908] = 20, -- Inhale (Bonemaw)
	[153686] = 20, -- Body Slam (Bonemaw)
	--[153692] = 20, -- Necrotic Pitch (Bonemaw) - can be used to avoid Inhale
	[154442] = 20, -- Malevolence (Ner'zhul)
	[154468] = 20, -- Ritual of Bones, Area (Ner'zhul)
	[154469] = 20, -- Ritual of Bones, Debuff (Ner'zhul)
	

	-- Iron Docks
	[172963] = 20,		-- Gatecrasher (Siegemaster Olugar, Siegemaster Rokra)
	[167516] = 20,		-- Shrapnel Blast (Grom'kar Incinerator) TODO avoidable?
	[164632] = 20,		-- Burning Arrows (Grom'kar Flameslinger)
	[173105] = 20,		-- Whirling Chains (Grom'kar Chainmaster)
	[168514] = 20,		-- Cannon Barrage (Environment)
	[168540] = 20,		-- Cannon Barrage (Environment)
	[173324] = 20,		-- Jagged Caltrops (Thunderlord Wrangler)
	[173517] = 20,		-- Lava Blast (Ironwing Flamespitter)

	[164734] = 20,		-- Shredding Swipes (Dreadfang) TODO always avoidable?
	[163276] = 20,		-- Shredded Tendons (Grimrail Enforcers)
	[163668] = 20,		-- Flaming Slash (Grimrail Enforcers - Makogg Emberblade)
	[165152] = 20,		-- Lava Sweep (Grimrail Enforcers - Makogg Emberblade)
	[161256] = 20,		-- Primal Assault (Oshir)
	[168148] = 20,		-- Cannon Barrage (Skulloc)
	[168390] = 20,		-- Cannon Barrage (Skulloc)
	[169129] = 20,		-- Backdraft (Skulloc)


	-- Grimrail Depot
	[164188] = 20,		-- Blackrock Bomb (Grimrail Bombardier)
	[176131] = 20,		-- Cannon Barrage (Grom'kar Boomer)
	[160963] = 20,		-- Blackrock Mortar (Grom'kar Boomer)
	[166676] = 20,		-- Shrapnel Blast (Grom'kar Gunner)
	[176147] = 20,		-- Ignite (Grom'kar Gunner)
	[176033] = 20,		-- Flametongue (Grom'kar Cinderseer)
	[167038] = 20,		-- Slag Tanker (Environmnet)
	[166404] = 20,		-- Arcane Blitz (Grimrail Scout)
	[166340] = 20,		-- Thunder Zone (Grom'kar Far Seer) TODO some ticks not avoidable?
	--[166336] = 20,		-- Storm Shield (Grom'kar Far Seer) TODO damage reflect that chains... avoidable?

	[162513] = 20,		-- VX18-B Target Eliminator (Railmaster Rocketspark)
	[163741] = 20,		-- Blackrock Mortar (Nitrogg Thundertower)
	[161220] = 20,		-- Suppressive Fire (Nitrogg Thundertower)
	[166570] = 20,		-- Slag Blast (Nitrogg Thundertower)
	[156303] = 20,		-- Shrapnel Blast (Grom'kar Gunner)
	[162065] = 20,		-- Freezing Snare (Skylord Tovra)
	--[161588] = 20,		-- Diffused Energy (Skylord Tovra) TODO some ticks not avoidable?
	[162057] = 20,		-- Spinning Spear (Skylord Tovra)
	



	-- [**Mist of Pandaria**] 
	--[=====[
	-- Temple of the Jade Serpent
	[397881] = 20, -- Surging Deluge (Corrupt Living Water)
	[396003] = 20, -- Territorial Display (The Songbird Queen)
	[396010] = 20, -- Tears of Pain (The Crybaby Hozen)
	[398301] = 20, -- Flames of Doubt (Shambling Infester)
	[397899] = 20, -- Leg Sweep (Sha-Touched Guardian)
	[110125] = 20, -- Shattered Resolve (Minion of Doubt)

	[397785] = 20, -- Wash Away (Wise Mari)
	[397793] = 20, -- Corrupted Geyser (Wise Mari)
	[106856] = 20, -- Serpent Kick (Liu Flameheart)
	[106938] = 20, -- Serpent Wave (Liu Flameheart)
	[106864] = 20, -- Jade Serpent Kick (Liu Flameheart)
	[107053] = 20, -- Jade Serpent Wave, Projectile (Liu Flameheart)
	[118540] = 20, -- Jade Serpent Wave, Area (Liu Flameheart)
	[396907] = 20, -- Jade Fire Breath (Yu'lon, Liu Flameheart)
	[107103] = 20, -- Jade Fire, Impact (Yu'lon, Liu Flameheart)
	[107110] = 20, -- Jade Fire, Area (Yu'lon, Liu Flameheart)
	--]=====]


	-- [**Cataclysm**] 
	--[=====[
	-- Vortex Pinnacle
	[410999] = 20, -- Pressurized Blast (Armored Mistral)
	--[411001] = 20, -- Lethal Current (Lurking Tempest) - should this be considered avoidable?
	[411005] = 20, -- Bomb Cyclone (Cloud Prince)
	[88308] = 20, -- Chilling Breath (Young Storm Dragon / Altairus)
	[88963] = 20, -- Lightning Lash (Minister of Air)
	[413386] = 20, -- Overload Grounding Field (Minister of Air)

	[86292] = 20, -- Cyclone Shield / Cyclone Shield Fragment (Grand Vizier Ertan)
	[413319] = 20, -- Downwind of Altairus (Altairus)
	[413271] = 20, -- Downburst Impact (Altairus)
	[413296] = 20, -- Downburst, Ring (Altairus)
	[413275] = 20, -- Cold Front (Environment, Altairus)
	[87553] = 20, -- Supremacy of the Storm (Asaad)
	[87618] = 20 -- Static Cling (Asaad)
		--]=====]

}

local SpellsNoTank = {
	-- [**Dragonflight**]
	
	--[=====[
	-- Uldaman: Legacy of Tyr
    [369409] = 20, -- Cleave (Earthen Custodian)
    [369563] = 20, -- Wild Cleave (Baelog, The Lost Dwarves)
    [369061] = 20, -- Searing Clap (Emberon)
    [375727] = 20, -- Sand Breath (Chrono-Lord Deios)

    -- Neltharus
    [384019] = 20, -- Fiery Focus (Chargath, Bane of Scales)
	
	   -- Halls of Infusion
    [375349] = 20, -- Gusting Breath (Gusting Proto-Drake)
    [375341] = 20, -- Tectonic Breath (Subterranean Proto-Drake)
    [375353] = 20, -- Oceanic Breath (Glacial Proto-Drake)
    [384524] = 20, -- Titanic Fist (Watcher Irideus)
	
	    -- Brackenhide Hollow
    [382712] = 20, -- Necrotic Breath, Initial (Wilted Oak)
    [382805] = 20, -- Necrotic Breath, DoT (Wilted Oak)
  	--[374544] = 20, -- Burst of Decay (Fetid Rotsinger) - TODO does this only target tank?
    [377807] = 20, -- Cleave (Rira Hackclaw)
    [381419] = 20, -- Savage Charge (Rira Hackclaw)
    [377559] = 20, -- Vine Whip (Treemouth)
	
	
    -- The Nokhud Offensive
    [384512] = 20, -- Cleaving Strikes (Nokhud Lancemaster / Nokhud Defender)
    [387135] = 20, -- Arcing Strike (Primalist Arcblade)



    -- The Azure Vault
    [370764] = 20, -- Piercing Shards (Crystal Fury)
    [391120] = 20, -- Spellfrost Breath (Scalebane Lieutenant)
    [372222] = 20, -- Arcane Cleave (Azureblade)



    -- Algeth'ar Academy
	[385958] = 20, -- Arcane Expulsion (Vexamus)
	--]=====]

	-- Dawn of the Infinite: Galakrond's Fall
	[413532] = 20, -- Untwist, Frontal (Timestream Anomaly)
	[414304] = 20, -- Unwind (Manifested Timeways)
	[407159] = 20, -- Blight Reclamation (Blight of Galakrond)

	-- Dawn of the Infinite: Murozond's Rise
	[412505] = 20, -- Rending Cleave (Tyr's Vanguard)
	[419351] = 20, -- Bronze Exhalation (Infinite Saboteur / Infinite Slayer)
	[418092] = 20, -- Twisted Timeways (Environment) - TODO is this reasonable?
	[413532] = 20, -- Untwist, Frontal (Timestream Anomaly)
	[412029] = 20, -- Millennium Aid (Infinite Timebender)
	[417339] = 20, -- Titanic Blow (Tyr, the Infinite Keeper)
	[404917] = 20, -- Sand Blast (Morchie)
	[416139] = 20, -- Temporal Breath (Chrono-Lord Deios)


	--[=====[
	-- [**Shadowlands**]

	-- Mists of Tirna Scithe
	[331721] = 20,		-- Spear Flurry (Mistveil Defender)

	-- De Other Side
	[332157] = 20,		-- Spinning Up (Headless Client)

	-- Spires of Ascension
	[317943] = 20,		-- Sweeping Blow (Frostsworn Vanguard)
	[324608] = 20,		-- Charged Stomp (Oryphrion)

	-- The Necrotic Wake
	[324323] = 20,		-- Gruesome Cleave (Skeletal Marauder)
	[323489] = 20,		-- Throw Cleaver (Flesh Crafter, Stitching Assistant)

	-- Plaguefall
	-- Theater of Pain
	-- Sanguine Depths

	-- Halls of Atonement
	--[323001] = 20,		-- Glass Shards (Halkias) This is always unavoidable for tanks but sometimes unavoidable for everyone
	[322936] = 20,		-- Crumbling Slam (Halkias)
	[346866] = 20,		-- Stone Breath (Loyal Stoneborn)

	-- Tazavesh: Streets of Wonder
	-- Tazavesh: So'leah's Gambit

	
	
	-- [**Battle for Azeroth**]  
	--]=====]
		-- Waycrest Manor
	[263905] = 20,		--- Marking Cleave (Heartsbane Runeweaver)
	[265372] = 20,		---	Shadow Cleave (Enthralled Guard)
	[271174] = 20,		--- Retch (Pallid Gorger)
	--[=====[ 
	-- The Underrot
	[260793] = 20, -- Indigestion (Cragmaw the Infested)
	[272457] = 20, -- Shockwave (Sporecaller Zancha)
  
  
	-- [**Legion**]
	

	-- Neltharion's Lair
	[193505] = 20, -- Fracture (Vileshard Hulk)
	[226296] = 20, -- Piercing Shards (Vileshard Hulk)
	[226304] = 20, -- Piercing Shards (Vileshard Hulk)
	[226347] = 20, -- Stone Shatter (Stoneclaw Hunter / Stoneclaw Grubmaster)
	[226406] = 20, -- Ember Swipe (Emberhusk Dominator)
	[188494] = 20, -- Rancid Maw (Naraxas)
	[205609] = 20, -- Rancid Maw (Naraxas) - TODO ID?
	[200721] = 20, -- Landslide (Dargrul)
	

	-- Operation: Mechagon - Junkyard
	-- Operation: Mechagon - Workshop
	[294291] = 20,		-- Process Waste (Waste Processing Unit)
	
	-- Court of Stars	
	[209036] = 20, -- Throw Torch (Duskwatch Sentry)
	[209495] = 20, -- Charged Smash (Guardian Construct)
	[209512] = 20, -- Disrupting Energy (Guardian Construct)

	-- Halls of Valor
	[198888] = 20, -- Lightning Breath (Storm Drake) - TODO is this avoidable by tank?
	[199050] = 20, -- Mortal Hew (Valarjar Shieldmaiden)
	[192018] = 20, -- Shield of Light (Hyrja)
	
	
	-- Return to Karazhan: Lower
	[227493] = 20,		-- Mortal Strike (Attumen the Huntsman)
	
	
	-- Return to Karazhan: Upper
	[229608] = 20,		-- Mighty Swing (Erudite Slayer)
	--]=====]


	-- [**Warlords of Draenor**] 
	--[=====[
	-- Shadowmoon Burial Grounds
	[153501] = 20 -- Void Blast (Nhallish)

	-- Iron Docks
	[167233] = 20,		-- Bladestorm (Grom'kar Battlemaster, Pitwarden Gwarnok)
	[167815] = 20,		-- Rending Cleave (Thunderlord Wrangler)
	[168401] = 20,		-- Bladestorm (Koramar)

	-- Grimrail Depot
	[166380] = 20,		-- Reckless Slash (Grom'kar Captain) TODO always targets tank? avoidable by tank?
	[161089] = 20,		-- Mad Dash (Borka the Brute) TODO avoidable by tank?
	[164163] = 20,		-- Hewing Swipe (Grimrail Overseer)
	--]=====]

	-- [**Mist of Pandaria**] 
	-- Temple of the Jade Serpent

}

local Auras = {
	-- Affixes
	[408777] = true, -- Entangled, Stun (Environment)

	-- [**Dragonflight**]
	--[=====[ 
	-- Uldaman: Legacy of Tyr
    [372652] = true, -- Resonating Orb (Sentinel Talondras)
	

    -- The Azure Vault
    [386368] = true, -- Polymorphed (Polymorphic Rune, Environment)
    [396722] = true, -- Absolute Zero, Root (Telash Greywing)
  	--]=====]

  	-- Dawn of the Infinite: Galakrond's Fall
  	[418346] = true, -- Corrupted Mind (Blight of Galakrond)

  	-- Dawn of the Infinite: Murozond's Rise
  	[401667] = true, -- Time Stasis (Morchie)

	--[=====[ 
	-- [**Shadowlands**]

	-- Affixes seasons
	[358973] = true,	-- Wave of Terror (Season 2 Affix - Varruth)
	[373391] = true,	-- Nightmare (Season 4 Affix - Nightmare Cloud)
	
	-- Mists of Tirna Scithe

	-- De Other Side
	[331381] = true,	-- Slipped (Lubricator)
	[334505] = true,	-- Shimmerdust Sleep (Weald Shimmermoth)

	-- Spires of Ascension
	[324205] = true,	-- Blinding Flash (Ventunax)

	-- The Necrotic Wake
	[324293] = true,	-- Rasping Scream (Skeletal Marauder)

	-- Plaguefall
	[330092] = true,	-- Plaguefallen (Environment)
	[336301] = true,	-- Web Wrap (Domina Venomblade)

	-- Theater of Pain
	-- Sanguine Depths
	-- Halls of Atonement



	-- Tazavesh: Streets of Wonder
	-- Tazavesh: So'leah's Gambit 
	--]=====]
	
	-- [**Battle for Azeroth**] 
	
		-- Waycrest Manor
	[265352] = true,		-- Toad Blight (Toad)
	[278468] = true,		-- Freezing Trap
	
	-- Atal'Dazar
	[255371] = true,		-- Terrifying Visage (Rezan)
	
	--[=====[ 
	-- Freehold
	[274516] = true, -- Slippery Suds (Bilge Rat Swabby)
	[272554] = true, -- Bloody Mess (Trothak, Ring of Booty)


	-- Operation: Mechagon - Junkyard
	[398529] = true,	-- Gooped (Gunker)
	[300659] = true,	-- Consuming Slime (Toxic Monstrosity)
	--]=====]

	-- Operation: Mechagon - Workshop
	
	-- [**Legion**] 
	--[=====[
	-- Return to Karazhan: Lower
	-- Return to Karazhan: Upper
	-- Court of Stars
	[214987] = true, -- Righteous Indignation (Suspicious Noble) - TODO find ID for stun
	[224333] = true, -- Enveloping Winds (Advisor Melandrus)
	--]=====]
	
	-- [**Warlords of Draenor**]
	--[=====[ 	
	-- Iron Docks
	[164504] = true,	-- Intimidated (Fleshrender Nok'gar)
	[172631] = true,	-- Knocked Down (Slippery Grease)
	-- Grimrail Depot
	--]=====]


	-- [**Mist of Pandaria**] 

}

local AurasNoTank = {
}

local MeleeHitters = {
	--[161917] = 20,		-- DEBUG
	[174773] = 20,		-- Spiteful Shade
}

local function compareSemver(ver1, ver2)
	local ver1Segments = {strsplit(".", ver1)}
	local ver2Segments = {strsplit(".", ver2)}

	local maxSegments = math.max(#ver1Segments, #ver2Segments)
	for i = 1, maxSegments do
		local ver1Segment = tonumber(ver1Segments[i]) or 0
		local ver2Segment = tonumber(ver2Segments[i]) or 0

		if ver1Segment > ver2Segment then
			return 1
		elseif ver1Segment < ver2Segment then
			return -1
		end
	end
	return 0
end

function round(number, decimals)
	return (("%%.%df"):format(decimals)):format(number)
end

local ElitismFrame = CreateFrame("Frame", "ElitismFrame")
ElitismFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
local MSG_PREFIX = "ElitismHelper"
local success = C_ChatInfo.RegisterAddonMessagePrefix(MSG_PREFIX)
ElitismFrame:RegisterEvent("CHAT_MSG_ADDON")
ElitismFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
ElitismFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ElitismFrame:RegisterEvent("CHALLENGE_MODE_START")
ElitismFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
ElitismFrame:RegisterEvent("ADDON_LOADED")

ElitismFrame:ClearAllPoints()
ElitismFrame:SetHeight(100)
ElitismFrame:SetWidth(100)
ElitismFrame.text = ElitismFrame:CreateFontString(nil, "BACKGROUND", "PVPInfoTextFont")
ElitismFrame.text:SetAllPoints()
ElitismFrame.text:SetTextHeight(13)
ElitismFrame:SetAlpha(1)

function table.pack(...)
	return { n = select("#", ...), ... }
end

ElitismFrame:SetScript("OnEvent", function(self, event_name, ...)
	if self[event_name] then
		return self[event_name](self, event_name, ...)
	end
end)

function generateMaybeOutput(user)
	local func = function()
			local msg = "<EH> "..user.." got hit by "
			local sending = false
			local _i = 0
			for spellID,amount in pairs(TimerData[user]) do
				local minPct = math.huge
				local spellMinPct = nil
				if Spells[spellID] then
					spellMinPct = Spells[spellID]
				elseif SpellsNoTank[spellID] then
					spellMinPct = SpellsNoTank[spellID]
				end
				if spellMinPct ~= nil and spellMinPct < minPct then
					minPct = spellMinPct
				end
				if minPct == math.huge then
					local spellNames = " "
					for spellID,amount in pairs(TimerData[user]) do
						spellNames = spellNames..GetSpellLink(spellID).." "
					end
					print("<EH> Error: Could not find spells"..spellNames.."in Spells or SpellsNoTank but got Timer for them. wtf")
				end
				local userMaxHealth = UnitHealthMax(user)
				local msgAmount = round(amount / 1000, 1)
				local pct = Round(amount / userMaxHealth * 100)
				if pct >= ElitismHelperDB.Threshold and pct >= minPct and ElitismHelperDB.Loud then
					if _i > 0 then
						msg = msg.." and "..GetSpellLink(spellID).." "
					else
						msg = msg..GetSpellLink(spellID).." "
					end
					msg = msg.."for "..msgAmount.."k ("..pct.."%)"
					sending = true
					_i = _i + 1
				end
			end
			msg = msg.."."
			if sending then
				maybeSendChatMessage(msg)
			end
			TimerData[user] = nil
			Timers[user] = nil
		end
	return func
end

function generateMaybeMeleeOutput(user)
	local func = function()
			local msg = "<EH> "..user.." got hit by "
			local sending = false
			for srcID,obj in pairs(TimerMeleeData[user]) do
				local name = obj.name
				local amount = obj.amount
				local userMaxHealth = UnitHealthMax(user)
				local msgAmount = round(amount / 1000, 1)
				local pct = Round(amount / userMaxHealth * 100)
				if pct > MeleeHitters[srcID] and pct > ElitismHelperDB.Threshold and ElitismHelperDB.Loud then
					msg = msg..name.." for "..msgAmount.."k ("..pct.."%)"
					sending = true
				end
			end
			msg = msg.."."
			if sending then
				maybeSendChatMessage(msg)
			end
			TimerMeleeData[user] = nil
			TimersMelee[user] = nil
		end
	return func
end

SLASH_ELITISMHELPER1 = "/eh"

SlashCmdList["ELITISMHELPER"] = function(msg,editBox)
	function enableElitismHelper()
		if ElitismHelperDB.Loud then
			print("ElitismHelper: Damage notifications are already enabled.")
		else
			ElitismHelperDB.Loud = true
			print("ElitismHelper: All damage notifications enabled.")
		end
	end
	function disableElisitmHelper()
		if not ElitismHelperDB.Loud then
			print("ElitismHelper: Damage notifications are already disabled.")
		else
			ElitismHelperDB.Loud = false
			if ElitismHelperDB.EndOfDungeonMessage then
				print("ElitismHelper: Will only announce at the end of the dungeon.")
			else
				print("ElitismHelper: All notifications are disabled.")
			end
		end
	end

	actions = {
		["activeUser"] = function()
			print("activeUser is "..activeUser)
			if activeUser == playerUser then
				print("You are the activeUser")
			end
		end,
		["resync"] = function()
			ElitismFrame:RebuildTable()
		end,
		["table"] = function()
			for k,v in pairs(Users) do
				local out = ""
				out = out..k
				for i, m in ipairs(v) do
					out = out..";;;"..m
				end
				print(out)
			end
		end,
		["start"] = function()
			ElitismFrame:CHALLENGE_MODE_START()
		end,
		["eod"] = function()
			ElitismFrame:CHALLENGE_MODE_COMPLETED()
		end,
		["eodon"] = function()
			if ElitismHelperDB.EndOfDungeonMessage then
				print("ElitismHelper: End-of-dungeon message is already enabled.")
			else
				ElitismHelperDB.EndOfDungeonMessage = true
				print("ElitismHelper: Will announce at the end of the dungeon.")
			end
		end,
		["eodoff"] = function()
			if not ElitismHelperDB.EndOfDungeonMessage then
				print("ElitismHelper: End-of-dungeon message is already disabled.")
			else
				ElitismHelperDB.EndOfDungeonMessage = false
				print("ElitismHelper: Will not announce at the end of the dungeon.")
			end
		end,
		["on"] = enableElitismHelper,
		["enable"] = enableElitismHelper,
		["off"] = disableElisitmHelper,
		["disable"] = disableElisitmHelper,
		["output"] = function(argsFunc)
			if argsFunc == "default" then
				ElitismHelperDB.OutputMode = "default"
				print("Output set to party in parties, raid in raids")
			elseif argsFunc == "party" then
				ElitismHelperDB.OutputMode = "party"
				print("Output set to party/raid always")
			elseif argsFunc == "yell" then
				ElitismHelperDB.OutputMode = "yell"
				print("Output set to yell always")
			elseif argsFunc == "emote" then
				ElitismHelperDB.OutputMode = "emote"
				print("Output set to emote always")
			elseif argsFunc == "self" then
				ElitismHelperDB.OutputMode = "self"
				print("Output set to self only always")
			else
				print("Valid targets are default | party | raid | yell | emote | self")
				print("Current target is "..ElitismHelperDB.OutputMode)
			end
			ElitismFrame:RebuildTable()
		end,
		["help"] = function()
			print("Elitism Helper options:")
			print(" on/enable: Enable Elitism Helper announcer")
			print(" off/disable: Disable Elitism Helper announcer")
			print(" eodon: Enable Elitism Helper end-of-dungeon stats")
			print(" eodoff: Disable Elitism Helper end-of-dungeon stats")
			print(" output: Define output channel between default | party | raid | yell | self")
			print(" ------ This is more or less for debugging ------")
			print(" start: Start logging avoidable damage")
			print(" eod: Dungeon is complete")
			print(" table: Prints users")
			print(" resync: Rebuilts table")
			print(" activeUser: Prints active user")
			print(" list: Locally print failed abilities and damage taken")
			print(" threshold : Configure the thresold damage")
			print(" messageTest : Testing output")
		end,
		["threshold"] = function(args)
			thresholdNumber = tonumber(args, 10)
			if thresholdNumber == nil then
				print("Sets threshold of health lost to notify on (as percentage): `/eh threshold 100` will show notifications for one-shot damage (> 100%)")
				print(" Current Threshold: " .. ElitismHelperDB.Threshold)
			elseif (thresholdNumber > 100 or thresholdNumber < 0) then
				print("Error: Threshold value over 100 or under 0: " .. args)
			else
				ElitismHelperDB.Threshold = thresholdNumber
				print("Threshold Set to " .. thresholdNumber .. "%")
			end
		end,
		["messageTest"] = function()
			print("Testing output for "..ElitismHelperDB.OutputMode)
			maybeSendChatMessage("This is a test message")
		end,
		["list"] = function(args)
			local name = args

			if FailByAbility[name] == nil then
				name = GetUnitName(args, true)
			end

			if name == nil or FailByAbility[name] == nil then
				name = GetUnitName(args)
			end

			if name == nil or FailByAbility[name] == nil then
				for player,fails in pairs(FailByAbility) do
					print("Hits for "..player)
					for k,v in pairs(fails) do
						print(" " .. v.cnt .. "x" .. GetSpellLink(k) .. " = " .. round(v.sum / 1000, 1) .. "k")
					end
				end
			else
				--print("hits for " .. name)
				maybeSendChatMessage("Hits for "..name)

				local delay = 0;

				for k,v in pairs(FailByAbility[name]) do
					--print(v.cnt .. "x" .. GetSpellLink(k) .. " = " .. round(v.sum / 1000, 1) .. "k; " .. delay)
					--maybeSendChatMessage(v.cnt .. "x" .. GetSpellLink(k) .. " = " .. round(v.sum / 1000, 1) .. "k")
					delayMaybeSendChatMessage(v.cnt .. "x" .. GetSpellLink(k) .. " = " .. round(v.sum / 1000, 1) .. "k", delay * 0.1)
					delay = delay + 1
				end
			end
		end
	}

	local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
	local commandFunction = actions[cmd]
	if not commandFunction then
		commandFunction = actions["help"]
		InterfaceOptionsFrame_OpenToCategory(addonTable.UIPanel);
	end
	commandFunction(args)
	addonTable.UIPanel:refreshValues();
end

function maybeSendAddonMessage(prefix, message)
	if IsInGroup() and not IsInGroup(2) and not IsInRaid() then
		C_ChatInfo.SendAddonMessage(prefix,message,"PARTY")
	elseif IsInGroup() and not IsInGroup(2) and IsInRaid() then
		C_ChatInfo.SendAddonMessage(prefix,message,"RAID")
	end
end

function maybeSendChatMessage(message)
	if activeUser ~= playerUser then
		return
	end
	if ElitismHelperDB.OutputMode == "self" then
		print(message)
	elseif ElitismHelperDB.OutputMode == "party" and IsInGroup() and not IsInGroup(2) then
		SendChatMessage(message,"PARTY")
	elseif ElitismHelperDB.OutputMode == "raid" and IsInGroup() and not IsInGroup(2) and IsInRaid() then
		SendChatMessage(message,"RAID")
	elseif ElitismHelperDB.OutputMode == "yell" then
		SendChatMessage(message,"YELL")
	elseif ElitismHelperDB.OutputMode == "emote" then
		SendChatMessage(message,"EMOTE")
	elseif ElitismHelperDB.OutputMode == "default" then
		if IsInGroup() and not IsInGroup(2) and not IsInRaid() then
			SendChatMessage(message,"PARTY")
		elseif IsInGroup() and not IsInGroup(2) and IsInRaid() then
			SendChatMessage(message,"RAID")
		end
	end
end

function delayMaybeSendChatMessage(message, delay)
	C_Timer.After(
		delay,
		function()
			maybeSendChatMessage(message)
		end
	)
end

function ElitismFrame:RebuildTable()
	Users = {}
	activeUser = nil
	-- print("Reset Addon Users table")
	if IsInGroup() then
		maybeSendAddonMessage(MSG_PREFIX,"VREQ")
	else
		name = GetUnitName("player",true)
		activeUser = name.."-"..GetRealmName()
		-- print("We are alone, activeUser: "..activeUser)
	end
end

function ElitismFrame:ADDON_LOADED(event,addon)
	if addon == "ElitismHelper" then
		ElitismFrame:RebuildTable()

		if not ElitismHelperDB then
			ElitismHelperDB = defaultElitismHelperDBValues
		end

		-- Backwards compatibility to make sure that DB values will always be set, even when updating from previous versions
		for key, defaultValue in pairs(defaultElitismHelperDBValues) do
			if ElitismHelperDB[key] == nil then
				ElitismHelperDB[key] = defaultValue
			end
		end
	end
end

function ElitismFrame:GROUP_ROSTER_UPDATE(event,...)
	-- print("GROUP_ROSTER_UPDATE")
	ElitismFrame:RebuildTable()
end

function ElitismFrame:ZONE_CHANGED_NEW_AREA(event,...)
	-- print("ZONE_CHANGED_NEW_AREA")
	ElitismFrame:RebuildTable()
end

function compareDamage(a,b)
	return a["value"] < b["value"]
end

function ElitismFrame:CHALLENGE_MODE_COMPLETED(event,...)
	if ElitismHelperDB.EndOfDungeonMessage then
		local count = 0
		for _ in pairs(CombinedFails) do count = count + 1 end
		if count == 0 then
			print("No Damage?");
			--maybeSendChatMessage("Thank you for travelling with ElitismHelper.)
			--maybeSendChatMessage("<EH> No avoidable damage was taken this run.")
			return
		else
			maybeSendChatMessage("Thank you for travelling with ElitismHelper.")
			maybeSendChatMessage("<EH> Amount of avoidable damage:")
		end
		local u = { }
		for k, v in pairs(CombinedFails) do table.insert(u, { key = k, value = v }) end
		table.sort(u, compareDamage)
		for k,v in pairs(u) do
				maybeSendChatMessage(k..". "..v["key"].." "..round(v["value"] / 1000, 1).."k")
		end
	end
end

function ElitismFrame:CHALLENGE_MODE_START(event,...)
	CombinedFails = {}
	FailByAbility = {}
	print("Avoidable damage now being recorded.")
end

function ElitismFrame:SplitString(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end


function ElitismFrame:CHAT_MSG_ADDON(event,...)
	local prefix, message, channel, sender = select(1,...)
	if prefix ~= MSG_PREFIX then
		return
	end
	if message == "VREQ" then
		maybeSendAddonMessage(MSG_PREFIX,"VANS;"..AddonVersion..";"..ElitismHelperDB.OutputMode)
	elseif message:match("^VANS") then
		local msg = ElitismFrame:SplitString(message,";")
		if(msg[1] == nil or msg[2] == nil) then
			print("Received invalid EH message, ignoring: "..message)
			return
		end

		Users[sender] = msg
		activeUser = nil
		local activeUserObject = nil

		for k,v in pairs(Users) do
			-- Ignore users that only report to self. ==nil is legacy for old versions, accept them, delete this later and require AddonVersion>=0.2
			if(v[3] == nil or v[3] ~= "self") then
				if activeUserObject == nil then
					activeUserObject = {k, v}
				end

				local incomingVersion = v[2]
				local activeVersion = activeUserObject[2][2]
				if compareSemver(incomingVersion, activeVersion) > 0 then
					activeUserObject = {k, v}
				end
				
				--Use alphabet as tie breaker
				if(activeUserObject[2][2] == v[2]) then
					if k < activeUserObject[1] then
						activeUserObject = {k, v}
					end
				end

			end
		end

		-- We are in a group but nobody is eligible...
		if(activeUserObject == nil) then
			activeUser = playerUser
		else
			activeUser = activeUserObject[1]
		end
	else
		-- print("Unknown message: "..message)
	end
end

function ElitismFrame:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, aAmount)
	if (Spells[spellId] or (SpellsNoTank[spellId] and UnitGroupRolesAssigned(dstName) ~= "TANK")) and UnitIsPlayer(dstName) then
		-- Initialize TimerData and CombinedFails for Timer shot
		if TimerData[dstName] == nil then
			TimerData[dstName] = {}
		end
		if CombinedFails[dstName] == nil then
			CombinedFails[dstName] = 0
		end

		-- Add this event to TimerData / CombinedFails
		CombinedFails[dstName] = CombinedFails[dstName] + aAmount
		if TimerData[dstName][spellId] == nil then
			TimerData[dstName][spellId] = aAmount
		else
			TimerData[dstName][spellId] = TimerData[dstName][spellId] + aAmount
		end

		-- If there is no timer yet, start one with this event
		if Timers[dstName] == nil then
			Timers[dstName] = true
			C_Timer.After(4,generateMaybeOutput(dstName))
		end

		-- Add hit and damage to table
		if FailByAbility[dstName] == nil then
			FailByAbility[dstName] = {}
		end

		if FailByAbility[dstName][spellId] == nil then
			FailByAbility[dstName][spellId] = {
				cnt = 0,
				sum = 0
			}
		end

		FailByAbility[dstName][spellId].cnt = FailByAbility[dstName][spellId].cnt + 1
		FailByAbility[dstName][spellId].sum = FailByAbility[dstName][spellId].sum + aAmount
	end
end

function ElitismFrame:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)
	if(not srcGUID:match("^Creature")) then
		return
	end
	local srcSplit = ElitismFrame:SplitString(srcGUID,"-")
	local srcID = tonumber(srcSplit[#srcSplit-1])
	--print(dstName.." got hit by "..srcName.." ("..srcGUID..") for "..aAmount.." srcID:"..srcID)
	if(MeleeHitters[srcID] and UnitIsPlayer(dstName)) then
		--print("I should track this")

		-- Initialize TimerMeleeData for Timer shot
		if TimerMeleeData[dstName] == nil then
			TimerMeleeData[dstName] = {}
		end

		if CombinedFails[dstName] == nil then
			CombinedFails[dstName] = 0
		end

		CombinedFails[dstName] = CombinedFails[dstName] + aAmount

		if TimerMeleeData[dstName][srcID] == nil then
			TimerMeleeData[dstName][srcID] = {name=srcName, amount=aAmount}
		else
			TimerMeleeData[dstName][srcID].amount = TimerMeleeData[dstName][srcID].amount + aAmount
		end

		-- If there is no timer yet, start one with this event
		if TimersMelee[dstName] == nil then
			TimersMelee[dstName] = true
			C_Timer.After(8,generateMaybeMeleeOutput(dstName))
		end
	end
end

function ElitismFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
	if (Auras[spellId] or (AurasNoTank[spellId] and UnitGroupRolesAssigned(dstName) ~= "TANK")) and UnitIsPlayer(dstName) then
		if auraAmount and ElitismHelperDB.Loud then
			maybeSendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..". "..auraAmount.." Stacks.")
		elseif ElitismHelperDB.Loud then
			maybeSendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..".")
		end
	end
end

function ElitismFrame:COMBAT_LOG_EVENT_UNFILTERED(event,...)
	local timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2 = CombatLogGetCurrentEventInfo(); -- Those arguments appear for all combat event variants.
	local eventPrefix, eventSuffix = eventType:match("^(.-)_?([^_]*)$");
	if (eventPrefix:match("^SPELL") or eventPrefix:match("^RANGE")) and eventSuffix == "DAMAGE" then
		local spellId, spellName, spellSchool, sAmount, aOverkill, sSchool, sResisted, sBlocked, sAbsorbed, sCritical, sGlancing, sCrushing, sOffhand, _ = select(12, CombatLogGetCurrentEventInfo())
		ElitismFrame:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, sAmount)
	elseif eventPrefix:match("^SWING") and eventSuffix == "DAMAGE" then
		local aAmount, aOverkill, aSchool, aResisted, aBlocked, aAbsorbed, aCritical, aGlancing, aCrushing, aOffhand, _ = select(12, CombatLogGetCurrentEventInfo())
		ElitismFrame:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)
	elseif eventPrefix:match("^SPELL") and eventSuffix == "MISSED" then
		local spellId, spellName, spellSchool, missType, isOffHand, mAmount = select(12, CombatLogGetCurrentEventInfo())
		if mAmount then
			ElitismFrame:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, mAmount)
		end
	elseif eventType == "SPELL_AURA_APPLIED" then
		local spellId, spellName, spellSchool, auraType = select(12, CombatLogGetCurrentEventInfo())
		ElitismFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType)
	elseif eventType == "SPELL_AURA_APPLIED_DOSE" then
		local spellId, spellName, spellSchool, auraType, auraAmount = select(12, CombatLogGetCurrentEventInfo())
		ElitismFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
	end
end
