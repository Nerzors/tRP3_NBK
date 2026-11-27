--[[
============================================================
Total RP 3: Nerzors Blacklist Keeper Tooltip Support
https://github.com/Nerzors/tRP3_NBK
============================================================

Requires both Total RP 3 and NerzorsBlacklistKeeper.
  https://github.com/Total-RP/Total-RP-3
  https://github.com/Nerzors/NerzorsBlacklistKeeper | Requires version 2.3.0 or higher

Author: Veplo (Discord: Veplo | https://github.com/Veplo-ops)
Support: nbk.Nerzors.com/en/feedback
Copyright by Nerzors.DE
============================================================
]]--
local ADDON_NAME, L = ...;

local IS_FOREVER = WOW_PROJECT_CAMELOT ~= nil and WOW_PROJECT_ID == WOW_PROJECT_CAMELOT

local TRP3NBK_Frame = CreateFrame("Frame")

TRP3NBK_Frame.LoadedStuff = false
TRP3NBK_Frame.DividerGraphic = CreateSimpleTextureMarkup(
    "interface\\friendsframe\\ui-friendsframe-onlinedivider", 320, 4)

local BRAND_HEX_PURPLE = "9b59b6"
local RED_HEX          = "ff6666"
local DIM_HEX          = "888c99"
local MUTE_HEX         = "ff9955"
local GREEN_HEX        = "5cb85c"

-- Remember Me star icons, shipped with NBK (NerzorsBlacklistKeeper_Data).
local STAR_DIR   = "Interface\\AddOns\\NerzorsBlacklistKeeper_Data\\Textures\\icons\\ratings\\"
local STAR       = "|T" .. STAR_DIR .. "star.png:14:14:0:0|t"
local STAR_EMPTY = "|T" .. STAR_DIR .. "star_empty.png:14:14:0:0|t"

local function ratingStars(n)
    n = math.max(0, math.min(5, tonumber(n) or 0))
    return string.rep(STAR, n) .. string.rep(STAR_EMPTY, 5 - n)
end

-- Applies TRP3's sub-line font size to the LAST line of the tooltip.
function TRP3NBK_Frame.FixFonts(small)
    small = small or false
    local size = TRP3_API.ui.tooltip.getSubLineFontSize()
    if small then size = TRP3_API.ui.tooltip.getSmallLineFontSize() end

    local numLines = TRP3_CharacterTooltip:NumLines()
    local left  = _G[strconcat(TRP3_CharacterTooltip:GetName(), "TextLeft",  numLines)]
    local right = _G[strconcat(TRP3_CharacterTooltip:GetName(), "TextRight", numLines)]

    if left then
        local font, _, flag = left:GetFont()
        left:SetFont(font, size, flag)
    end
    if right then
        local font, _, flag = right:GetFont()
        right:SetFont(font, size, flag)
    end
end

local function formatDate(ts)
    if not ts then return "-" end
    return date("%d.%m.%Y", ts)
end

-- Retail can hand out "secret" names (instances); never touch those.
local function isSecret(v)
    return issecretvalue ~= nil and issecretvalue(v) and true or false
end

local function getApi()
    return LibStub and LibStub("LibNBKApi-1.0", true) or nil
end

local function splitTarget(target)
    if type(target) ~= "string" or isSecret(target) or target == "" then return nil end
    local name, realm = strsplit("-", target, 2)
    if realm == "" then realm = nil end
    return name, realm
end

-- Only needed for NBK before 2.3.0 (LibNBKApi-1.0 MINOR 1). From MINOR 2 on
-- NBK does this itself (api:FromUnitName, and every name query accepts the
-- WoW: Forever form directly) https://nbk.nerzors.com/en/ .
local function toNbkNameLegacy(name, realm)
    if not IS_FOREVER or not name or not realm or realm == "" then
        return name, realm
    end
    -- A server ID ("CAMWOWEU5Realm3PvE") has digits, a second name never.
    if realm:find("%d") then return name, realm end
    return name .. " " .. realm, nil
end

-- TRP3's player ID ("Name-Realm", on Forever "First-Second") -> NBK name.
local function resolveTarget(api, target)
    local name, realm = splitTarget(target)
    if not name then return nil end
    if (api.VERSION or 1) >= 2 and api.FromUnitName then
        return api:FromUnitName(name, realm)
    end
    return toNbkNameLegacy(name, realm)
end

function TRP3NBK_Frame.Init()
    if TRP3NBK_Frame.LoadedStuff then return end
    TRP3NBK_Frame.LoadedStuff = true

    TRP3NBK_Frame.Config = {
        HIDE_NBK_TOOLTIPS_IC = "trp3_nbk_hide_tooltips_ic",
        ENABLE_DIVIDER       = "trp3_nbk_enable_divider",
        SHOW_REASON          = "trp3_nbk_show_reason",
        SHOW_NOTES           = "trp3_nbk_show_notes",
        SHOW_ZONE            = "trp3_nbk_show_zone",
        SHOW_ENCOUNTERS      = "trp3_nbk_show_encounters",
        SHOW_MUTE            = "trp3_nbk_show_mute",
        SHOW_PIN             = "trp3_nbk_show_pin",
        SHOW_REMEMBER        = "trp3_nbk_show_remember",
    }

    TRP3_API.configuration.registerConfigKey(TRP3NBK_Frame.Config.HIDE_NBK_TOOLTIPS_IC, false)
    TRP3_API.configuration.registerConfigKey(TRP3NBK_Frame.Config.ENABLE_DIVIDER,       false)
    TRP3_API.configuration.registerConfigKey(TRP3NBK_Frame.Config.SHOW_REASON,          true)
    TRP3_API.configuration.registerConfigKey(TRP3NBK_Frame.Config.SHOW_NOTES,           true)
    TRP3_API.configuration.registerConfigKey(TRP3NBK_Frame.Config.SHOW_ZONE,            true)
    TRP3_API.configuration.registerConfigKey(TRP3NBK_Frame.Config.SHOW_ENCOUNTERS,      true)
    TRP3_API.configuration.registerConfigKey(TRP3NBK_Frame.Config.SHOW_MUTE,            true)
    TRP3_API.configuration.registerConfigKey(TRP3NBK_Frame.Config.SHOW_PIN,             true)
    TRP3_API.configuration.registerConfigKey(TRP3NBK_Frame.Config.SHOW_REMEMBER,        true)

    local function cfg(key) return TRP3_API.configuration.getValue(key) end

    local function renderTooltip(t)
        local api = getApi()
        if not api then return end

        if TRP3_API.dashboard and TRP3_API.dashboard.isPlayerIC
           and TRP3_API.dashboard.isPlayerIC()
           and cfg(TRP3NBK_Frame.Config.HIDE_NBK_TOOLTIPS_IC) then
            return
        end

        local name, realm = resolveTarget(api, t.target)
        if not name then return end

        -- One lookup: GetBlacklistEntry is nil when not blacklisted. The
        -- blacklist wins over Remember Me, like in NBK's own tooltip.
        local entry = api:GetBlacklistEntry(name, realm)
        local remembered
        if not entry then
            if not cfg(TRP3NBK_Frame.Config.SHOW_REMEMBER) then return end
            remembered = api.GetRememberEntry and api:GetRememberEntry(name, realm)
            if not remembered then return end
        end

        local mainColor  = WHITE_FONT_COLOR
        local titleColor = NORMAL_FONT_COLOR
        if TRP3_Configuration and TRP3_Configuration[CONFIG_TOOLTIP_MAIN_COLOR] then
            mainColor = TRP3_API.CreateColorFromHexString(
                TRP3_API.configuration.getValue(CONFIG_TOOLTIP_MAIN_COLOR))
        end
        if TRP3_Configuration and TRP3_Configuration[CONFIG_TOOLTIP_TITLE_COLOR] then
            titleColor = TRP3_API.CreateColorFromHexString(
                TRP3_API.configuration.getValue(CONFIG_TOOLTIP_TITLE_COLOR))
        end

        local function color(hex, s) return "|cff" .. hex .. s .. "|r" end
        local function addLine(text, r, g, b, wrap)
            TRP3_CharacterTooltip:AddLine(text, r, g, b, wrap)
            TRP3NBK_Frame.FixFonts()
        end

        TRP3_CharacterTooltip:AddLine(" ")
        if cfg(TRP3NBK_Frame.Config.ENABLE_DIVIDER) then
            TRP3_CharacterTooltip:AddLine(TRP3NBK_Frame.DividerGraphic)
        end

        -- ── Remember Me (only when not blacklisted) ──
        if remembered then
            TRP3_CharacterTooltip:AddDoubleLine(
                color(BRAND_HEX_PURPLE, L.NBK) .. " " .. color(GREEN_HEX, L.REMEMBERED),
                ratingStars(remembered.rating),
                titleColor.r, titleColor.g, titleColor.b,
                mainColor.r,  mainColor.g,  mainColor.b)
            TRP3NBK_Frame.FixFonts()
            if cfg(TRP3NBK_Frame.Config.SHOW_NOTES) and remembered.notes and remembered.notes ~= "" then
                addLine(color(DIM_HEX, L.NOTES .. ":") .. " " .. remembered.notes,
                    mainColor.r, mainColor.g, mainColor.b, true)
            end
            if cfg(TRP3NBK_Frame.Config.SHOW_ZONE) and remembered.zone and remembered.zone ~= "" then
                addLine(color(DIM_HEX, L.ADDED_IN .. ":") .. " " .. remembered.zone,
                    mainColor.r, mainColor.g, mainColor.b, true)
            end
            -- Mythic+ run ("Dungeon +13"), NBK 2.3.0 and later, Only Retail
            if type(remembered.run) == "string" and remembered.run ~= "" then
                addLine(color(DIM_HEX, (L.RUN) .. ":") .. " " .. remembered.run,
                    mainColor.r, mainColor.g, mainColor.b, true)
            end
            TRP3_CharacterTooltip:Show()
            return
        end

        -- ── Blacklist ──
        local header = color(BRAND_HEX_PURPLE, L.NBK) .. " "
                     .. color(RED_HEX,        L.BLACKLISTED)
        TRP3_CharacterTooltip:AddDoubleLine(
            header,
            color(DIM_HEX, formatDate(entry.addedAt)),
            titleColor.r, titleColor.g, titleColor.b,
            mainColor.r,  mainColor.g,  mainColor.b)
        TRP3NBK_Frame.FixFonts()

        if cfg(TRP3NBK_Frame.Config.SHOW_REASON) then
            local reason = entry.reason
            local NBK = _G.NBK
            if reason and reason ~= "" and NBK and NBK.ReasonText then
                reason = NBK:ReasonText(reason)
            end
            if not reason or reason == "" then reason = L.NO_REASON end
            addLine(color(DIM_HEX, L.REASON .. ":") .. " " .. reason,
                mainColor.r, mainColor.g, mainColor.b, true)
        end

        if cfg(TRP3NBK_Frame.Config.SHOW_NOTES) and entry.notes and entry.notes ~= "" then
            addLine(color(DIM_HEX, L.NOTES .. ":") .. " " .. entry.notes,
                mainColor.r, mainColor.g, mainColor.b, true)
        end

        if cfg(TRP3NBK_Frame.Config.SHOW_ZONE) and entry.zone and entry.zone ~= "" then
            addLine(color(DIM_HEX, L.ADDED_IN .. ":") .. " " .. entry.zone,
                mainColor.r, mainColor.g, mainColor.b, true)
        end

        if cfg(TRP3NBK_Frame.Config.SHOW_ENCOUNTERS) then
            local count = entry.encounterCount or 0
            if count > 0 then
                local lastTxt = entry.lastSeen and formatDate(entry.lastSeen) or "-"
                addLine(color(DIM_HEX, L.ENCOUNTERS .. ":") .. " "
                    .. ("%d "):format(count)
                    .. color(DIM_HEX, "(" .. L.LAST_SEEN:format(lastTxt) .. ")"),
                    mainColor.r, mainColor.g, mainColor.b, false)
            end
        end

        if cfg(TRP3NBK_Frame.Config.SHOW_MUTE) and entry.mute ~= false then
            addLine(color(MUTE_HEX, L.CHAT_MUTED), 1, 0.6, 0.33, false)
        end

        if cfg(TRP3NBK_Frame.Config.SHOW_PIN) and entry.pinned then
            addLine(color(DIM_HEX, L.PINNED), 0.7, 0.7, 0.8, false)
        end

        TRP3_CharacterTooltip:Show()
    end

    if TRP3_CharacterTooltip then
        TRP3_CharacterTooltip:HookScript("OnShow", function(t)
            local ok, err = pcall(renderTooltip, t)
            if not ok and err then geterrorhandler()(err) end
        end)
    end

    local api = getApi()
    if api and api.RegisterCallback then
        api:RegisterCallback("BLACKLIST_CHANGED", function()
            if TRP3_CharacterTooltip and TRP3_CharacterTooltip:IsShown() then
                TRP3_CharacterTooltip:Hide()
            end
        end)
    end

    local IC_OOC_DROPDOWN = {
        { L.DROPDOWN_IC_OOC,   false },
        { L.DROPDOWN_OOC_ONLY, true  },
    }

    TRP3NBK_Frame.ConfigElements = {
        {
            inherit  = "TRP3_ConfigButton",
            title    = L.CONFIG_TITLE,
            help     = L.CONFIG_TITLE_HELP,
            text     = L.CONFIG_TITLE_TEXT,
            callback = function()
                if SlashCmdList and SlashCmdList.NBK then
                    SlashCmdList.NBK("config")
                end
            end,
        },
        { inherit = "TRP3_ConfigNote", title = " " },
        { inherit = "TRP3_ConfigH1",   title = L.CONFIG_MAINSETTINGS_TITLE },
        {
            inherit      = "TRP3_ConfigDropDown",
            widgetName   = "trp3_nbk_hide_tooltips_ic",
            title        = L.CONFIG_SHOWNBK_TITLE,
            help         = L.CONFIG_SHOWNBK_HELP,
            listContent  = IC_OOC_DROPDOWN,
            configKey    = TRP3NBK_Frame.Config.HIDE_NBK_TOOLTIPS_IC,
            listCallback = function(value)
                TRP3_API.configuration.setValue(TRP3NBK_Frame.Config.HIDE_NBK_TOOLTIPS_IC, value)
            end,
        },
        {
            inherit   = "TRP3_ConfigCheck",
            title     = L.CONFIG_DIVGRAPHIC_TITLE,
            help      = L.CONFIG_DIVGRAPHIC_HELP,
            configKey = TRP3NBK_Frame.Config.ENABLE_DIVIDER,
        },
        { inherit = "TRP3_ConfigNote", title = " " },
        { inherit = "TRP3_ConfigH1",   title = L.CONFIG_FIELDS_TITLE },
        {
            inherit   = "TRP3_ConfigCheck",
            title     = L.CONFIG_SHOW_REASON_TITLE,
            help      = L.CONFIG_SHOW_REASON_HELP:format(L.NO_REASON),
            configKey = TRP3NBK_Frame.Config.SHOW_REASON,
        },
        {
            inherit   = "TRP3_ConfigCheck",
            title     = L.CONFIG_SHOW_NOTES_TITLE,
            help      = L.CONFIG_SHOW_NOTES_HELP,
            configKey = TRP3NBK_Frame.Config.SHOW_NOTES,
        },
        {
            inherit   = "TRP3_ConfigCheck",
            title     = L.CONFIG_SHOW_ZONE_TITLE,
            help      = L.CONFIG_SHOW_ZONE_HELP,
            configKey = TRP3NBK_Frame.Config.SHOW_ZONE,
        },
        {
            inherit   = "TRP3_ConfigCheck",
            title     = L.CONFIG_SHOW_ENC_TITLE,
            help      = L.CONFIG_SHOW_ENC_HELP,
            configKey = TRP3NBK_Frame.Config.SHOW_ENCOUNTERS,
        },
        {
            inherit   = "TRP3_ConfigCheck",
            title     = L.CONFIG_SHOW_MUTE_TITLE,
            help      = L.CONFIG_SHOW_MUTE_HELP,
            configKey = TRP3NBK_Frame.Config.SHOW_MUTE,
        },
        {
            inherit   = "TRP3_ConfigCheck",
            title     = L.CONFIG_SHOW_PIN_TITLE,
            help      = L.CONFIG_SHOW_PIN_HELP,
            configKey = TRP3NBK_Frame.Config.SHOW_PIN,
        },
        {
            inherit   = "TRP3_ConfigCheck",
            title     = L.CONFIG_SHOW_REMEMBER_TITLE,
            help      = L.CONFIG_SHOW_REMEMBER_HELP,
            configKey = TRP3NBK_Frame.Config.SHOW_REMEMBER,
        },
    }

    TRP3_API.configuration.registerConfigurationPage({
        id       = "trp3_nbk_config",
        menuText = L.NBK_FULL,
        pageText = L.ADDON_NAME,
        elements = TRP3NBK_Frame.ConfigElements,
    })

end

TRP3_API.module.registerModule({
    name         = L.ADDON_NAME,
    description  = L.ADDON_DESC,
    version      = (C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version") or ""):gsub("v", ""),
    id           = "trp3_nbk_tooltips",
    onStart      = TRP3NBK_Frame.Init,
    requiredDeps = { { "NerzorsBlacklistKeeper", "external" }, { "trp3_tooltips", 1.0 } },
    minVersion   = 130,
})

function TRP3NBK_Frame:OpenConfig()
    TRP3_API.navigation.openMainFrame()
    TRP3_API.navigation.page.setPage("trp3_nbk_config")
    TRP3_API.navigation.page.setPage("trp3_nbk_config")
end

-- "/trp3 nbktrp3" and "/nbktrp3" open the config page.
TRP3NBK_Frame.OpenConfigCommand = {
    id       = "nbktrp3",
    helpLine = " " .. L.ADCOM_HELP,
    handler  = function() TRP3NBK_Frame:OpenConfig() end,
}
TRP3_API.slash.registerCommand(TRP3NBK_Frame.OpenConfigCommand)

SLASH_NBKTRP31 = "/nbktrp3"
SlashCmdList["NBKTRP3"] = function()
    TRP3NBK_Frame:OpenConfig()
end
