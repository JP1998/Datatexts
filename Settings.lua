
local app = select(2, ...);
local L = app.L;

local initialized = false;

app.Settings = {};
local settings = app.Settings;

local settingsFrame = CreateFrame("FRAME", app:GetName() .. "-Settings", UIParent);
settings.Frame = settingsFrame;

settingsFrame.name = app:GetName();
settingsFrame.MostRecentTab = nil;
settingsFrame.Tabs = {};
settingsFrame.ModifierKeys = { "None", "Shift", "Ctrl", "Alt" };

local mainCategory = Settings.RegisterCanvasLayoutCategory(settingsFrame, settingsFrame.name, settingsFrame.name);
mainCategory.ID = settingsFrame.name;
Settings.RegisterAddOnCategory(mainCategory);

settings.Open = function(self)
    -- Open the Options menu.
    if not SettingsPanel:IsVisible() then
        SettingsPanel:Show();
    end

    Settings.OpenToCategory(app:GetName());
end

local SettingsBase = {
    ["Time"] = {
        ["twentyFourHour"] = true,
        ["localTime"] = true,
    },
    ["SystemStats"] = {
        ["worldMS"] = false,
        ["combo"] = true,
        ["fpsRefresh"] = 2,
    },
    ["General"] = {
        ["anchor"] = "TOPLEFT",
        ["offsetX"] = 60,
        ["offsetY"] = -20,
    },
};
local OnClickForTab = function(self)
    local id = self:GetID();
    local parent = self:GetParent();
    
    PanelTemplates_SetTab(parent, id);
    
    for i,tab in ipairs(parent.Tabs) do
        if i == id then
            for j,o in ipairs(tab.objects) do
                o:Show();
            end
        else
            for j,o in ipairs(tab.objects) do
                o:Hide();
            end
        end
    end
