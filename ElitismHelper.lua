local Users = {}
local Timers = {}
local TimerData = {}
local CombinedFails = {}
local FailByAbility = {}
local activeUser = nil
local playerUser = GetUnitName("player",true).."-"..GetRealmName():gsub(" ", "")
local hardMinPct = 40

local Spells = {
	-- Debug
	--[252144] = 1,
	--[252150] = 1,

  -- Reaping
	--[290085] = 20,          -- Expel Soul (Environment)
	[296142] = 20,          -- Shadow Smash (Lost Soul)
	-- [288693] = 20,          -- Grave Bolt (Tormented Soul) Is this really avoidable?
	
	-- Affixes
	[209862] = 20,		-- Volcanic Plume (Environment)
	[226512] = 20,		-- Sanguine Ichor (Environment)

	-- Freehold
	[272046] = 20,		--- Dive Bomb (Sharkbait)
	[257426] = 20,		--- Brutal Backhand (Irontide Enforcer)
	[258352] = 20,		--- Grapeshot (Captain Eudora)
	[256594] = 20,		--- Barrel Smash (Captain Raoul)
	[272374] = 20,		--- Whirlpool of Blades (Captain Jolly)
	[256546] = 20,		--- Shark Tornado (Trothak)
	[257310] = 20,		--- Cannon Barrage (Harlan Sweete)
	[257784] = 20,		--- Frost Blast (Bilge Rat Brinescale)
	[257902] = 20,		--- Shell Bounce (Ludwig Von Tortollan)
	[258199] = 20,		--- Ground Shatter (Irontide Crusher)
	[276061] = 20,		--- Boulder Throw (Irontide Crusher)
	[258779] = 20,		--- Sea Spout (Irontide Oarsman)
	[274400] = 20,		--- Duelist Dash (Cutwater Duelist)
	[257274] = 20,		--- Vile Coating (Environment)
	[258673] = 20,		--- Azerite Grenade (Irontide Crackshot)
	[274389] = 20,		--- Rat Traps (Vermin Trapper)
	[257460] = 20,		--- Fiery Debris (Harlan Sweete)
	--[257871] = 20,		--- Blade Barrage (Irontide Buccaneer)
	--[257757] = 20,		--- Goin' Bananas (Bilge Rat Buccaneer)
	
	-- Shrine of the Storm
	[276268] = 20,		--- Heaving Blow (Shrine Templar)
	[267973] = 20,		--- Wash Away (Temple Attendant)
	[268059] = 20,		--- Anchor of Binding (Tidesage Spiritualist)
	[264155] = 20,		--- Surging Rush (Aqu'sirr)
	[267841] = 20,		--- Blowback (Galecaller Faye)
	[267899] = 20,		--- Hindering Cleave (Brother Ironhull)
	[268280] = 20,		--- Tidal Pod (Tidesage Enforcer)
	[276286] = 20,		--- Slicing Hurricane (Galecaller Apprentice)
	[276292] = 20,		--- Whirlign Slam (Ironhull Apprentice)
	[267385] = 20,		--- Tentacle Slam (Vol'zith the Whisperer)
	
	-- Siege of Boralus
	[256627] = 20,		--- Slobber Knocker (Kul Tiran Halberd)
	[256663] = 20,		--- Burning Tar (Blacktar Bomber)
	[275775] = 20,		--- Savage Tempest (Irontide Raider)
	[257292] = 20,		--- Heavy Slash (Kul Tiran Vanguard)
	[272426] = 20,		--- Sighted Artillery (Ashvane Spotter)
	[257069] = 20,		--- Watertight Shell (Kul Tiran Wavetender)
	[273681] = 20,		--- Heavy Hitter (Chopper Redhook)
	[272874] = 20,		--- Trample (Ashvane Commander)
	[268260] = 20,		--- Broadside (Ashvane Cannoneer)
	[269029] = 20,		--- Clear the Deck (Dread Captain Lockwood)
	[268443] = 20,		--- Dread Volley (Dread Captain Lockwood)
	[272713] = 20,		--- Crushing Slam (Bilge Rat Demolisher)
	[274941] = 20,		--- Banana Rampage swirlies(Bilge Rat Buccaneer)
	[257883] = 20,		--- Break Water (Hadal Darkfathom)
	[276068] = 20,		--- Tidal Surge (Hadal Darkfathom)
	[257886] = 20,		--- Brine Pool (Hadal Darkfathom)
	[261565] = 20,		--- Crashing Tide (Hadal Darkfathom)
	[277535] = 20,		--- Viq'Goth's Wrath (Viq'Goth)
	
	-- Tol Dagor
	[257119] = 20,		--- Sand Trap (The Sand Queen)
	[257785] = 20,		--- Flashing Daggers (Jes Howlis)
	[256976] = 20,		--- Ignition (Knight Captain Valyri)
	[256955] = 20,		--- Cinderflame (Knight Captain Valyri)
	[256083] = 20,		--- Cross Ignition (Overseer Korgus)
	[263345] = 20,		--- Massive Blast (Overseer Korgus)
	[258364] = 20,		--- Fuselighter (Ashvane Flamecaster)
	[259711] = 20,		--- Lockdown (Ashvane Warden)
	[256710] = 20,		--- Burning Arsenal (Knight Captain Valyri)
	
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

	-- King's Rest
	[270003] = 20,		--- Suppression Slam (Animated Guardian)
	[269932] = 20,		--- Ghust Slash (Shadow-Borne Warrior)
	[265781] = 20,		--- Serpentine Gust (The Golden Serpent)
	[265914] = 20,		--- Molten Gold (The Golden Serpent)
	[270928] = 20,		--- Bladestorm (King Timalji)
	[270931] = 20,		--- Darkshot (Queen Patlaa)
	[270891] = 20,		--- Channel Lightning (King Rahu'ai)
	[266191] = 20,		--- Whirling Axe (Council of Tribes)
	[270292] = 20,		--- Purifying Flame (Purification Construct)
	[270503] = 20,		--- Hunting Leap (Honored Raptor)
	[270514] = 20,		--- Ground Crush (Spectral Brute)
	[271564] = 20,		--- Embalming Fluid (Embalming Fluid)
	[270485] = 20,		--- Blooded Leap (Spectral Berserker)
	[267639] = 20,		--- Burn Corruption (Mchimba the Embalmer)
	[268419] = 20,		--- Gale Slash (King Dazar)
	[268796] = 20,		--- Impaling Spear (King Dazar)
	
	-- The MOTHERLODE!!
	[257371] = 20,		--- Gas Can (Mechanized Peace Keeper)
	[262287] = 20,		--- Concussion Charge (Mech Jockey / Venture Co. Skyscorcher)
	[268365] = 20,		--- Mining Charge (Wanton Sapper)
	[269313] = 20,		--- Final Blast (Wanton Sapper)
	[275907] = 20,		--- Tectonic Smash (Azerokk)
	[259533] = 20,		--- Azerite Catalyst (Rixxa Fluxflame)
	[260103] = 20,		--- Propellant Blast (Rixxa Fluxflame)
	[260279] = 20,		--- Gattling Gun (Mogul Razdunk)
	[276234] = 20, 		--- Micro Missiles (Mogul Razdunk)
	[270277] = 20,		--- Big Red Rocket (Mogul Razdunk)
	[271432] = 20,		--- Test Missile (Venture Co. War Machine)
	--[262348] = 20,		--- Mine Blast (Crawler Mine)
	[257337] = 20,		--- Shocking Claw (Coin-Operated Pummeler)
	[268417] = 20,		--- Power Through (Azerite Extractor)
	[268704] = 20,		--- Furious Quake (Stonefury)
	[258628] = 20,		--- Resonant Quake (Earthrager)
	[269092] = 20,		--- Artillery Barrage (Ordnance Specialist)
	[271583] = 20,		--- Black Powder Special (Mines near the track)
	[269831] = 20,		--- Toxic Sludge (Oil Environment)

	-- Temple of Sethraliss
	[263425] = 20,		--- Arc Dash (Adderis)
	[268851] = 20,		--- Lightning Shield (Aspix and Adderis)
	[263573] = 20,		--- Cyclone Strike (Adderis)
	[273225] = 20,		--- Volley (Sandswept Marksman)
	[272655] = 20,		--- Scouring Sand (Mature Krolusk)
	[273995] = 20,		--- Pyrrhic Blast (Crazed Incubator)
	[272696] = 20,		--- Lightning in a Bottle (Crazed Incubator)
	[264206] = 20,		--- Burrow (Merektha)
	[272657] = 20,		--- Noxious Breath (Merektha)
	[272821] = 20,		--- Call Lightning (Imbued Stormcaller)
	[264763] = 20,		--- Spark (Static-charged Dervish)
	[279014] = 20,		--- Cardiac Shock (Avatar, Environment)
	
	-- Underrot
	[265542] = 20,		--- Rotten Bile (Fetid Maggot)
	[265019] = 20,		--- Savage Cleave (Chosen Blood Matron)
	[261498] = 20,		--- Creeping Rot (Elder Leaxa)
	[264757] = 20,		--- Sanguine Feast (Elder Leaxa)
	[265665] = 20,		--- Foul Sludge (Living Rot)
	[260312] = 20,		--- Charge (Cragmaw the Infested)
	[265511] = 20,		--- Spirit Drain (Spirit Drain Totem)
	[259720] = 20,		--- Upheaval (Sporecaller Zancha)
	[270108] = 20,		--- Rotting Spore (Unbound Abomination)
	[272609] = 20,		--- Maddenin Gaze (Faceless Corruptor)
	[272469] = 20,		--- Abyssal Slam (Faceless Corruptor)
	[270108] = 20,		--- Rotting Spore (Unbound Abomination)
	
	-- Mechagon Workshop
	[294128] = 20,		--- Rocket Barrage (Rocket Tonk)
	[285020] = 20,		--- Whirling Edge (The Platinum Pummeler)
	[294291] = 20,		--- Process Waste ()
	[291930] = 20,		--- Air Drop (K.U-J.0)
	[294324] = 20,		--- Mega Drill (Waste Processing Unit)
	[293861] = 20,		--- Anti-Personnel Squirrel (Anti-Personnel Squirrel)
	[295168] = 20,		--- Capacitor Discharge (Blastatron X-80)
	[294954] = 20,		--- Self-Trimming Hedge (Head Machinist Sparkflux)
	
	
	-- Mechagon Junkyard
	[300816] = 20,		--- Slimewave (Slime Elemental)
	[300188] = 20,		--- Scrap Cannon (Weaponized Crawler)
	[300427] = 20,		--- Shockwave (Scrapbone Bully)
	[294890] = 20,		--- Gryro-Scrap (Malfunctioning Scrapbot)
	[300129] = 20,		--- Self-Destruct Protocol (Malfunctioning Scrapbot)
	[300561] = 20,		--- Explosion (Scrapbone Trashtosser)
	[299475] = 20,		--- B.O.R.K. (Scraphound)
	[299535] = 20,		--- Scrap Blast (Pistonhead Blaster)
	[298940] = 20,		--- Bolt Buster (Naeno Megacrash)
	[297283] = 20,		--- Cave In (King Gobbamak)
	
	
	--- Awakened Lieutenant
	[314309] = 20,		--- Dark Fury (Urg'roth, Breaker of Heroes)
	[314467] = 20,		--- Volatile Rupture (Voidweaver Mal'thir)
	[314565] = 20,		--- Defiled Ground (Blood of the Corruptor)
}

local SpellsNoTank = {
	-- Freehold

	-- Shrine of the Storm
	
	-- Siege of Boralus
	[268230] = 20,		--- Crimson Swipe (Ashvane Deckhand)
	
	-- Tol Dagor
	[258864] = 20,		--- Suppression Fire (Ashvane Marine/Spotter)
	
	-- Waycrest Manor
	[263905] = 20,		--- Marking Cleave (Heartsbane Runeweaver)
	[265372] = 20,		---	Shadow Cleave (Enthralled Guard)
	[271174] = 20,		--- Retch (Pallid Gorger)
	
	-- Atal'Dazar

	-- King's Rest
	[270289] = 20,		--- Purification Beam (Purification Construct)
	
	-- The MOTHERLODE!!
	[268846] = 20,		--- Echo Blade (Weapons Tester)
	[263105] = 20,		--- Blowtorch (Feckless Assistant)
	[263583] = 20,		--- Broad Slash (Taskmaster Askari)
		
	-- Temple of Sethraliss
	[255741] = 20,		--- Cleave (Scaled Krolusk Rider)

	-- Underrot
	[272457] = 20,		--- Shockwave (Sporecaller Zancha)
	[260793] = 20,		--- Indigestion (Cragmaw the Infested)
	
}

local Auras = {
	-- Freehold
	[274516] = true,		-- Slippery Suds
	
	-- Shrine of the Storm
	[268391] = true,		-- Mental Assault (Abyssal Cultist)
	[269104] = true,		-- Explosive Void (Lord Stormsong)
	[267956] = true,		-- Zap (Jellyfish)
	
	-- Siege of Boralus
	[274942] = true,		-- Banana Stun
	[257169] = true,		-- Fear

	-- Tol Dagor
	[256474] = true,		-- Heartstopper Venom (Overseer Korgus)

	-- Waycrest Manor
	[265352] = true,		-- Toad Blight (Toad)
	[278468] = true,		-- Freezing Trap
	
	-- Atal'Dazar
	[255371] = true,		-- Terrifying Visage (Rezan)

	-- King's Rest
	[276031] = true,		-- Pit of Despair (Minion of Zul)

	-- The MOTHERLODE!!
	
	-- Temple of Sethraliss
	[269970] = true,		-- Blinding Sand (Merektha)

	-- Underrot
	
	-- Mechagon Workshop
	[293986] = true,		--- Sonic Pulse (Blastatron X-80)
	
	-- Mechaton Junkyard
	[398529] = true,		-- Gooped (Gunker)
	[300659] = true,		-- Consuming Slime (Toxic Monstrosity)
}

local AurasNoTank = {
	[272140] = true,		--- Iron Volley
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
				local msgAmount = round(amount / 1000,1)
				local pct = Round(amount / userMaxHealth * 100)
				if pct >= hardMinPct and pct >= minPct and ElitismHelperDB.Loud then
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
			print("ElitismHelper: Will only announce at the end of the dungeon.")
		end
	end

	actions = {
		["activeuser"] = function()
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
				print(k.." ;;; "..v)
			end
		end,
		["start"] = function()
			ElitismFrame:CHALLENGE_MODE_START()
		end,
		["eod"] = function()
			ElitismFrame:CHALLENGE_MODE_COMPLETED()
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
				print("Output set to party always")
			elseif argsFunc == "raid" then
				ElitismHelperDB.OutputMode = "raid"
				print("Output set to raid always")
			elseif argsFunc == "yell" then
				ElitismHelperDB.OutputMode = "yell"
				print("Output set to yell always")
			elseif argsFunc == "self" then
				ElitismHelperDB.OutputMode = "self"
				print("Output set to self only always")
			else
				print("Valid targets are default | party | raid | yell | self")
				print("Current target is "..ElitismHelperDB.OutputMode)
			end
		end,
		["help"] = function()
			print("Elitism Helper options:")
			print(" on/enable: Enable Elitism Helper announcer")
			print(" off/disable: Disable Elitism Helper announcer")
			print(" start: Start logging failure damage")
			print(" eod: Dungeon is complete")
			print(" table: Prints users")
			print(" resync: Rebuilts table")
			print(" activeUser: Prints active user")
			print(" output: Define output channel between default | party | raid | yell | self")
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
						print("  " .. v.cnt .. "x" .. GetSpellLink(k) .. " = " .. round(v.sum / 1000, 1) .. "k")
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
	end
	
	if not ElitismHelperDB then
		ElitismHelperDB = {
			Loud = true,
			OutputMode = "default"
		}
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
	local count = 0
	for _ in pairs(CombinedFails) do count = count + 1 end
	if count == 0 then
		print("No Damage?");
		--maybeSendChatMessage("Thank you for travelling with ElitismHelper. No failure damage was taken this run.")
		return
	else
		maybeSendChatMessage("Thank you for travelling with ElitismHelper. Amount of failure damage:")
	end
	local u = { }
	for k, v in pairs(CombinedFails) do table.insert(u, { key = k, value = v }) end
	table.sort(u, compareDamage)
	for k,v in pairs(u) do
			maybeSendChatMessage(k..". "..v["key"].." "..round(v["value"] / 1000,1).."k")
	end
	--CombinedFails = {}
end

function ElitismFrame:CHALLENGE_MODE_START(event,...)
	CombinedFails = {}
	FailByAbility = {}
	print("Failure damage now being recorded.")
end

function ElitismFrame:CHAT_MSG_ADDON(event,...)
	local prefix, message, channel, sender = select(1,...)
	if prefix ~= MSG_PREFIX then
		return
	end
	if message == "VREQ" then
		maybeSendAddonMessage(MSG_PREFIX,"VANS;0.1")
	elseif message:match("^VANS") then
		Users[sender] = message
		for k,v in pairs(Users) do
			if activeUser == nil then
				activeUser = k
			end
			if k < activeUser then
				activeUser = k
			end
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
end

function ElitismFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
	if (Auras[spellId] or (AurasNoTank[spellId] and UnitGroupRolesAssigned(dstName) ~= "TANK")) and UnitIsPlayer(dstName)  then
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
		local spellId, spellName, spellSchool, sAmount, aOverkill, sSchool, sResisted, sBlocked, sAbsorbed, sCritical, sGlancing, sCrushing, sOffhand, _ = select(12,CombatLogGetCurrentEventInfo())
		ElitismFrame:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, sAmount)
	elseif eventPrefix:match("^SWING") and eventSuffix == "DAMAGE" then
		local aAmount, aOverkill, aSchool, aResisted, aBlocked, aAbsorbed, aCritical, aGlancing, aCrushing, aOffhand, _ = select(12,CombatLogGetCurrentEventInfo())
		ElitismFrame:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)
	elseif eventPrefix:match("^SPELL") and eventSuffix == "MISSED" then
		local spellId, spellName, spellSchool, missType, isOffHand, mAmount  = select(12,CombatLogGetCurrentEventInfo())
		if mAmount then
			ElitismFrame:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, mAmount)
		end
	elseif eventType == "SPELL_AURA_APPLIED" then
		local spellId, spellName, spellSchool, auraType = select(12,CombatLogGetCurrentEventInfo())
		ElitismFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType)
	elseif eventType == "SPELL_AURA_APPLIED_DOSE" then
		local spellId, spellName, spellSchool, auraType, auraAmount = select(12,CombatLogGetCurrentEventInfo())
		ElitismFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
	end
end
