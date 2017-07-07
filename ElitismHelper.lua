local Users = {}
local activeUser = nil
local playerUser = GetUnitName("player",true).."-"..GetRealmName()

local Spells = {
	-- Affixes
	[209862] = true,		-- Volcanic Plume (Environment)

	-- Black Rook Hold
	[198820] = true,		-- Dark Blast (Latosius)
	[199567] = true,		-- Dark Obliteration (Image of Latosius)
	[200256] = true,		-- Phased Explosion (Arcane Minion)
	[198781] = true,		-- Whirling Blade (Lord Kur'talos Ravencrest)
	[196517] = true,		-- Swirling Scythe (Amalgam of Souls)

	-- Cathedral of Eternal Night
	[238653] = true,		-- Shadow Wave (Dul'zak)
	[238673] = true,		-- Floral Fulmination (Fulminating Lasher, Agronox)
	[239217] = true,		-- Blinding Glare (Gazerax)
	[239201] = true,		-- Fel Glare (Gazerax)
	[239326] = true,		-- Felblaze Orb (Fel Orb)
	[240951] = true,		-- Destructive Rampage (Thrashbite the Scornful)
	[236543] = true,		-- Felsoul Cleave (Domatrax)
	[242760] = true,		-- Lumbering Crash (Vilebark Walker)
	[240279] = true,		-- Fel Strike (Wrathguard Invader)
	[238469] = true,		-- Scornful Charge (Thrashbite the Scornful)

	--Court of Stars
	[219498] = true,		-- Streetsweeper (Patrol Captain Gerdo)
	[206574] = true,		-- Resonant Slash (Patrol Captain Gerdo)
	[206580] = true,		-- Resonant Slash (Patrol Captain Gerdo)
	[209477] = true,		-- Wild Detonation (Mana Wyrm)
	[211457] = true,		-- Infernal Eruption (Talixae Flamewreath)
	[209630] = true,		-- Piercing Gale (Images of Advisor Melandrus)
	[209628] = true,		-- Piercing Gale (Advisor Melandrus)

	-- Darkheart Thicket
	[204402] = true,		-- Star Shower (Dreadsoul Ruiner)
	[201273] = true,		-- Blood Bomb (Bloodtainted Fury)
	[201227] = true,		-- Blood Assault (Bloodtainted Fury)
	[201123] = true,		-- Root Burst (Vilethorn Blossom)
	[198386] = true,		-- Primal Rampage (Archdruid Glaidalis)
	[191326] = true,		-- Breath of Corruption (Dresaron)

	-- Eye of Azshara
	[195473] = true,		-- Abrasive Slime (Gritslime Snail)
	[196129] = true,		-- Spray Sand (Mak'rana Siltwalker)
	[195832] = true,		-- Massive Quake (Skrog Tidestomper)
	[192801] = true,		-- Tidal Wave (Wrath of Azshara)
	[193171] = true,		-- Aftershock (Quake, King Deepbeard)
	[192794] = true,		-- Lightning Strike (Environment)
	[191847] = true,		-- Poison Spit (Serpentrix)
	[196293] = true,		-- Chaotic Tempest (Stormwake Hydra)
	[196299] = true,		-- Roiling Storm (Stormwake Hydra)

	-- Maw of Souls
	[194218] = true,		-- Cosmic Scythe (Harbaron)
	[195309] = true,		-- Swirling Water (Helya)
	[202098] = true,		-- Brackwater Barrage (Helya) 
	[195036] = true,		-- Defiant Strike (Seacursed Soulkeeper)
	[194443] = true,		-- Six Pound Barrel (Waterlogged Soul Guard)
	[199250] = true,		-- Deceptive Strike (Seacursed Swiftblade)

	-- The Arcway
	[211209] = true,		-- Arcane Slicer (Arcane Anomaly)
	[196142] = true,		-- Exterminate (Corstilax)
	[196074] = true,		-- Suppression Protocol (Corstilax)
	[220500] = true,		-- Destabilized Orb (Corstilax)
	[203833] = true,		-- Time Split (Chrono Shards, Advisor Vandros)
	[197579] = true,		-- Fel Eruption (General Xakal)
	[212071] = true,		-- Shadow Slash (General Xakal)
	[220443] = true,		-- Wake of Shadows (Shadow Slash, General Xakal)
	[199812] = true,		-- Blink Strikes (Nal'tira)
	[211921] = true,		-- Felstorm (Priestess of Misery)
	[220875] = true,		-- Unstable Mana (Advisor Vandros)

	-- Neltharion's Lair
	[183100] = true,		-- Avalanche (Mightstone Breaker)
	[198475] = true,		-- Strike of the Mountain (Ularogg Cragshaper)
	[200723] = true,		-- Molten Crash (Active Mitigation fail, Dargrul)

	-- Halls of Valor
	[192206] = true,		-- Sanctify (Olmyr & Hyrja)
	[199210] = true,		-- Penetrating Shot (Valarjar Marksman)
	[210875] = true,		-- Charged Pulse (Stormforged Sentinel)
	[193234] = true,		-- Dancing Blade (Hymdall)
	[193260] = true,		-- Static Field (Storm Drake, Hymdall)
	[188395] = true,		-- Ball Lightning (Static Field, Hymdall)

	-- Return to Karazhan (Lower)
	[227645] = true,		-- Spectral Charge (Midnight, Attumen the Huntsman)
	[227339] = true,		-- Mezair (Midnight, Attumen the Huntsman)
	[227363] = true,		-- Mighty Stomp (Midnight, Attumen the Huntsman)
	[227672] = true,		-- Will Breaker (Lord Crispin Ference, Moroes)
	[227651] = true,		-- Iron Whirlwind (Baron Rafe Dreuger, Moroes)
	[228001] = true,		-- Pennies From Heaven (Ghostly Philanthropist)
	[238606] = true,		-- Arcane Eruption (Arcane Warden)
	[227925] = true,		-- Final Curtain (Ghostly Understudy)
	[227568] = true,		-- Burning Leg Sweep (Toe Knee, Opera Hall: Westfall Story)
	[227799] = true,		-- Wash Away (Mrrgria, Opera Hall: Westfall Story)
	[227434] = true,		-- Bubble Blast (Shoreline Tidespeaker, Opera Hall: Westfall Story)
	[228637] = true,		-- Smash (Spectral Journeyman)

	-- Return to Karazhan (Upper)
	[229563] = true,		-- Knight Move (Knight)
	[229298] = true,		-- Knight Move (Knight)
	[229559] = true,		-- Bishop Move (Bishop)
	[229384] = true,		-- Queen Move (Queen)
	[229568] = true,		-- Rook Move (Rook)
	[229427] = true,		-- Royal Slash (King)
	[242894] = true,		-- Unstable Energy (Damaged Golem)
	[227806] = true,		-- Ceaseless Winter (Shade of Medivh)
	--[228261] = true,		-- Flame Wreath (Shade of Medivh)
	[227620] = true,		-- Arcane Bomb (Mana Devourer)
	[229248] = true,		-- Fel Beam (Command Ship, Viz'aduum the Watcher)
	[229285] = true,		-- Bombardment (Command Ship, Viz'aduum the Watcher)
	[229151] = true,		-- Disintegrate (Viz'aduum the Watcher)
	[229161] = true,		-- Explosive Shadows (Viz'aduum the Watcher)
	[227465] = true,		-- Power Discharge (The Curator)
	[227285] = true,		-- Power Discharge (The Curator)

	-- The Nighthold
	[207631] = true,		-- Annihilation (Trilliax)
	[205391] = true,		-- Fel Beam (Krosus)
	[215988] = true,		-- Carrion Nightmare (Tichondrius)
	[218463] = true,		-- Controlled Chaos (High Botanist Tel'arn, 10 yards explosion?)
	[218466] = true,		-- Controlled Chaos (High Botanist Tel'arn, 20 yards explosion?)
	[218470] = true,		-- Controlled Chaos (High Botanist Tel'arn, 30 yards explosion?)
	[218155] = true,		-- Solar Collapse (High Botanist Tel'arn)
	[208659] = true,		-- Arcanetic Ring (Grand Magistrix Elisande)
	[212262] = true,		-- Hand of Gul'dan (Gul'dan)
	[229948] = true,		-- Fel Obelisk (Fel Lord Kuraz'mal, Gul'dan)

	-- Tomb of Sargeras
	[233021] = true,		-- Infernal Spike (Goroth)
	[236329] = true,		-- Star Burn (Goroth)
	[239144] = true,		-- Tormented Eruption (Demonic Inquisition)
	[232885] = true,		-- Devour Whole (Sarukel, Mistress Sassz'ine)
	[232827] = true,		-- Crashing Wave (Vellius, Mistress Sassz'ine)
	[236480] = true,		-- Glaive Storm (Huntress Kasparian, Sisters of the Moon)
	[236158] = true,		-- Soul Eruption (Soul Residue, The Desolate Host)
	[236241] = true,		-- Soul Rot (Soul Residue, The Desolate Host)
	[235907] = true,		-- Collapsing Fissure (The Desolate Host)
	[234062] = true,		-- Unbound Chaos (Fallen Avatar)
	[239852] = true,		-- Demonic Obelisk (Kil'jaeden)
	}

local Auras = {
	-- Black Rook Hold
	[222417] = true,		-- Boulder Crush (Environment)
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
	[200771] = true,		-- Propelling Charge (Crazed Razorbeak)

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

	-- Emerald Nightmare
	[210315] = true,		-- Nightmare Brambles (Cenarius)
	[203110] = true,		-- Slumbering Nightmare (Dragons of Nightmare)

	-- Trial of Valor
	[227781] = true,		-- Glowing Fragment (Odyn)

	-- The Nighthold
	[204483] = true,		-- Focused Blast (Skorpyron)
	[207720] = true,		-- Witness the Void (Thing That Should Not Be, Star Augur Etraeus)

	-- Tomb of Sargeras
	[234332] = true,		-- Hydra Acid (Mistress Sassz'ine)
}

local ElitismFrame = CreateFrame("Frame", "ElitismFrame")
ElitismFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
local MSG_PREFIX = "ElitismHelper"
local success = RegisterAddonMessagePrefix(MSG_PREFIX)
ElitismFrame:RegisterEvent("CHAT_MSG_ADDON")
ElitismFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
ElitismFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ElitismFrame:RegisterEvent("ADDON_LOADED")

ElitismFrame:ClearAllPoints()
ElitismFrame:SetHeight(300)
ElitismFrame:SetWidth(1000)
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

SlashCmdList["ELITISMHELPER"] = function(msg,editBox)
	if msg == "activeuser" then
		print("activeUser is "..activeUser)
	elseif msg == "resync" then
		ElitismFrame:RebuildTable()
	elseif msg == "table" then
		for k,v in pairs(Users) do
			print(k.." ;;; "..v)
		end
	end
end

SLASH_ELITISMHELPER1 = "/eh"

function ElitismFrame:RebuildTable()
	Users = {}
	activeUser = nil
	-- print("Reset Addon Users table")
	if IsInGroup(LE_PARTY_CATEGORY_HOME) or IsInRaid(LE_PARTY_CATEGORY_HOME) or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
		SendAddonMessage(MSG_PREFIX,"VREQ",RAID)
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

function ElitismFrame:CHAT_MSG_ADDON(event,...)
	local prefix, message, channel, sender = select(1,...)
	if prefix ~= MSG_PREFIX then
		return
	end
	if message == "VREQ" then
		SendAddonMessage(MSG_PREFIX,"VANS;0.1",RAID)
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
	if Spells[spellId] and UnitIsPlayer(dstName) and aAmount > 750000 then
		if IsInRaid(LE_PARTY_CATEGORY_HOME) then
			SendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId).." for "..aAmount..".",RAID)
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			SendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId).." for "..aAmount..".",PARTY)
		elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
			SendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId).." for "..aAmount..".",INSTANCE_CHAT)
		end
	end
end

function ElitismFrame:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)
end

function ElitismFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
	if Auras[spellId] and UnitIsPlayer(dstName) then
		if auraAmount then
			if IsInRaid(LE_PARTY_CATEGORY_HOME) then
				SendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..". "..auraAmount.." Stacks.",RAID)
			elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
				SendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..". "..auraAmount.." Stacks.",PARTY)
			elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
				SendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..". "..auraAmount.." Stacks.",INSTANCE_CHAT)
			end
		else
			if IsInRaid(LE_PARTY_CATEGORY_HOME) then
				SendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..".",RAID)
			elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
				SendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..".",PARTY)
			elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
				SendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..".",INSTANCE_CHAT)
			end
		end
	end
end

function ElitismFrame:COMBAT_LOG_EVENT_UNFILTERED(event,...)
	if activeUser ~= playerUser then
		return
	end
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
	else
	end
end