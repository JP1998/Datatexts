

if GetLocale() ~= "deDE" then
    return;
end

local _, app = ...;
local L = app.L;

for key, value in pairs({
    -- ["TITLE"] = "|cff36465dData Texts|r";
})
do L[key] = value; end
