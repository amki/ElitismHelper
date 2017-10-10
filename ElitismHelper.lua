local Users = {}
local Timers = {}
local TimerData = {}
local CombinedFails = {}
local activeUser = nil
local playerUser = GetUnitName("player",true).."-"..GetRealmName()
local hardMinPct = 20

local Spells = {
	-- Debug
	--[252144] = 1,
	--[252150] = 1,

	-- Affixes
	[209862] = 20,		-- Volcanic Plume (Environment)
	[226512] = 50,		-- Sanguine Ichor (Environment)

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

	-- Cathedral of Eternal Night
	[238653] = 20,		-- Shadow Wave (Dul'zak)
	[238673] = 20,		-- Floral Fulmination (Fulminating Lasher, Agronox)
	[239217] = 20,		-- Blinding Glare (Gazerax)
	[239201] = 20,		-- Fel Glare (Gazerax)
	[239326] = 20,		-- Felblaze Orb (Fel Orb)
	[240951] = 20,		-- Destructive Rampage (Thrashbite the Scornful)
	[236543] = 20,		-- Felsoul Cleave (Domatrax)
	[236551] = 20,		-- Chaotic Energy (Domatrax)
	[240279] = 20,		-- Fel Strike (Wrathguard Invader)
	[238469] = 20,		-- Scornful Charge (Thrashbite the Scornful)

	--Court of Stars
	[219498] = 20,		-- Streetsweeper (Patrol Captain Gerdo)
	[206574] = 20,		-- Resonant Slash (Patrol Captain Gerdo)
	[206580] = 20,		-- Resonant Slash (Patrol Captain Gerdo)
	[209477] = 20,		-- Wild Detonation (Mana Wyrm)
	[211457] = 20,		-- Infernal Eruption (Talixae Flamewreath)
	[209630] = 20,		-- Piercing Gale (Images of Advisor Melandrus)
	[209628] = 20,		-- Piercing Gale (Advisor Melandrus)
	[214688] = 20,		-- Carrion Swarm (Gerenth the Vile)

	-- Darkheart Thicket
	[204402] = 20,		-- Star Shower (Dreadsoul Ruiner)
	[201273] = 10,		-- Blood Bomb (Bloodtainted Fury)
	[201227] = 20,		-- Blood Assault (Bloodtainted Fury)
	[201123] = 20,		-- Root Burst (Vilethorn Blossom)
	[198386] = 20,		-- Primal Rampage (Archdruid Glaidalis)
	[191326] = 20,		-- Breath of Corruption (Dresaron)
	[198408] = 20,		-- Nightfall (Archdruid Glaidalis)
	[218759] = 20,		-- Corruption Pool (Festerhide Grizzly)
	[200771] = 20,		-- Propelling Charge (Crazed Razorbeak)
	[198916] = 20,		-- Vile Burst (Vile Mushroom)

	-- Eye of Azshara
	[195473] = 20,		-- Abrasive Slime (Gritslime Snail)
	[196129] = 20,		-- Spray Sand (Mak'rana Siltwalker)
	[195832] = 20,		-- Massive Quake (Skrog Tidestomper)
	[192801] = 20,		-- Tidal Wave (Wrath of Azshara)
	[193171] = 20,		-- Aftershock (Quake, King Deepbeard)
	[192794] = 20,		-- Lightning Strike (Environment)
	[191847] = 20,		-- Poison Spit (Serpentrix)
	[196293] = 20,		-- Chaotic Tempest (Stormwake Hydra)
	[196299] = 20,		-- Roiling Storm (Stormwake Hydra)

	-- Maw of Souls
	[194218] = 20,		-- Cosmic Scythe (Harbaron)
	[195309] = 20,		-- Swirling Water (Helya)
	[202098] = 20,		-- Brackwater Barrage (Helya)
	[227234] = 20,		-- Corrupted Bellow (Helya)
	[197117] = 20,		-- Piercing Tentacle (Helya)
	[202472] = 20,		-- Tainted Essence (Seacursed Swiftblade)
	[195036] = 40,		-- Defiant Strike (Seacursed Soulkeeper)
	[195033] = 40,		-- Defiant Strike (Seacursed Soulkeeper)
	[195038] = 40,		-- Defiant Strike (Seacursed Soulkeeper)
	[195035] = 40,		-- Defiant Strike (Seacursed Soulkeeper)
	[193513] = 20,		-- Bane (Ymiron, the Fallen King)
	[198330] = 20,		-- Give No Quarter (Skjal)
	[194443] = 20,		-- Six Pound Barrel (Waterlogged Soul Guard)
	[199250] = 20,		-- Deceptive Strike (Seacursed Swiftblade)
	[199093] = 20,		-- Flare (Runecarver Slave)

	-- The Arcway
	[211209] = 20,		-- Arcane Slicer (Arcane Anomaly)
	[196142] = 20,		-- Exterminate (Corstilax)
	[220500] = 40,		-- Destabilized Orb (Corstilax)
	[203833] = 20,		-- Time Split (Chrono Shards, Advisor Vandros)
	[197579] = 20,		-- Fel Eruption (General Xakal)
	[212071] = 20,		-- Shadow Slash (General Xakal)
	[220443] = 20,		-- Wake of Shadows (Shadow Slash, General Xakal)
	[199812] = 40,		-- Blink Strikes (Nal'tira)
	[200040] = 20,		-- Nether Venom (Nal'tira)
	[211921] = 20,		-- Felstorm (Priestess of Misery)
	[203593] = 20,		-- Nether Spike (Mana Wyrm)
	[211198] = 20,		-- Destructive Wake (Astral Spark)
	[211501] = 20,		-- Arcane Discharge (Enchanted Broodling)
	[220597] = 20,		-- Charged Bolt (Ivanyr)

	-- Neltharion's Lair
	[183100] = 20,		-- Avalanche (Mightstone Breaker)
	[198475] = 20,		-- Strike of the Mountain (Ularogg Cragshaper)
	[200723] = 20,		-- Molten Crash (Active Mitigation fail, Dargrul)

	-- Halls of Valor
	[192206] = 20,		-- Sanctify (Olmyr & Hyrja)
	[199210] = 20,		-- Penetrating Shot (Valarjar Marksman)
	[210875] = 20,		-- Charged Pulse (Stormforged Sentinel)
	[193234] = 20,		-- Dancing Blade (Hymdall)
	[193260] = 20,		-- Static Field (Storm Drake, Hymdall)
	[188395] = 20,		-- Ball Lightning (Static Field, Hymdall)

	-- Vault of the Wardens
	[193610] = 20,		-- Fel Detonation (Glayvianna Soulrender)
	[214625] = 20,		-- Fel Chain (Tirathon Saltheril)
	[202862] = 20,		-- Hatred (Tirathon Saltheril)
	[191853] = 20,		-- Furious Flames (Tirathon Saltheril)
	[202046] = 20,		-- Beam (Glazer)
	[214893] = 20,		-- Pulse (Glazer)
	[194945] = 20,		-- Lingering Gaze (Glazer)
	[192519] = 20,		-- Lava (Ash'Golm)
	[213395] = 20,		-- Deepening Shadows (Cordana Felsong)
	[197541] = 20,		-- Detonation (Cordana Felsong)
	[197506] = 20,		-- Creeping Doom (Cordana Felsong)
	[202607] = 20,		-- Anguished Souls (Grimhorn the Enslaver)

	-- Return to Karazhan (Lower)
	[227645] = 20,		-- Spectral Charge (Midnight, Attumen the Huntsman)
	[227339] = 20,		-- Mezair (Midnight, Attumen the Huntsman)
	[227672] = 20,		-- Will Breaker (Lord Crispin Ference, Moroes)
	[228001] = 20,		-- Pennies From Heaven (Ghostly Philanthropist)
	[238606] = 20,		-- Arcane Eruption (Arcane Warden)
	[227925] = 20,		-- Final Curtain (Ghostly Understudy)
	[227568] = 20,		-- Burning Leg Sweep (Toe Knee, Opera Hall: Westfall Story)
	[227799] = 20,		-- Wash Away (Mrrgria, Opera Hall: Westfall Story)

	-- Return to Karazhan (Upper)
	[229563] = 20,		-- Knight Move (Knight)
	[229298] = 20,		-- Knight Move (Knight)
	[229559] = 20,		-- Bishop Move (Bishop)
	[229384] = 20,		-- Queen Move (Queen)
	[229568] = 20,		-- Rook Move (Rook)
	[229427] = 20,		-- Royal Slash (King)
	[242894] = 20,		-- Unstable Energy (Damaged Golem)
	[227806] = 25,		-- Ceaseless Winter (Shade of Medivh)
	[227620] = 20,		-- Arcane Bomb (Mana Devourer)
	[229248] = 20,		-- Fel Beam (Command Ship, Viz'aduum the Watcher)
	[229285] = 20,		-- Bombardment (Command Ship, Viz'aduum the Watcher)
	[229151] = 20,		-- Disintegrate (Viz'aduum the Watcher)
	[229161] = 20,		-- Explosive Shadows (Viz'aduum the Watcher)
	[227465] = 20,		-- Power Discharge (The Curator)
	[227285] = 20,		-- Power Discharge (The Curator)
	[229988] = 20,		-- Burning Tile (Wrathguard Flamebringer)

	-- Seat of the Triumvirate
	[245803] = 20,		-- Ravaging Darkness (Darkfang)
	[246688] = 20,		-- Suppression Field (Shadowguard Subjugator)
}

local SpellsNoTank = {
	-- The Arcway
	[196074] = 25,		-- Suppression Protocol (Corstilax)
	[220875] = 25,		-- Unstable Mana (Advisor Vandros)

	-- Darkheart Thicket
	[204667] = 20,		-- Nightmare Breath (Oakheart)

	-- Halls of Valor
	[193092] = 20,		-- Bloodletting Sweep (Hymdall)
	[192018] = 20,		-- Shield of Light (Hyrja)
	[198888] = 20,		-- Lightning Breath (Storm Drake)
	[199050] = 20,		-- Mortal Hew (Valarjar Shieldmaiden)

	-- Return to Karazhan (Upper)
	[229608] = 20,		-- Mighty Swing (Erudite Slayer)

	-- Cathedral of Eternal Night
	[237599] = 20,		-- Devastating Swipe (Helblaze Felbringer)
}

local Auras = {
	-- Black Rook Hold
	[200261] = true,		-- Bonebreaking Strike (Soul-Torn Champion)
	[197974] = true,		-- Bonecrushing Strike (Soul-torn Vanguard)
	[214002] = true,		-- Raven's Dive (Risen Lancer)
	[199097] = true,		-- Cloud of Hypnosis (Lord Kur'talos Ravencrest)

	-- Court of Stars
	[209667] = true,		-- Blade Surge (Advisor Melandrus)
	[207979] = true,		-- Shockwave (Jazshariu)
	[209027] = true,		-- Quelling Strike (Duskwatch Guard)
	[213304] = true,		-- Righteous Indignation (Suspicious Noble)
	[211464] = true,		-- Fel Detonation (Felbound Enforcer)

	-- Darkheart Thicket
	[200329] = true,		-- Overwhelming Terror (Shade of Xavius)

	-- Eye of Azshara
	[193597] = true,		-- Static Nova (Lady Hatecoil)
	[196665] = true,		-- Magic Resonance (Wrath of Azshara)
	[196666] = true,		-- Frost Resonance (Wrath of Azshara)

	-- Halls of Valor
	[198088] = true,		-- Glowing Fragment (Odyn)
	[199337] = true,		-- Bear Trap (Valarjar Trapper)

	-- Maw of Souls
	[193364] = true,		-- Screams of the Dead (Ymiron, the Fallen King)

	-- Return to Karazhan (Lower)
	[227977] = true,		-- Flashlight (Skeletal Usher)
	[228280] = true,		-- Oath of Fealty (Spectral Retainer)
	[228221] = true,		-- Severe Dusting (Babblet, Opera Hall: Beautiful Beast)
	[227917] = true,		-- Poetry Slam (Ghostly Understudy)

	-- Return to Karazhan (Upper)
	[227592] = true,		-- Frostbite (Shade of Medivh)

	-- Vault of the Wardens
	[212565] = true,		-- Inquisitive Stare (Inquisitor Tormentorum)

	-- Seat of the Triumvirate
	[246026] = true,		-- Void Trap (Saprish)
}

local AurasNoTank = {
}

function round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number)
end

local ElitismFrame = CreateFrame("Frame", "ElitismFrame")
ElitismFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
local MSG_PREFIX = "ElitismHelper"
local success = RegisterAddonMessagePrefix(MSG_PREFIX)
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
			local amount = 0
			local minPct = math.huge
			for k,v in pairs(TimerData[user]) do
				msg = msg..GetSpellLink(k).." "
				local spellMinPct = nil
				if Spells[k] then
					spellMinPct = Spells[k]
				elseif SpellsNoTank[k] then
					spellMinPct = SpellsNoTank[k]
				end
				if spellMinPct ~= nil and spellMinPct < minPct then
					minPct = spellMinPct
				end
				amount = amount + v
			end
			if minPct == math.huge then
				local spellNames = " "
				for k,v in pairs(TimerData[user]) do
					spellNames = spellNames..GetSpellLink(k).." "
				end
				print("<EH> Error: Could not find spells"..spellNames.."in Spells or SpellsNoTank but got Timer for them. wtf")
			end
			TimerData[user] = nil
			Timers[user] = nil
			local userMaxHealth = UnitHealthMax(user)
			local msgAmount = round(amount / 1000000,1)
			local pct = Round(amount / userMaxHealth * 100)
			if pct >= hardMinPct and pct >= minPct then
				msg = msg.."for "..msgAmount.."mil ("..pct.."%)."
				maybeSendChatMessage(msg)
			end
		end
	return func
end

SlashCmdList["ELITISMHELPER"] = function(msg,editBox)
	if msg == "activeuser" then
		print("activeUser is "..activeUser)
	elseif msg == "resync" then
		ElitismFrame:RebuildTable()
	elseif msg == "table" then
		for k,v in pairs(Users) do
			print(k.." ;;; "..v)
		end
	elseif msg == "eod" then
		ElitismFrame:CHALLENGE_MODE_COMPLETED()
	end
end

SLASH_ELITISMHELPER1 = "/eh"

function maybeSendAddonMessage(prefix, message)
	if IsInGroup() and not IsInGroup(2) and not IsInRaid() then
		SendAddonMessage(prefix,message,"PARTY")
	elseif IsInGroup() and not IsInGroup(2) and IsInRaid() then
		SendAddonMessage(prefix,message,"RAID")
	end
end

function maybeSendChatMessage(message)
	if activeUser ~= playerUser then
		return
	end
	if IsInGroup() and not IsInGroup(2) and not IsInRaid() then
		SendChatMessage(message,"PARTY")
	elseif IsInGroup() and not IsInGroup(2) and IsInRaid() then
		SendChatMessage(message,"RAID")
	end
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
	return a["value"] > b["value"]
end

function ElitismFrame:CHALLENGE_MODE_COMPLETED(event,...)
	local count = 0
	for _ in pairs(CombinedFails) do count = count + 1 end
	if count == 0 then
		maybeSendChatMessage("Thank you for travelling with ElitismHelper. No failure damage was taken this run.")
		return
	else
		maybeSendChatMessage("Thank you for travelling with ElitismHelper. Amount of failure damage:")
	end
	local u = { }
	for k, v in pairs(CombinedFails) do table.insert(u, { key = k, value = v }) end
	table.sort(u, compareDamage)
	for k,v in pairs(u) do
			maybeSendChatMessage(k..". "..v["key"].." "..round(v["value"] / 1000000,1).." mil")
	end
	CombinedFails = {}
end

function ElitismFrame:CHALLENGE_MODE_START(event,...)
	CombinedFails = {}
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
	if --(Spells[spellId] or (SpellsNoTank[spellId] and UnitGroupRolesAssigned(dstName) ~= "TANK")) and 
		UnitIsPlayer(dstName) then
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
			C_Timer.After(2,generateMaybeOutput(dstName))
		end
	end
end

function ElitismFrame:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)
end

function ElitismFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
	if (Auras[spellId] or (AurasNoTank[spellId] and UnitGroupRolesAssigned(dstName) ~= "TANK")) and UnitIsPlayer(dstName)  then
		if auraAmount then
			maybeSendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..". "..auraAmount.." Stacks.")
		else
			maybeSendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..".")
		end
	end
end

function ElitismFrame:COMBAT_LOG_EVENT_UNFILTERED(event,...)
	local timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2 = select(1,...); -- Those arguments appear for all combat event variants.
	local eventPrefix, eventSuffix = eventType:match("^(.-)_?([^_]*)$");
	if (eventPrefix:match("^SPELL") or eventPrefix:match("^RANGE")) and eventSuffix == "DAMAGE" then
		local spellId, spellName, spellSchool, sAmount, aOverkill, sSchool, sResisted, sBlocked, sAbsorbed, sCritical, sGlancing, sCrushing, sOffhand, _ = select(12,...)
		ElitismFrame:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, sAmount)
	elseif eventPrefix:match("^SWING") and eventSuffix == "DAMAGE" then
		local aAmount, aOverkill, aSchool, aResisted, aBlocked, aAbsorbed, aCritical, aGlancing, aCrushing, aOffhand, _ = select(12,...)
		ElitismFrame:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)
	elseif eventPrefix:match("^SPELL") and eventSuffix == "MISSED" then
		local spellId, spellName, spellSchool, missType, isOffHand, mAmount  = select(12,...)
		if mAmount then
			ElitismFrame:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, mAmount)
		end
	elseif eventType == "SPELL_AURA_APPLIED" then
		local spellId, spellName, spellSchool, auraType = select(12,...)
		ElitismFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType)
	elseif eventType == "SPELL_AURA_APPLIED_DOSE" then
		local spellId, spellName, spellSchool, auraType, auraAmount = select(12,...)
		ElitismFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
	end
end
