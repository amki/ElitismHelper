--version 0.0.1
--[[local Slots = {
	"Head","Neck","Shoulder","Back","Chest","Wrist",
	"Hands","Waist","Legs","Feet","Finger0","Finger1",
	"Trinket0","Trinket1","MainHand","SecondaryHand"
}]]--

local Users = {}
local activeUser = nil
local playerUser = GetUnitName("player",true).."-"..GetRealmName()

local Spells = {
	-- Affixes
	[209862] = true,		-- Volcanic Plume
	
	-- Blackrook Hold
	[200261] = true,		-- Bonebreaking Strike
	[222397] = true,		-- Boulder Crush
	[198820] = true,		-- Dark Blast
	[214001] = true,		-- Raven's Dive
	[199567] = true,		-- Dark Obliteration
	
	-- Court of Stars
	[207979] = true,		-- Shockwave
	[209027] = true,		-- Quelling Strike
	
	-- Darkheart Thicket
	[200658] = true,		-- Star Shower
	[201273] = true,		-- Blood Bomb
	[201227] = true,		-- Blood Assault
	
	-- Eye of Azshara
	[195473] = true,		-- Abrasive Slime
	[193597] = true,		-- Static Nova
	
	-- Halls of Valor
	
	-- Maw of Souls
	[194216] = true,		-- Cosmic Scythe
	
	-- DEBUG
	[190984] = true,
	[194153] = true
}

local Auras = {
	-- Court of Stars
	[209602] = true,		-- Blade Surge
	
	-- Darkheart Thicket
	[200769] = true,		-- Propelling Charge
	-- DEBUG
	[164812] = true
}

local ElitismFrame = CreateFrame("Frame", "ElitismFrame")
print("Registering COMBAT_LOG_EVENT")
ElitismFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
local MSG_PREFIX = "ElitismHelper"
local success = RegisterAddonMessagePrefix(MSG_PREFIX)
if(success) then
	print("Registered AddonMessagePrefix")
end
ElitismFrame:RegisterEvent("CHAT_MSG_ADDON")
ElitismFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
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
	print("SLASH COMMAND!")
	if msg == "activeuser" then
		print("activeUser is "..activeUser)
	elseif msg == "resync" then
		ElitismFrame:RebuildTable()
	end
end

SLASH_ELITISMHELPER1 = "/eh"

function ElitismFrame:RebuildTable()
	Users = {}
	activeUser = nil
	print("Reset Addon Users table")
	if IsInGroup() or IsInRaid() then
		SendAddonMessage(MSG_PREFIX,"VREQ",RAID)
	else
		name = GetUnitName("player",true)
		activeUser = name.."-"..GetRealmName()
		print("We are alone, activeUser: "..activeUser)
	end
end

function ElitismFrame:ADDON_LOADED(event,...)
	ElitismFrame:RebuildTable()
end

function ElitismFrame:GROUP_ROSTER_UPDATE(event,...)
	print("GROUP_ROSTER_UPDATE")
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
		print("Active User is now: "..activeUser)
	else
		print("Unknown message: "..message)
	end
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
