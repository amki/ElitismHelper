--version 0.0.1
--[[local Slots = {
	"Head","Neck","Shoulder","Back","Chest","Wrist",
	"Hands","Waist","Legs","Feet","Finger0","Finger1",
	"Trinket0","Trinket1","MainHand","SecondaryHand"
}]]--

local Spells = {
	-- Volcanic Plume
	[209862] = true
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
	print(srcName.." dealt "..aAmount.." damage to "..dstName.." with spell "..spellId)
	if Spells[spellId] then
		name, rank, icon, castingTime, minRange, maxRange, spellID = GetSpellInfo(spellId) 
		UIErrorsFrame:AddMessage(dstName.." got hit by "..name.." for "..aAmount)
	end
end

function ElitismFrame:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)
	print(srcName.." dealt "..aAmount.." damage to "..dstName.." with a melee hit")
end

function ElitismFrame:COMBAT_LOG_EVENT_UNFILTERED(event,...)
	local timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2 = select(1,...); -- Those arguments appear for all combat event variants.
	local eventPrefix, eventSuffix = eventType:match("^(.-)_?([^_]*)$");
	if (eventPrefix:match("^SPELL") or eventPrefix:match("^RANGE")) and eventSuffix == "DAMAGE" then
			local spellId, spellName, spellSchool, sAmount, aOverkill, sSchool, sResisted, sBlocked, sAbsorbed, sCritical, sGlancing, sCrushing, sOffhand, _ = select(12,...)
			ElitismFrame:SpellDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, sAmount)
	elseif eventPrefix:match("^SWING") and eventSuffix == "DAMAGE" then
		local aAmount, aOverkill, aSchool, aResisted, aBlocked, aAbsorbed, aCritical, aGlancing, aCrushing, aOffhand, _ = select(12,...)
		ElitismFrame:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)
	elseif eventPrefix:match("^SPELL") and eventSuffix == "ABSORBED" then
		local chk = select(12,...)
        local spellId, spellName, spellSchool, aGUID, aName, aFlags, aRaidFlags, aspellId, aspellName, aspellSchool, aAmount
		-- If chk is a number it's a spell because spellId follows for spells but player GUID for melee swings (player GUID is not a number)
        if type(chk) == "number" then
            -- Spell event
            spellId, spellName, spellSchool, aGUID, aName, aFlags, aRaidFlags, aspellId, aspellName, aspellSchool, aAmount = select(12,...)
            
            -- Exclude Spirit Shift damage
            if aspellId == 184553 then
                return
            end
                
            if aAmount then
                ElitismFrame:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, aAmount)
			else
				print("<EH> DEBUG: AbsorbSpell detected but no amount?")
            end
        else
            -- Swing event
            aGUID, aName, aFlags, aRaidFlags, aspellId, aspellName, aspellSchool, aAmount = select(12,...)

            -- Exclude Spirit Shift damage
            if aspellId == 184553 then
                return
            end
                
            if aAmount then
                ElitismFrame:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)
			else
				print("<EH> DEBUG: AbsorbSwing detected but no amount?")
            end
        end
	else
		--print("Unhandled "..eventType)
	end
end
