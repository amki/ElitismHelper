-- Frame creation
local EH_configFrame = CreateFrame("Frame", "ElitismHelperGUI");
EH_configFrame.name = "Elitism Helper";

-- Local variables
local frameCount = 1;
local dx_loc = 10;
local dy_loc = -30;
local y_loc_origin_shift = 10;

-- Register events
EH_configFrame:RegisterEvent("PLAYER_LOGIN");

-- CheckButton factory
function createCheckbutton(parent, x_loc, y_loc, id, displayName)
    frameCount = frameCount + 1;
	local checkButton = CreateFrame("CheckButton", "$parent_CheckButton_" .. id, parent, "ChatConfigCheckButtonTemplate");
	checkButton:SetPoint("TOPLEFT", x_loc, y_loc);
	getglobal(checkButton:GetName() .. 'Text'):SetText(displayName);

	return checkButton;
end

-- Dropdown menu factory
function createDropDownMenu(parent, x_loc, y_loc, title, options, width, default_value, on_select_func)
    -- on_select_func = on_select_func or function()
    frameCount = frameCount + 1;
    local dropDown = CreateFrame("Frame", '$parent_DropDown_' .. title, parent, 'UIDropDownMenuTemplate');
    local dd_title = dropDown:CreateFontString(dropDown, 'OVERLAY', 'GameFontNormal');
    dropDown:SetPoint("TOPLEFT", x_loc, y_loc);
    dd_title:SetPoint("TOPLEFT", 20, 10);
    for _, option in pairs(options) do
        dd_title:SetText(item);
        local text_width = dd_title:GetStringWidth() + 20;
        if text_width > width then
            width = text_width;
        end
    end

    UIDropDownMenu_SetWidth(dropDown, width);
    UIDropDownMenu_SetText(dropDown, default_value);

    UIDropDownMenu_Initialize(dropDown, function(self, level, _)
        local info = UIDropDownMenu_CreateInfo();
        for key, val in pairs (options) do
            info.text = val;
            info.checked = false;
            info.menuList = key;
            info.hasArrow = false;
            info.func = function(b)
                UIDropDownMenu_SetSelectedValue(dropDown, b.value, b.value)
                UIDropDownMenu_SetText(dropDown, b.value);
                b.checked = true;
                on_select_func(dropDown, b.value);
            end
            UIDropDownMenu_AddButton(info);
        end
    end)

    return dropDown;
end

-- Slider factory
function createSlider()

end

-- GUI Interface building --
-- Announcer check button
local EH_CheckButton_EnableAnnouncer = createCheckbutton(EH_configFrame, dx_loc, dy_loc * frameCount - y_loc_origin_shift, "EnableAnnouncer", " Enable Elitism Helper announcer");
EH_CheckButton_EnableAnnouncer.tooltip = "If this is checked, the Elitism Helper announcer will be enabled.";
EH_CheckButton_EnableAnnouncer:SetScript("OnClick", 
    function()
        ElitismHelperDB.Loud = EH_CheckButton_EnableAnnouncer:GetChecked();
        print("Loud: " .. tostring(ElitismHelperDB.Loud));
    end
)

-- End of dungeon stats check button
local EH_CheckButton_EnableEndOfDungeon = createCheckbutton(EH_configFrame, dx_loc, dy_loc * frameCount - y_loc_origin_shift, "EnableEndOfDungeonMessage", " Enable end of dungeon stats");
EH_CheckButton_EnableEndOfDungeon.tooltip = "If this is checked, the overall stats will be shown at the end of the dungeon.";
EH_CheckButton_EnableEndOfDungeon:SetScript("OnClick", 
    function()
        ElitismHelperDB.EndOfDungeonMessage = EH_CheckButton_EnableEndOfDungeon:GetChecked();
        print("EndOfDungeonMessage: " .. tostring(ElitismHelperDB.EndOfDungeonMessage));
    end
)


-- Output channel options obj
local output_channel_opts = {
    'self',
    'party',
    'raid',
    'yell',
    'emote',
    'default'
};

-- onChange function for output channel dropdown
local onChange_outputChannelDropdown = function(dropDown_frame, dropDown_val)
    print(dropDown_val);
end

-- Build output channel dropdown
local EH_DropDown_OutputChannel = createDropDownMenu(EH_configFrame,
                                                    dx_loc, dy_loc * frameCount - y_loc_origin_shift,
                                                    'OutputChannel',
                                                    output_channel_opts,
                                                    50,
                                                    'default',
                                                    onChange_outputChannelDropdown)

-- ADDON_LOADED event
function EH_configFrame:PLAYER_LOGIN(event,addon)
    if addon == "ElitismFrame" then
        EH_CheckButton_EnableAnnouncer:SetChecked(ElitismHelperDB.Loud);
        EH_CheckButton_EnableEndOfDungeon:SetChecked(ElitismHelperDB.EndOfDungeonMessage);
        print("Addon loaded");
    end
end

InterfaceOptions_AddCategory(EH_configFrame);