
local app = select(2, ...);
local L = app.L;

app.Durability = {};

app.Durability.Initialize = function()
    app.Durability.Frame = app.Frame:CreateFontString("Datatexts-Durability");
    app.Durability.Frame:SetPoint("RIGHT", app.SystemStats.Frame, "LEFT", -1, 0);
    app.Durability.Frame:SetFont("Fonts/FRIZQT__.TTF", 14, "THICKOUTLINE");
    app.Durability.Frame:SetTextColor(1, 1, 1);
    app.Durability.Frame:SetShadowColor(0, 0, 0);
    app.Durability.Frame:Show();

    app.Durability.total = 0;

    app:RegisterEvent("PLAYER_DEAD", "Datatexts-Durability", app.Durability.OnUpdate);
    app:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "Datatexts-Durability", app.Durability.OnUpdate);
    app:RegisterEvent("LOADING_SCREEN_DISABLED", "Datatexts-Durability", app.Durability.OnUpdate);
    app:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "Datatexts-Durability", app.Durability.OnUpdate);
end

app.Durability.OnUpdate = function()
    local totalCurr = 0;
    local totalMax = 0;

    for i = 1, 18 do
        if GetInventoryItemDurability(i) ~= nil then
            local currDurability, maxDurability = GetInventoryItemDurability(i);

            totalCurr = totalCurr + currDurability;
            totalMax = totalMax + maxDurability;

            app.Durability.total = math.floor(totalCurr / totalMax * 100);
        end
    end

    app.Durability.Frame:SetText(("|TInterface/ICONS/Trade_BlackSmithing:0|t %s"):format(app.colorString(app.Durability.total.."%")));
end