end;
settings.Initialize = function(self)
    PanelTemplates_SetNumTabs(self.Frame, #self.Frame.Tabs);

    if not DatatextsSettings then
        DatatextsSettings = CopyTable(SettingsBase);
    end

    settings.Data = DatatextsSettings;

    app.Settings.PositionSettings.XSlider:SetValue(DatatextsSettings["General"]["offsetX"]);
    app.Settings.PositionSettings.YSlider:SetValue(DatatextsSettings["General"]["offsetY"]);

    app.Settings.PositionSettings.Alignment["RadioButton_" .. DatatextsSettings["General"]["anchor"]]:SetChecked(true);

    app.Settings.TimeSettings.TwentyFourHourCheckbox:SetChecked(DatatextsSettings["Time"]["twentyFourHour"]);
    app.Settings.TimeSettings.LocalTimeCheckbox:SetChecked(DatatextsSettings["Time"]["localTime"]);

    app.Settings.SystemStatsSettings.WorldMSCheckbox:SetChecked(DatatextsSettings["SystemStats"]["worldMS"]);
    app.Settings.SystemStatsSettings.ComboCheckbox:SetChecked(DatatextsSettings["SystemStats"]["combo"]);
    app.Settings.SystemStatsSettings.FpsRefreshSlider:SetValue(DatatextsSettings["SystemStats"]["fpsRefresh"]);

    self.Frame:Refresh();

    initialized = true;
end
settings.Get = function(self, category, option)
    if category == nil then
        return DatatextsSettings;
    elseif option == nil then
        return DatatextsSettings and DatatextsSettings[category];
    else
        return DatatextsSettings and DatatextsSettings[category][option];
    end
end
settings.Set = function(self, category, option, value)
    DatatextsSettings[category][option] = value;

    self.Frame:Refresh();
end
settingsFrame.AddObject = function(self, obj)
    if not self.objects then
        self.objects = {};
    end

    table.insert(self.objects, obj);
end
settingsFrame.Refresh = function(self)
    if not self.objects then
        return;
    end

    for i,obj in ipairs(self.objects) do
        if obj.OnRefresh then
            obj:OnRefresh();
        end
    end
end
settingsFrame.CreateCheckBox = function(self, parent, text, OnRefresh, OnClick)
    local cb = CreateFrame("CheckButton", self:GetName() .. "-" .. text, parent, "InterfaceOptionsCheckButtonTemplate");

    cb:SetScript("OnClick", OnClick);
    cb.OnRefresh = OnRefresh;
    cb.Text:SetText(text);
    cb:SetHitRectInsets(0,0 - cb.Text:GetWidth(),0,0);
    cb:Show();

    return cb;
end
settingsFrame.CreateTab = function(self, text, scroll)
    local id = #self.Tabs + 1;

    local settingsPanel;
    local subcategoryPanel;

    if scroll then
        local scrollFrame = CreateFrame("ScrollFrame", self:GetName() .. "-Tab" .. id .. "-Scroll", self, "ScrollFrameTemplate");
        settingsPanel = CreateFrame("Frame", self:GetName() .. "-Tab" .. id);
        
        scrollFrame:SetScrollChild(settingsPanel);
        settingsPanel:SetID(id);
        settingsPanel:SetWidth(1);    -- This is automatically defined, so long as the attribute exists at all
        settingsPanel:SetHeight(1);   -- This is automatically defined, so long as the attribute exists at all

        -- Move the scrollbar to its proper position (only needed for subcategories)
        scrollFrame.ScrollBar:ClearPoint("RIGHT");
        scrollFrame.ScrollBar:SetPoint("RIGHT", -36, 0);

        scrollFrame.Content = settingsPanel;

        -- Create the nested subcategory
        subcategoryPanel = scrollFrame;
    else
        settingsPanel = CreateFrame("Frame", self:GetName() .. "-Tab" .. id);
        
        settingsPanel:SetID(id);

        subcategoryPanel = settingsPanel;
    end

    subcategoryPanel.name = text;
    subcategoryPanel.parent = app:GetName();

    local subcategory = Settings.RegisterCanvasLayoutSubcategory(mainCategory, subcategoryPanel, text)

    table.insert(self.Tabs, settingsPanel);

    return subcategoryPanel;
end

local f = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
f:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 12, -12);
f:SetJustifyH("LEFT");
f:SetText(L["TITLE"]);
f:SetScale(1.5);
f:Show();
settingsFrame.title = f;

f = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
f:SetPoint("TOPRIGHT", settingsFrame, "TOPRIGHT", -12, -12);
f:SetJustifyH("RIGHT");
f:SetText("v" .. C_AddOns.GetAddOnMetadata(app:GetName(), "Version"));
f:Show();
settingsFrame.version = f;


app.Settings.PositionSettings = {};


local General_Label = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhite");
General_Label:SetPoint("TOPLEFT", settingsFrame.title, "BOTTOMLEFT", 0, -24);
General_Label:SetJustifyH("LEFT");
General_Label:SetTextColor(1, 0.82, 0, 1);
General_Label:SetText("General");
General_Label:Show();


local PositionSettings_XSlider = CreateFrame("Slider", "Datatexts-Settings-PositionSettings_XSlider", settingsFrame, "MinimalSliderTemplate");

PositionSettings_XSlider:SetPoint("TOPLEFT", General_Label, "BOTTOMLEFT", 0, -18);
PositionSettings_XSlider:SetPoint("RIGHT", settingsFrame, "RIGHT", -12, 0);
PositionSettings_XSlider:SetHeight(17);
PositionSettings_XSlider:SetMinMaxValues(-1000, 1000);
PositionSettings_XSlider:SetValueStep(1);
PositionSettings_XSlider:SetObeyStepOnDrag(true);

local PositionSettings_XSlider_Label = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhite");
PositionSettings_XSlider_Label:SetPoint("CENTER", PositionSettings_XSlider, "CENTER", 0, 12);
PositionSettings_XSlider_Label:SetJustifyH("LEFT");
PositionSettings_XSlider_Label:SetText("X Offset");
PositionSettings_XSlider_Label:Show();

