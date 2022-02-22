-- Initialization --
local EH_configFrame = CreateFrame("Frame", "ElitismHelperGUI");
EH_configFrame.name = "Elitism Helper";
local checkButtonId = 0;

-- Checkbox factory
function createCheckbutton(parent, x_loc, y_loc, id, displayName)
    checkButtonId = checkButtonId + 1;
	local checkButton = CreateFrame("CheckButton", "ElitismHelper_CheckButton_" .. id, parent, "ChatConfigCheckButtonTemplate");
	checkButton:SetPoint("TOPLEFT", x_loc, y_loc);
	getglobal(checkButton:GetName() .. 'Text'):SetText(displayName);

	return checkButton;
end



-- GUI Interface building --
-- Announcer check button
local EH_CheckButton_EnableAnnouncer = createCheckbutton(EH_configFrame, 50, 50, "EnableAnnouncer", " Enable Elitism Helper announcer");
EH_CheckButton_EnableAnnouncer.tooltip = "If this is checked, the Elitism Helper announcer will be enabled.";
EH_CheckButton_EnableAnnouncer:SetScript("OnClick", 
   function()
        if EH_CheckButton_EnableAnnouncer:GetChecked() then
            print("Is checked");
        else
            print("Is not checked");
        end
        print("EndOfDungeonMessage"..ElitismHelperDB.EndOfDungeonMessage);
   end
)

--

InterfaceOptions_AddCategory(EH_configFrame)