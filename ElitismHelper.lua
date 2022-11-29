local Users = {}
local Timers = {}
local TimerData = {}
local TimersMelee = {}
local TimerMeleeData = {}
local CombinedFails = {}
local FailByAbility = {}
local activeUser = nil
local AddonVersion = 0.13
local playerUser = GetUnitName("player", true).."-"..GetRealmName():gsub(" ", "")
local defaultElitismHelperDBValues = {
	Loud = true,
	Threshold = 30,
	OutputMode = "default",
	EndOfDungeonMessage = true
}

local OutputModes = {
	["default"] = 0,
	["party"] = 1,
	["yell"] = 2,
	["self"] = 3,
}

local Spells = {

	-- Debug
	--[] = 20,		-- ()
	--[=====[ --]=====] -- Currently disabled for this seasons / Don't remove, possibly used in a future rotation
	
	--[252144] = 1,
	--[190984] = 1,		 -- DEBUG Druid Wrath
	--[285452] = 1,		 -- DEBUG Shaman Lava Burst
	--[188389] = 1,		 -- DEBUG Shaman Flame Shock

	-- Affixes
	[209862] = 20,		-- Volcanic Plume (Environment)
	[226512] = 20,		-- Sanguine Ichor (Environment)
	[240448] = 20,		-- Quaking (Environment)
	[343520] = 20,		-- Storming (Environment)
	[350163] = 20,		-- Melee (Spiteful Shade)


	-- [**Dragonflight**]
	-- Affixes seasons
	
	-- Algeh'ar Academy S1
	[386201] = 20,		-- Corruped Mana (Vexamus)
	[388796] = 20,		-- Germinate (Overgrown Ancient)
	[374361] = 20,		-- Astral Breath (Echo of Doragosa)
	
	-- Brackenhide Hollow
	
	-- Hall Of Infusion
	
	-- Neltharus 
	[374854] = 20, 		-- Erupted Ground (Chargath, bane of Scales)
	[373767] = 20,		-- Magma Wave (Chargath, bane of Scales)
	[377995] = 20,		-- Forgestorm (Forgemaster Gorek)
	[377204] = 20,		-- Berserk Barrage (Warlord Sargha)
	
	-- Ruby Life Pools 
	[372107] = 20,		-- Molten Boulder (Kokia Blazehoof)
	
	-- The Azure Vault 
	[385578] = 20,		-- Arcane Orb (AzureBlade)
	[372222] = 20,		-- Arcane Slicer (AzureBlade)
	[384699] = 20,		-- Crystalline Roar (Umbrelskul)

	-- The Nokhud Offensive
	[384186] = 20,		-- Lighting Strike (The Raging Tempest)
	[385339] = 20,		-- Earthsplitter (Teera and Maruuk)
	[382670] = 20,		-- Gale Arrow (Teera and Maruuk)
	[376683] = 20,		-- Iron Stampede (Balakar Khan)
	[393421] = 20,		-- Quake (Balakar Khan)
	-- Uldaman : Legacy of Tyr
	
	
	-- [**Shadowlands**]
	--[=====[ 
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
	
	[373513] = 20,		-- Shadow Eruption (Season 4 Zul'gamux)
	[373429] = 20,		-- Carrion Swarm (Season 4 Nathrezim Infiltrator)

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
	--[=====[
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
	-- Court of Stars
	[219498] = 20,		-- Streetsweeper (Patrol Captain Gerdo)
	[206574] = 20,		-- Resonant Slash (Patrol Captain Gerdo)
	[206580] = 20,		-- Resonant Slash (Patrol Captain Gerdo)
	[209477] = 20,		-- Wild Detonation (Mana Wyrm)
	[211457] = 20,		-- Infernal Eruption (Talixae Flamewreath)
	[209630] = 20,		-- Piercing Gale (Images of Advisor Melandrus)
	[209628] = 20,		-- Piercing Gale (Advisor Melandrus)
	[214688] = 20,		-- Carrion Swarm (Gerenth the Vile)
	
	-- Halls of Valor
	[192206] = 20,		-- Sanctify (Olmyr & Hyrja)
	[199210] = 20,		-- Penetrating Shot (Valarjar Marksman)
	[210875] = 20,		-- Charged Pulse (Stormforged Sentinel)
	[193234] = 20,		-- Dancing Blade (Hymdall)
	[193260] = 20,		-- Static Field (Storm Drake, Hymdall)
	[188395] = 20,		-- Ball Lightning (Static Field, Hymdall)
	
	--[=====[
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
	
	-- [**Mist of Pandaria**] 
	
	-- Temple of the Jade Serpent
	[115167] = 20, 		-- Corrupted Waters (Wise Mari)
	[106334] = 20, 		-- Wash Away (Wise Mari)
	[106938] = 20, 		-- Serpent Wave (Liu FlameHeart)
	[107053] = 20, 		-- Jade Serpent Wave (Liu FlameHeart)
	[107045] = 20, 		-- Jade Fire (Liu FlameHeart)
	
	-- [**Warlords of Draenor**] 
	-- Shadowmoon Burial Grounds
	[153395] = 20,		-- Body Slam (Bonemaw)
	[154442] = 20,		-- %amevpme,ce (Ner'zhul)
	
	--[=====[
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
	--]=====]

}

local SpellsNoTank = {

	-- [**Dragonflight**]

	-- [**Shadowlands**]
	--[=====[
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
	--]=====]
	
	-- [**Battle for Azeroth**] 
	
	--[=====[
	-- Operation: Mechagon - Junkyard
	-- Operation: Mechagon - Workshop
	[294291] = 20,		-- Process Waste (Waste Processing Unit)
	--]=====]
	
	-- [**Legion**]
	-- Court of Stars	
	-- Halls of Valor
	
	--[=====[ 
	-- Return to Karazhan: Lower
	[227493] = 20,		-- Mortal Strike (Attumen the Huntsman)
	-- Return to Karazhan: Upper
	[229608] = 20,		-- Mighty Swing (Erudite Slayer)
	--]=====]
	
	-- [**Mist of Pandaria**] 
	-- Temple of the Jade Serpent
	
	-- [**Warlords of Draenor**] 
	-- Shadowmoon Burial Grounds
	
	--[=====[
	-- Iron Docks
	[167233] = 20,		-- Bladestorm (Grom'kar Battlemaster, Pitwarden Gwarnok)
	[167815] = 20,		-- Rending Cleave (Thunderlord Wrangler)
	[168401] = 20,		-- Bladestorm (Koramar)

	-- Grimrail Depot
	[166380] = 20,		-- Reckless Slash (Grom'kar Captain) TODO always targets tank? avoidable by tank?
	[161089] = 20,		-- Mad Dash (Borka the Brute) TODO avoidable by tank?
	[164163] = 20,		-- Hewing Swipe (Grimrail Overseer)
	--]=====]
	

}

local Auras = {
	-- [**Dragonflight**]
	
	
	-- [**Shadowlands**]
	--[=====[ 
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
	--[=====[ 
	-- Operation: Mechagon - Junkyard
	[398529] = true,	-- Gooped (Gunker)
	[300659] = true,	-- Consuming Slime (Toxic Monstrosity)
	--]=====]

	-- Operation: Mechagon - Workshop
	
	-- [**Legion**] 	
	-- Return to Karazhan: Lower
	-- Return to Karazhan: Upper
	
	-- [**Mist of Pandaria**] 
	
	
	-- [**Warlords of Draenor**]
	--[=====[ 	
	-- Iron Docks
	[164504] = true,	-- Intimidated (Fleshrender Nok'gar)
	[172631] = true,	-- Knocked Down (Slippery Grease)
	-- Grimrail Depot
	--]=====]


}

local AurasNoTank = {
}

local MeleeHitters = {
	--[161917] = 20,		-- DEBUG
	[174773] = 20,		-- Spiteful Shade
}

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
	end
	commandFunction(args)
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


				--If the request sender has a higher version make them active
				if(activeUserObject[2][2] < v[2]) then
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
		if(activeUser == nil) then
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