local PositionSettings_XSlider_ValueLabel = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhite");
PositionSettings_XSlider_ValueLabel:SetPoint("TOPLEFT", PositionSettings_XSlider, "BOTTOMLEFT", 0, 0);
PositionSettings_XSlider_ValueLabel:SetJustifyH("LEFT");
PositionSettings_XSlider_ValueLabel:SetText("50");
PositionSettings_XSlider_ValueLabel:Show();

PositionSettings_XSlider:SetScript("OnValueChanged", function(self, value, userInput)
    PositionSettings_XSlider_ValueLabel:SetText("" .. value);

    if userInput then
        app.Settings:Set("General", "offsetX", value);
        app:UpdateFramePosition();
    end
end)

app.Settings.PositionSettings.XSlider = PositionSettings_XSlider;

local PositionSettings_YSlider = CreateFrame("Slider", "Datatexts-Settings-PositionSettings_YSlider", settingsFrame, "MinimalSliderTemplate");

PositionSettings_YSlider:SetPoint("TOPLEFT", PositionSettings_XSlider, "BOTTOMLEFT", 0, -18);
PositionSettings_YSlider:SetPoint("RIGHT", settingsFrame, "RIGHT", -12, 0);
PositionSettings_YSlider:SetHeight(17);
PositionSettings_YSlider:SetMinMaxValues(-1000, 1000);
PositionSettings_YSlider:SetValueStep(1);
PositionSettings_YSlider:SetObeyStepOnDrag(true);

local PositionSettings_YSlider_Label = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhite");
PositionSettings_YSlider_Label:SetPoint("CENTER", PositionSettings_YSlider, "CENTER", 0, 12);
PositionSettings_YSlider_Label:SetJustifyH("LEFT");
PositionSettings_YSlider_Label:SetText("Y Offset");
PositionSettings_YSlider_Label:Show();

local PositionSettings_YSlider_ValueLabel = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhite");
PositionSettings_YSlider_ValueLabel:SetPoint("TOPLEFT", PositionSettings_YSlider, "BOTTOMLEFT", 0, 0);
PositionSettings_YSlider_ValueLabel:SetJustifyH("LEFT");
PositionSettings_YSlider_ValueLabel:SetText("50");
PositionSettings_YSlider_ValueLabel:Show();

PositionSettings_YSlider:SetScript("OnValueChanged", function(self, value, userInput)
    PositionSettings_YSlider_ValueLabel:SetText("" .. value);

    if userInput then
        app.Settings:Set("General", "offsetY", value);
        app:UpdateFramePosition();
    end
end)

app.Settings.PositionSettings.YSlider = PositionSettings_YSlider;

app.Settings.PositionSettings.Alignment = {};

local PositionSettings_Alignment_Caption = settingsFrame:CreateFontString("PositionSettings_Alignment_Caption", "ARTWORK", "GameFontWhite");
PositionSettings_Alignment_Caption:SetPoint("TOP", PositionSettings_YSlider, "BOTTOM", 0, -12);
PositionSettings_Alignment_Caption:SetPoint("LEFT", settingsFrame, "LEFT", 0, 0);
PositionSettings_Alignment_Caption:SetPoint("RIGHT", settingsFrame, "RIGHT", 0, 0);
PositionSettings_Alignment_Caption:SetJustifyH("CENTER");
PositionSettings_Alignment_Caption:SetText("Alignment");
PositionSettings_Alignment_Caption:Show();

local alignments = {
    "TOPLEFT",
    "TOP",
    "TOPRIGHT",
    "LEFT",
    "CENTER",
    "RIGHT",
    "BOTTOMLEFT",
    "BOTTOM",
    "BOTTOMRIGHT"
};

