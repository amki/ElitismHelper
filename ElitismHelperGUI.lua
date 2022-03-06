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

-- Label factory
function createLabel(parent, x_loc, y_loc, x_size, y_size, id, labelText, style)
    -- add widgets to the panel as desired
    local title = parent:CreateFontString("ARTWORK", nil, style);
    title:SetPoint("TOPLEFT", x_loc, y_loc);
    title:SetText(labelText);
end

-- CheckButton factory
function createCheckbutton(parent, x_loc, y_loc, id, displayName)
    frameCount = frameCount + 1;
	local checkButton = CreateFrame("CheckButton", "$parent_CheckButton_" .. id, parent, "ChatConfigCheckButtonTemplate");
	checkButton:SetPoint("TOPLEFT", x_loc, y_loc);
    _G[checkButton:GetName() .. 'Text']:SetText(displayName);

	return checkButton;
end

-- Dropdown menu factory
function createDropDownMenu(parent, x_loc, y_loc, id, name, tooltip, options, width, default_value, labelText, on_select_func)
    -- on_select_func = on_select_func or function()
    frameCount = frameCount + 1;
    local dropDown = CreateFrame("Frame", '$parent_DropDown_' .. id, parent, 'UIDropDownMenuTemplate');
    local dropDownTitle = dropDown:CreateFontString(dropDown, 'OVERLAY', 'GameFontNormal');
    dropDown:SetPoint("TOPLEFT", x_loc, y_loc);
    createLabel(parent, x_loc + 20, y_loc + 15, 100, 50, "dropDrownTitle_" .. id, labelText, "GameTooltipText");
    for _, option in pairs(options) do
        dropDownTitle:SetText(item);
        local text_width = dropDownTitle:GetStringWidth() + 20;
        if text_width > width then
            width = text_width;
        end
    end

    --local labelFrame = CreateFrame("Frame");
    --local text = label:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    --text:SetText("name")

    UIDropDownMenu_SetWidth(dropDown, width);
    UIDropDownMenu_SetText(dropDown, default_value);

    UIDropDownMenu_Initialize(dropDown, function(self, level, _)
        local info = UIDropDownMenu_CreateInfo();
        for key, val in pairs (options) do
            info.text = key;
            info.value = val;
            info.checked = false;
            info.menuList = key;
            info.hasArrow = false;
            info.func = function(inf)
                UIDropDownMenu_SetSelectedValue(dropDown, inf.value, inf.value)
                inf.checked = true;
                on_select_func(dropDown, inf.value);
            end
            UIDropDownMenu_AddButton(info);
        end
    end)

    return dropDown;
end

-- Slider factory
function createSlider(parent, x_loc, y_loc, id, displayName, step, minValue, maxValue, labelText)
    frameCount = frameCount + 1;
    local slider = CreateFrame("Slider", "$parent_Slider_" .. id, parent, "OptionsSliderTemplate");
    slider:SetMinMaxValues(minValue, maxValue);
    slider:SetOrientation('HORIZONTAL');
    slider:SetPoint("TOPLEFT", x_loc, y_loc);
    slider:SetObeyStepOnDrag(true);
    slider:SetValueStep(step);

    createLabel(parent, x_loc, y_loc + 15, 100, 50, "sliderTitle_" .. id, displayName, "GameTooltipText");

    return slider;
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
    Default='default',
    Self='self',
    Party='party',
    Raid='raid',
    Yell='yell',
    Emote='emote'
};

-- onChange function for output channel dropdown
local onChange_outputChannelDropdown = function(dropDown_frame, dropDown_val)
    ElitismHelperDB.OutputMode = dropDown_val;
    print(dropDown_val);
end

-- Build output channel dropdown
local EH_DropDown_OutputChannel = createDropDownMenu(EH_configFrame,
                                                    dx_loc - 10, dy_loc * frameCount - 20 - y_loc_origin_shift,
                                                    'OutputChannel',
                                                    'Output channel',
                                                    'Define output channel for announcer and end of dungeon stats.',
                                                    output_channel_opts,
                                                    100,
                                                    'default',
                                                    'Output channel',
                                                    onChange_outputChannelDropdown);
                                                
-- Build slider for the treshold damage
local EH_Slider_Treshold = createSlider(EH_configFrame,
                                        dx_loc + dx_loc,
                                        dy_loc * (frameCount + 1) - 10 - (y_loc_origin_shift + 10),
                                        'damageThreshold',
                                        "Damage threshold",
                                        1,
                                        0,
                                        100);
_G[EH_Slider_Treshold:GetName() .. "Low"]:SetText(0);
_G[EH_Slider_Treshold:GetName() .. "High"]:SetText(100);
                                        
-- EH_Slider_Treshold:SetTooltip("Configure the thresold damage.")
EH_Slider_Treshold:Show();
EH_Slider_Treshold:SetScript("OnMouseUp",
    function(self)
        local value = self:GetValue();
        ElitismHelperDB.Threshold = value;
        print("Click slider. Slider value: " .. value);
    end
);

local EH_labelTest = createLabel(EH_configFrame, dx_loc, dy_loc + 10, 100, 100, "ehTitle", "Elitism Helper", "GameFontNormalLarge");

-- ADDON_LOADED event
EH_configFrame:SetScript("OnEvent", function(self)
    print("ElitismHelperDB.Loud: " .. tostring(ElitismHelperDB.Loud));
    print("ElitismHelperDB.EndOfDungeonMessage: " .. tostring(ElitismHelperDB.EndOfDungeonMessage));
    print("ElitismHelperDB.OutputMode: " .. ElitismHelperDB.OutputMode);
    print("ElitismHelperDB.Threshold: " .. tostring(ElitismHelperDB.Threshold));
    EH_CheckButton_EnableAnnouncer:SetChecked(ElitismHelperDB.Loud);
    EH_CheckButton_EnableEndOfDungeon:SetChecked(ElitismHelperDB.EndOfDungeonMessage);
    EH_Slider_Treshold:SetValue(ElitismHelperDB.Threshold);
    UIDropDownMenu_SetText(EH_DropDown_OutputChannel, ElitismHelperDB.OutputMode);
end)

InterfaceOptions_AddCategory(EH_configFrame);