--version 0.0.1
--[[local Slots = {
	"Head","Neck","Shoulder","Back","Chest","Wrist",
	"Hands","Waist","Legs","Feet","Finger0","Finger1",
	"Trinket0","Trinket1","MainHand","SecondaryHand"
}]]--

local Spells = {
	-- Affixes
	-- Volcanic Plume
	[209862] = true,
	-- Blackrook Hold
	-- Bonebreaking Strike
	[200261] = true,
	-- Boulder Crush
	[222397] = true,
	-- Dark Blast
	[198820] = true,
	-- Raven's Dive
	[214001] = true,
	-- Dark Obliteration
	[199567] = true,
	-- Eye of Azshara
	-- Abrasive Slime
	[195473] = true,
	-- Static Nova
	[193597] = true,
	-- Halls of Valor
	-- Maw of Souls
	-- Cosmic Scythe
	[194216] = true
	-- DEBUG
	--[190984] = true,
	--[194153] = true
}

local Auras = {
	-- DEBUG
	--[164812] = true
}

local ElitismFrame = CreateFrame("Frame", "ElitismFrame")
print("Registering COMBAT_LOG_EVENT")
ElitismFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

ElitismFrame:ClearAllPoints()
ElitismFrame:SetHeight(300)
ElitismFrame:SetWidth(1000)
ElitismFrame.text = ElitismFrame:CreateFontString(nil, "BACKGROUND", "PVPInfoTextFont")
ElitismFrame.text:SetAllPoints()
ElitismFrame.text:SetTextHeight(13)
ElitismFrame:SetAlpha(1)

ElitismFrame:SetScript("OnEvent", function(self, event_name, ...)
	if self[event_name] then
		return self[event_name](self, event_name, ...)
	end
end)

function table.pack(...)
  return { n = select("#", ...), ... }
end

function ElitismFrame:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, aAmount)
	if Spells[spellId] and UnitIsPlayer(dstName) then
		if IsInRaid() then
			SendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId).." for "..aAmount..".",RAID)
		elseif IsInGroup() then
			SendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId).." for "..aAmount..".",PARTY)
		end
	end
end

function ElitismFrame:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)
end

function ElitismFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
	if Auras[spellId] and UnitIsPlayer(dstName) then
		if auraAmount then
			if IsInRaid() then
				SendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..". "..auraAmount.." Stacks.",RAID)
			elseif IsInGroup() then
				SendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..". "..auraAmount.." Stacks.",PARTY)
			end
		else
			if IsInRaid() then
				SendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..".",RAID)
			elseif IsInGroup() then
				SendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..".",PARTY)
			end
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
		ElitismFrame:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, mAmount)
	elseif eventType == "SPELL_AURA_APPLIED" then
		local spellId, spellName, spellSchool, auraType = select(12,...)
		ElitismFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType)
	elseif eventType == "SPELL_AURA_APPLIED_DOSE" then
		local spellId, spellName, spellSchool, auraType, auraAmount = select(12,...)
		ElitismFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
	else
		--print("Unhandled "..eventType)
	end
end
