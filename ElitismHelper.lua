local Users = {}
local Timers = {}
local TimerData = {}
local CombinedFails = {}
local FailByAbility = {}
local activeUser = nil
local playerUser = GetUnitName("player",true).."-"..GetRealmName():gsub(" ", "")


local Spells = {
	-- Debug
	--[] = 20,      --  ()
	--[252144] = 1,
	--[252150] = 1,
	
	-- Affixes
	[209862] = 20,		-- Volcanic Plume (Environment)
	[226512] = 20,		-- Sanguine Ichor (Environment)
	[240448] = 20,      -- Quaking (Environment)
	[343520] = 20,      -- Storming (Environment)
	[342494] = 20, 		-- Belligerent Boast(Season 1 Pridefull)
	
	-- Mists of Tirna Scythe
	[321968] = 20, 		-- Bewildering Pollen (tirnenn Villager)
	[323137] = 20, 		-- Bewildering Pollen (tirnenn Villager)
	[323250] = 20,      -- Anima Puddle (Droman Oulfarran)
	[325027] = 20,      -- Bramble Burst (Drust Boughbreaker)
	[326022] = 20,      -- Acid Globule (Spinemaw Gorger)
	[340300] = 20,		-- Tongue Lashing (Mistveil Gorgegullet)
	[340304] = 20,		-- Poisonous Secretions (Mistveil Gorgegullet)
	[331743] = 20,		-- Bucking Rampage (Mistveil Guardian)
	--id ? [340160] = 20,		-- Radiant Breath (Mistveil Matriarch)
	
	--id ? [323177] = 20,		-- Tears of the Forest(Ingra Maloch)
	[321834] = 20,      -- Dodge Ball (Mistcaller)
	[336759] = 20,      -- Dodge Ball (Mistcaller)
	[322655] = 20,		-- Acid Expulsion (Tred'Ova)
	--id ? [322450] = 20,		-- Consumption (Tred'Ova)
	
	-- De Other Side
	[334051] = 20,		-- Erupting Darkness (Death Speaker)
	[328729] = 20,		-- Dark Lotus (Risen Cultist)
	[333250] = 20,		-- Reaver (Risen Warlord)
	[342869] = 20,		-- Enraged Mask (Enraged Spirit)
	[333790] = 20,		-- Enraged Mask (Enraged Spirit)
	[332672] = 20,      -- Bladestorm (Atal'ai Deathwalker)
	[323118] = 20,      -- Blood Barrage (Hakkar the Soulflayer)
	[331933] = 20,		-- Haywire (Defunct Dental Drill)
	[332157] = 20,      -- Spinning Up (Headless Client)
	[323569] = 20,   	-- Spilled Essence (Environement)
	[320830] = 20,		-- Mechanical Bomb Squirrel
	[323136] = 20,      -- Anima Starstorm (Runestag Elderhorn)
	[323992] = 20,      -- Echo Finger Laser X-treme (Millificent Manastorm)
			
	[320723] = 20,		-- Displaced Blastwave (Dealer Xy'exa)
	[334913] = 20,		-- Master of Death (Mueh'zala)
	[327427] = 20,		-- Shattered Dominion (Mueh'zala)
	[325691] = 20,      -- Cosmic Collapse (Mueh'zala)
	[335000] = 20,		-- Stellar cloud (Mueh'zala)
	
	
	-- Spires of Ascension
	[331251] = 20,      -- Deep Connection (Azules / Kin-Tara)
	[317626] = 20,      -- Maw-Touched Venom (Azules)
	[323786] = 20,      -- Swift Slice (Kyrian Dark-Praetor)
	[324662] = 20,      -- Ionized Plasma (Multiple) Can this be avoided?
	[317943] = 20,      -- Sweeping Blow (Frostsworn Vanguard)
	[324608] = 20,      -- Charged Stomp (Oryphrion)
	[323740] = 20,		-- Impact (Forsworn Squad-Leader)
	[336447] = 20,		-- Crashing Strike (Forsworn Squad-Leader)
	[336444] = 20,		-- Crescendo (Forsworn Helion)
	[328466] = 20,		-- Charged Spear (Lakesis / Klotos)
	[336420] = 20,		-- Diminuendo (Klotos / Lakesis)
	
	[321034] = 20,      -- Charged Spear (Kin-Tara)
	[324370] = 20,		-- Attenuated Barrage (Kin-Tara)
	[324141] = 20,      -- Dark Bolt (Ventunax)
	[324154] = 20,		-- Dark Stride (Venturax)
	[323943] = 20,      -- Run Through (Devos)
	[334625] = 20,		-- Seed of the Abyss (Devos)
	
	
	-- The Necrotic Wakes
	[324391] = 20,		-- Frigid Spikes (Skeletal Monstrosity)
	-- id ?[324372] = 20,		-- Reaping Winds (Skeletal Monstrosity)
	-- id ?[320574] = 20,		-- Shadow Well (Zolramus Sorcerer)
	[333477] = 20,		-- Gut Slice (Goregrind)
	
	-- id ?[320637] = 20, 		-- Fetid Gas (Blightbone)
	[333489] = 20,		-- Necrotic Breath (Amarth)
	[333492] = 20,		-- Necrotic Ichor (Amarth apply by Necrotic Breath)
	[320365] = 20,		-- Embalming Ichor (Surgeon Stitchflesh)
	[320366] = 20,		-- Embalming Ichor (Surgeon Stitchflesh)
	[327952] = 20,		-- Meat Hook (Stitchflesh)
	[327100] = 20,      -- Noxious Fog (Stitchflesh)
	[328212] = 20,      -- Razorshard Ice (Nalthor the Rimebender)
	[320784] = 20,		-- Comet Storm (Nalthor the Rimebinder)
	
	-- Plaguefall
	[320072] = 20, 		-- Toxic Pool (Decaying Flesh Giant)
	-- id ?[335882] = 20, 		-- Clinging Infestation (Fen Hatchling)
	[330404] = 20,		-- Wing Buffet (Plagueroc)
	-- id ?[320040] = 20,		-- Plagued Carrion (Decaying Flesh Giant)
	[320072] = 20,		-- Toxic pool (Decaying Flesh Giant)
	[318949] = 20,      -- Festering Belch (Blighted Spinebreaker)
	-- id ?[320576] = 20,      -- Obliterating Ooze (Virulax Blightweaver)
	[319120] = 20, 		-- Putrid Bile (Gushing Slime)
	[327233] = 20, 		-- Belch Plague (Plagebelcher)
	[320519] = 20, 		-- Jagged Spines (Blighted Spinebreaker)
	[328501] = 20,		-- Plagued Bomb (Environement)
	[324667] = 20,		-- Slime Wave (Globgrog)
	[626242] = 20,		-- Slime Wave (Globgrog)
	[333808] = 20,		-- Oozing Outbreak (Doctor Ickus)
	[329217] = 20,		-- Slime Lunge (Doctor Ickus)
	[322475] = 20,		-- Plague Crash (Environement Margrave Stradama)
	
	-- Theater of Pain
	[337037] = 20,		-- Whirling Blade (Nekthara the Mangler)
	[332708] = 20,		-- Ground Smash (Heavin the breaker)
	[333297] = 20, 		-- Death Winds (Nefarious Darkspeaker)
	[331243] = 20,		-- Bone Spikes (Soulforged Bonereaver)
	[331224] = 20,		-- Bonestorm (Soulforged Bonereaver)
	[330608] = 20,		-- Vile Eruption (Rancind Gasbag)
	
	[317231] = 20, 		-- Crushing Slam (Xav the Unfallen)
	[339415] = 20,		-- Deafening Crash (Xav the Unfallen)
	[320729] = 20,		-- Massive Cleave (Xav the Unfallen)
	[318406] = 20,		-- Tenderizing Smash (Gorechop)
	-- id ?[323542] = 20,		-- Oozing (Gorechop)
	[323681] = 20,		-- Dark Devastation (Mordretha) 
	[339573] = 20,		-- Echos of Carnage (Mordretha)
	[339759] = 20,		-- Echos of Carnage (Mordretha)
	
	-- Sanguine Depths
	[334563] = 20,		-- Volatile Trap (Dreadful Huntmaster)
	[320991] = 20,		-- Echoing Thrust (Regal Mistdancer)
	[320999] = 20,		-- Echoing Thrust (Regal Mistdancer Mirror)
	-- id ?[321019] = 20,		-- Sanctified Mists (Regal Mistcaller)
	[334921] = 20,		-- Umbral Crash (Insatiable Brute)
	[322418] = 20,		-- Craggy Fracture (Chamber Sentinel)
	[334378] = 20,      -- Explosive Vellum (Research Scribe)
	[323573] = 20,      -- Residue (Fleeting Manifestation)
	[325885] = 20,      -- Anguished Cries (Z'rali)
	[334615] = 20,		-- Sweeping Slash (Head Custodian Javlin)
	[322212] = 20,		-- Growing Mistrust (Vestige of Doubt)
	[328494] = 20, 		-- Sintouched Anima (Environement)
	[323810] = 20,		-- Piercing Blur (General Kaal)
	
	-- Hall of Atonement 
	[325523] = 20,		-- Deadly Thrust (Depraved Darkblade)
	[325799] = 20,		-- Rapid Fire (Depraved Houndmaster)
	[326440] = 20,		-- Sin Quake (Shard of Halkias)
	
	[322945] = 20,		-- Heave Debris (Halkias)
	[324044] = 20,		-- Refracted Sinlight (Halkias)
	[319702] = 20,		-- Blood Torrent (Echelon)
	[323126] = 20, 		-- Telekinetic Collision (Lord Chamberlain)
    [329113] = 20,		-- Telekinteic Onslaught (Lord Chamberlain)
	[327885] = 20,		-- Erupting Torment (Lord Chamberlain)
}

local SpellsNoTank = {
    -- Mists of Tirna Scythe
	[331721] = 20,      --- Spear Flurry (Mistveil Defender)
	
	-- De Other Side
	
	-- Spires of Ascension
	[320966] = 20,      -- Overhead Slash (Kin-Tara)
	[336444] = 20,      -- Crescendo (Forsworn Helion)
	
	-- The Necrotic Wakes
	[324323] = 20,		-- Gruesome Cleave (Skeletal Marauder)
	-- Plaguefall
	
	-- Theater of Pain
	
	-- Sanguine Depths
	[322429] = 20,		-- Severing Slice (Chamber Sentinel)
	
	-- Hall of Atonement 
	-- id ? [118459] = 20,		-- Beast Cleave (Loyal Stoneborn)
	[346866] = 20, 		-- Stone Breathe (Loyal Stoneborn)
	[326997] = 20,		-- Powerful Swipe (Stoneborn Slasher)
}

local Auras = {
    -- Mists of Tirna Scythe
    [323137] = true,      --- Bewildering Pollen (Drohman Oulfarran)
	[321893] = true,      --- Freezing Burst (Illusionary Vulpin)
	
	-- De Other Side
	[331381] = 20,		-- Slipped (Lubricator)
	
	-- Spires of Ascension
	
	-- The Necrotic Wakes
	
	-- Plaguefall
	
	-- Theater of Pain
	
	-- Sanguine Depths
	
	-- Hall of Atonement 
}

local AurasNoTank = {
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
			print(" output: Define output channel between default | party | raid | yell | self")
			print(" ------ This is more or less for debugging ------")
			print(" start: Start logging failure damage")
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
	
	if not ElitismHelperDB or not ElitismHelperDB.Threshold  then
		ElitismHelperDB = {
			Loud = true,
			Threshold = 30,
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