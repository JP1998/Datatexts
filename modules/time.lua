
local app = select(2, ...);
local L = app.L;

app.Time = {};

app.Time.colorString = function(str)
    return GetClassColoredTextForUnit("player", str)
end


app.Time.Initialize = function()
    app.Time.Frame = app.Frame:CreateFontString("Datatexts-Time");
    app.Time.Frame:SetPoint("CENTER", app.Frame, "CENTER", 0, 0);
    app.Time.Frame:SetFont("Fonts/FRIZQT__.TTF", 28, "THICKOUTLINE");
    app.Time.Frame:SetTextColor(1, 1, 1);
    app.Time.Frame:SetShadowColor(0, 0, 0);
    -- app.Time.Frame:SetText("10|cFF0070DD:|r29 |cFF0070DDPM|r");
    app.Time.Frame:Show();

    app.Time.ampm = "";
    app.Time.hour = 0;
    app.Time.minute = 0;
end

app.Time.OnUpdate = function()
    local c = app.Settings:Get("Time");

    app.Time.minute = date("%M")
    if c.localTime then
        if c.twentyFourHour then
            app.Time.hour = date("%H")
        else
            app.Time.ampm = date("%p")
            app.Time.hour = date("%I")
            app.Time.hour = app.Time.hour:match("0*(%d+)")
        end
    else
        app.Time.hour = GetGameTime()
        if c.twentyFourHour then
            app.Time.hour = "0"..tostring(app.Time.hour)
        else
            if app.Time.hour > 12 then
                app.Time.hour = math.abs(app.Time.hour - 12)
                app.Time.ampm = "PM"
            elseif app.Time.hour == 0 then
                app.Time.hour = 12
                app.Time.ampm = "AM"
            else
                app.Time.hour = app.Time.hour
                app.Time.ampm = "AM"
            end
            app.Time.hour = tostring(app.Time.hour)
            app.Time.hour = app.Time.hour:match("0*(%d+)")
        end
    end

    local updatedTime = "";
    if c.twentyFourHour then
        updatedTime = ("%s%s%s"):format(app.Time.hour, app.Time.colorString(":"), app.Time.minute);
    else
        updatedTime = ("%s%s%s%s"):format(app.Time.hour, app.Time.colorString(":"), app.Time.minute, app.Time.colorString(app.Time.ampm));
    end

    app.Time.Frame:SetText(updatedTime);
end