for row = 1,3 do
    for col = 1,3 do
        local alignment = alignments[(row - 1) * 3 + col];

        local cb = CreateFrame("CheckButton", "PositionSettings_Alignment_" .. alignment, settingsFrame, "UIRadioButtonTemplate");
        cb:SetPoint("CENTER", PositionSettings_Alignment_Caption, "CENTER", (col - 2) * 150, row * -36 + 12);
        cb.CheckValue = alignment;
        cb:Show();

        app.Settings.PositionSettings.Alignment["RadioButton_" .. alignment] = cb;

        cb:SetScript("OnClick", function(self, button, down)
            for i,a in ipairs(alignments) do
                if a ~= self.CheckValue then
                    app.Settings.PositionSettings.Alignment["RadioButton_" .. a]:SetChecked(false);
                end
            end

            app.Settings:Set("General", "anchor", self.CheckValue);
            app:UpdateFramePosition();
        end);
    end
end


app.Settings.TimeSettings = {};


local Time_Label = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhite");
Time_Label:SetPoint("LEFT", settingsFrame.title, "LEFT", 0, 0);
Time_Label:SetPoint("TOP", app.Settings.PositionSettings.Alignment.RadioButton_BOTTOM, "BOTTOM", 0, -24);
Time_Label:SetJustifyH("LEFT");
Time_Label:SetTextColor(1, 0.82, 0, 1);
Time_Label:SetText("Time");
Time_Label:Show();

local TimeSettings_TwentyFourHour_Checkbox = CreateFrame("CheckButton", "TimeSettings_TwentyFourHour_Checkbox", settingsFrame, "InterfaceOptionsCheckButtonTemplate");
TimeSettings_TwentyFourHour_Checkbox:SetPoint("TOPLEFT", Time_Label, "BOTTOMLEFT", 0, -6);
TimeSettings_TwentyFourHour_Checkbox.Text:SetText("Use 24h time formatting (also known as \"military time\").");
TimeSettings_TwentyFourHour_Checkbox.Text:SetTextColor(1, 1, 1, 1);
TimeSettings_TwentyFourHour_Checkbox:SetScript("OnClick", function(self, button, down)
    app.Settings:Set("Time", "twentyFourHour", self:GetChecked());
    app.Time.OnUpdate();
end);
TimeSettings_TwentyFourHour_Checkbox:Show();

app.Settings.TimeSettings.TwentyFourHourCheckbox = TimeSettings_TwentyFourHour_Checkbox;

local TimeSettings_LocalTime_Checkbox = CreateFrame("CheckButton", "TimeSettings_LocalTime_Checkbox", settingsFrame, "InterfaceOptionsCheckButtonTemplate");
TimeSettings_LocalTime_Checkbox:SetPoint("TOPLEFT", TimeSettings_TwentyFourHour_Checkbox, "BOTTOMLEFT", 0, 0);
TimeSettings_LocalTime_Checkbox.Text:SetText("Use local time. (Will use server time if not checked)");
TimeSettings_LocalTime_Checkbox.Text:SetTextColor(1, 1, 1, 1);
TimeSettings_LocalTime_Checkbox:SetScript("OnClick", function(self, button, down)
    app.Settings:Set("Time", "localTime", self:GetChecked());
    app.Time.OnUpdate();
end);
TimeSettings_LocalTime_Checkbox:Show();

app.Settings.TimeSettings.LocalTimeCheckbox = TimeSettings_LocalTime_Checkbox;


app.Settings.SystemStatsSettings = {};


local SystemStats_Label = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhite");
SystemStats_Label:SetPoint("TOPLEFT", TimeSettings_LocalTime_Checkbox, "BOTTOMLEFT", 0, -24);
SystemStats_Label:SetJustifyH("LEFT");
SystemStats_Label:SetTextColor(1, 0.82, 0, 1);
SystemStats_Label:SetText("System Stats");
SystemStats_Label:Show();

