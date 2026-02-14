
local app = select(2, ...);
local L = app.L;

app.LootSpec = {};

app.LootSpec.IconLookup = { -- This table contains a LUT mapping **spec ID** (not icon id) to icon path
    -- Death Knight
    [250] = "Interface/ICONS/Spell_Deathknight_BloodPresence.blp", -- Blood
    [251] = "Interface/ICONS/Spell_Deathknight_FrostPresence.blp", -- Frost
    [252] = "Interface/ICONS/Spell_Deathknight_UnholyPresence.blp", -- Unholy

    -- Demon Hunter
    [577] = "Interface/ICONS/Ability_DemonHunter_SpecDPS.blp", -- Havoc
    [581] = "Interface/ICONS/Ability_DemonHunter_SpecTank.blp", -- Vengeance
    [1480] = "Interface/ICONS/Classicon_DemonHunter_Void.blp", -- Devourer

    -- Druid
    [102] = "Interface/ICONS/Spell_Nature_StarFall.blp", -- Balance
    [103] = "Interface/ICONS/Ability_Druid_CatForm.blp", -- Feral
    [104] = "Interface/ICONS/Ability_Racial_BearForm.blp", -- Guardian
    [105] = "Interface/ICONS/SPELL_NATURE_HEALINGTOUCH.BLP", -- Restoration

    -- Evoker
    [1467] = "Interface/ICONS/ClassIcon_Evoker_Devastation.blp", -- Devastation
    [1468] = "Interface/ICONS/ClassIcon_Evoker_Preservation.blp", -- Preservation
    [1473] = "Interface/ICONS/ClassIcon_Evoker_Augmentation.blp", -- Augmentation

    -- Hunter
    [253] = "Interface/ICONS/ABILITY_HUNTER_BESTIALDISCIPLINE.BLP", -- Beast Mastery
    [254] = "Interface/ICONS/Ability_Hunter_FocusedAim.blp", -- Marksmanship
    [255] = "Interface/ICONS/Ability_Hunter_Camouflage.blp", -- Survival

    -- Mage
    [62] = "Interface/ICONS/Spell_Holy_MagicalSentry.blp", -- Arcane
    [63] = "Interface/ICONS/Spell_Fire_FireBolt02.blp", -- Fire
    [64] = "Interface/ICONS/Spell_Frost_FrostBolt02.blp", -- Frost

    -- Monk
    [268] = "Interface/ICONS/Spell_Monk_Brewmaster_Spec.blp", -- Brewmaster
    [270] = "Interface/ICONS/Spell_Monk_MistWeaver_Spec.blp", -- Mistweaver
    [269] = "Interface/ICONS/Spell_Monk_WindWalker_Spec.blp", -- Windwalker

    -- Paladin
    [65] = "Interface/ICONS/Spell_Holy_HolyBolt.blp", -- Holy
    [66] = "Interface/ICONS/Ability_Paladin_ShieldoftheTemplar.blp", -- Protection
    [70] = "Interface/ICONS/Spell_Holy_AuraOfLight.blp", -- Retribution

    -- Priest
    [256] = "Interface/ICONS/Spell_Holy_PowerWordShield.blp", -- Discipline
    [257] = "Interface/ICONS/Spell_Holy_GuardianSpirit.blp", -- Holy
    [258] = "Interface/ICONS/Spell_Shadow_ShadowWordPain.blp", -- Shadow

    -- Rogue
    [259] = "Interface/ICONS/Ability_Rogue_DeadlyBrew.blp", -- Assassination
    [260] = "Interface/ICONS/Ability_Rogue_Waylay.blp", -- Outlaw
    [261] = "Interface/ICONS/Ability_Stealth.blp", -- Subtlety

    -- Shaman
    [263] = "Interface/ICONS/Spell_Shaman_ImprovedStormstrike.blp", -- Enhancement
    [262] = "Interface/ICONS/Spell_Nature_Lightning.blp", -- Elemental
    [264] = "Interface/ICONS/Spell_Nature_MagicImmunity.blp", -- Restoration

    -- Warlock
    [265] = "Interface/ICONS/Spell_Shadow_DeathCoil.blp", -- Affliction
    [266] = "Interface/ICONS/Spell_Shadow_Metamorphosis.blp", -- Demonology
    [267] = "Interface/ICONS/Spell_Shadow_RainOfFire.blp", -- Destruction

    -- Warrior
    [71] = "Interface/ICONS/Ability_Warrior_SavageBlow.blp", -- Arms
    [72] = "Interface/ICONS/Ability_Warrior_InnerRage.blp", -- Fury
    [73] = "Interface/ICONS/Ability_Warrior_DefensiveStance.blp", -- Protection
};

app.LootSpec.Initialize = function()
    app.LootSpec.Frame = app.Frame:CreateFontString("Datatexts-LootSpec");
    app.LootSpec.Frame:SetPoint("LEFT", app.SystemStats.Frame, "RIGHT", 1, 0);
    app.LootSpec.Frame:SetFont("Fonts/FRIZQT__.TTF", 14, "OUTLINE");
    app.LootSpec.Frame:SetTextColor(1, 1, 1);
    app.LootSpec.Frame:SetShadowColor(0, 0, 0);
    app.LootSpec.Frame:SetShadowOffset(1,-1);
    app.LootSpec.Frame:Show();

    app:RegisterEvent("LOADING_SCREEN_DISABLED", "Datatexts-LootSpec", app.LootSpec.OnUpdate);
    app:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED", "Datatexts-LootSpec", app.LootSpec.OnUpdate);
    app:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "Datatexts-LootSpec", app.LootSpec.OnUpdate);
end

app.LootSpec.OnUpdate = function()
    local lootspec = GetLootSpecialization();

    if lootspec == 0 then
        lootspec = GetSpecializationInfo(GetSpecialization());
    end

    local specIconPath = "Interface/ICONS/INV_BabyVoidwalker_Dark.blp";

    if app.LootSpec.IconLookup[lootspec] then
        specIconPath = app.LootSpec.IconLookup[lootspec];
    end

    app.LootSpec.Frame:SetText(("%s |T%s:0|t"):format(app.colorString("Loot:"), specIconPath));
end
