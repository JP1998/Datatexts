local app = select(2, ...);
local L = app.L;

app.WarMode = {};

app.WarMode.GetStatusText = function(self, warmode)
    if warmode then
        return "|cFF00FF00On|r";
    elseif not warmode then
        return "|cFFFF0000Off|r";
    else
        return "";
    end
end

app.WarMode.Initialize = function()
    app.WarMode.Frame = app.Frame:CreateFontString("Datatexts-WarMode");
    app.WarMode.Frame:SetPoint("RIGHT", app.Time.Frame, "TOP", -1, 8);
    app.WarMode.Frame:SetFont("Fonts/FRIZQT__.TTF", 14, "OUTLINE");
    app.WarMode.Frame:SetTextColor(1, 1, 1);
    app.WarMode.Frame:SetShadowColor(0, 0, 0);
    app.WarMode.Frame:SetShadowOffset(1,-1);
    app.WarMode.Frame:Show();

    app.WarMode.warmode = C_PvP.IsWarModeDesired();
    app.WarMode.toggle = app.WarMode:GetStatusText(app.WarMode.warmode);

    app:RegisterEvent("LOADING_SCREEN_DISABLED", "Datatexts-WarMode", app.WarMode.OnUpdate);
    app:RegisterEvent("PLAYER_FLAGS_CHANGED", "Datatexts-WarMode", app.WarMode.OnUpdate);
end

app.WarMode.OnUpdate = function()
    app.WarMode.warmode = C_PvP.IsWarModeDesired();
    app.WarMode.toggle = app.WarMode:GetStatusText(app.WarMode.warmode);

    app.WarMode.Frame:SetText(app.colorString("War: " .. app.WarMode.toggle));
end
