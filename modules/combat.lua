local app = select(2, ...);
local L = app.L;

app.Combat = {};

app.Combat.Initialize = function()
    app.Combat.Frame = app.Frame:CreateFontString("Datatexts-Combat");
    app.Combat.Frame:SetPoint("LEFT", app.Time.Frame, "TOP", 1, 8);
    app.Combat.Frame:SetFont("Fonts/FRIZQT__.TTF", 14, "OUTLINE");
    app.Combat.Frame:SetTextColor(1, 1, 1);
    app.Combat.Frame:SetShadowColor(0, 0, 0);
    app.Combat.Frame:SetShadowOffset(1,-1);
    app.Combat.Frame:Show();

    app.Combat.inCombat = false;
    app.Combat.Frame:SetText("-combat");

    app:RegisterEvent("PLAYER_REGEN_DISABLED", "Datatexts-Combat", app.Combat.OnRegenDisabled);
    app:RegisterEvent("PLAYER_REGEN_ENABLED", "Datatexts-Combat", app.Combat.OnRegenEnabled);
end

app.Combat.OnRegenDisabled = function()
    app.Combat.inCombat = true;
    app.Combat.Frame:SetText(app.colorString("+combat"));
end
app.Combat.OnRegenEnabled = function()
    app.Combat.inCombat = false;
    app.Combat.Frame:SetText("-combat");
end
