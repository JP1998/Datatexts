
local app = select(2, ...);
local L = app.L;

app.SystemStats = {};

app.SystemStats.Initialize = function()
    app.SystemStats.Frame = app.Frame:CreateFontString("Datatexts-SystemStats");
    app.SystemStats.Frame:SetPoint("CENTER", app.Time.Frame, "BOTTOM", 0, -4);
    app.SystemStats.Frame:SetFont("Fonts/FRIZQT__.TTF", 14, "THICKOUTLINE");
    app.SystemStats.Frame:SetTextColor(1, 1, 1);
    app.SystemStats.Frame:SetShadowColor(0, 0, 0);
    app.SystemStats.Frame:Show();

    app.SystemStats.fps = 0;
    app.SystemStats.hlat = 0;
    app.SystemStats.wlat = 0;
    app.SystemStats.latency = 0;
end

app.SystemStats.OnUpdate = function()
    local config = app.Settings:Get("SystemStats");

    app.SystemStats.fps = GetFramerate();

    app.SystemStats.hLat, app.SystemStats.wLat = select(3, GetNetStats());
    if config.worldMS then
        app.SystemStats.latency = app.SystemStats.wLat;
    else
        app.SystemStats.latency = app.SystemStats.hLat;
    end

    local systemStats = "";
    if config.combo then
        systemStats = ("%.0f%s %.0f(%.0f)%s"):format(app.SystemStats.fps, app.colorString("fps"), app.SystemStats.wLat, app.SystemStats.hLat, app.colorString("ms"))
    else
        systemStats = ("%.0f%s %.0f%s"):format(app.SystemStats.fps, app.colorString("fps"), app.SystemStats.latency, app.colorString("ms"))
    end

    app.SystemStats.Frame:SetText(systemStats);
end