local SystemStatsSettings_WorldMS_Checkbox = CreateFrame("CheckButton", "SystemStatsSettings_WorldMS_Checkbox", settingsFrame, "InterfaceOptionsCheckButtonTemplate");
SystemStatsSettings_WorldMS_Checkbox:SetPoint("TOPLEFT", SystemStats_Label, "BOTTOMLEFT", 0, -6);
SystemStatsSettings_WorldMS_Checkbox.Text:SetText("Display world ms as ping. (Will show home ping if not checked)");
SystemStatsSettings_WorldMS_Checkbox.Text:SetTextColor(1, 1, 1, 1);
SystemStatsSettings_WorldMS_Checkbox:SetScript("OnClick", function(self, button, down)
    app.Settings:Set("SystemStats", "worldMS", self:GetChecked());
    app.SystemStats.OnUpdate();
end);
SystemStatsSettings_WorldMS_Checkbox:Show();

app.Settings.SystemStatsSettings.WorldMSCheckbox = SystemStatsSettings_WorldMS_Checkbox;

local SystemStatsSettings_Combo_Checkbox = CreateFrame("CheckButton", "SystemStatsSettings_Combo_Checkbox", settingsFrame, "InterfaceOptionsCheckButtonTemplate");
SystemStatsSettings_Combo_Checkbox:SetPoint("TOPLEFT", SystemStatsSettings_WorldMS_Checkbox, "BOTTOMLEFT", 0, 0);
SystemStatsSettings_Combo_Checkbox.Text:SetText("Display both world and home ping.");
SystemStatsSettings_Combo_Checkbox.Text:SetTextColor(1, 1, 1, 1);
SystemStatsSettings_Combo_Checkbox:SetScript("OnClick", function(self, button, down)
    app.Settings:Set("SystemStats", "combo", self:GetChecked());
    app.SystemStats.OnUpdate();
end);
SystemStatsSettings_Combo_Checkbox:Show();

app.Settings.SystemStatsSettings.ComboCheckbox = SystemStatsSettings_Combo_Checkbox;

local SystemStatsSettings_FpsRefresh_Slider = CreateFrame("Slider", "Datatexts-Settings-SystemStatsSettings_FpsRefresh_Slider", settingsFrame, "MinimalSliderTemplate");

SystemStatsSettings_FpsRefresh_Slider:SetPoint("TOPLEFT", SystemStatsSettings_Combo_Checkbox, "BOTTOMLEFT", 0, -18);
SystemStatsSettings_FpsRefresh_Slider:SetPoint("RIGHT", settingsFrame, "RIGHT", -12, 0);
SystemStatsSettings_FpsRefresh_Slider:SetHeight(17);
SystemStatsSettings_FpsRefresh_Slider:SetMinMaxValues(0.1, 10);
SystemStatsSettings_FpsRefresh_Slider:SetValueStep(0.1);
SystemStatsSettings_FpsRefresh_Slider:SetObeyStepOnDrag(true);

local SystemStatsSettings_FpsRefresh_Label = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhite");
SystemStatsSettings_FpsRefresh_Label:SetPoint("CENTER", SystemStatsSettings_FpsRefresh_Slider, "CENTER", 0, 12);
SystemStatsSettings_FpsRefresh_Label:SetJustifyH("LEFT");
SystemStatsSettings_FpsRefresh_Label:SetText("System Stats Update Throttle (in seconds)");
SystemStatsSettings_FpsRefresh_Label:Show();

local SystemStatsSettings_FpsRefresh_ValueLabel = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhite");
SystemStatsSettings_FpsRefresh_ValueLabel:SetPoint("TOPLEFT", SystemStatsSettings_FpsRefresh_Slider, "BOTTOMLEFT", 0, 0);
SystemStatsSettings_FpsRefresh_ValueLabel:SetJustifyH("LEFT");
SystemStatsSettings_FpsRefresh_ValueLabel:SetText("50");
SystemStatsSettings_FpsRefresh_ValueLabel:Show();

SystemStatsSettings_FpsRefresh_Slider:SetScript("OnValueChanged", function(self, value, userInput)
    SystemStatsSettings_FpsRefresh_ValueLabel:SetText(("%.2fs"):format(value));

    if userInput then
        app.Settings:Set("SystemStats", "fpsRefresh", value);
    end
end)

app.Settings.SystemStatsSettings.FpsRefreshSlider = SystemStatsSettings_FpsRefresh_Slider;
