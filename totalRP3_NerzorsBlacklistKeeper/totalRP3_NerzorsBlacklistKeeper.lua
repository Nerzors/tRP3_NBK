--[[
============================================================
Total RP 3: Nerzors Blacklist Keeper Tooltip Support
https://github.com/Nerzors/tRP3_NBK
============================================================

Requires both Total RP 3 and NerzorsBlacklistKeeper.
  https://github.com/Total-RP/Total-RP-3
  https://github.com/Nerzors/NerzorsBlacklistKeeper

============================================================
]]--
local ADDON_NAME, L = ...;

local TRP3NBK_Frame = CreateFrame("Frame")
TRP3NBK_Frame:RegisterEvent("PLAYER_LOGIN")

TRP3NBK_Frame.LoadedStuff = false
TRP3NBK_Frame.DividerGraphic = CreateSimpleTextureMarkup(
    "interface\\friendsframe\\ui-friendsframe-onlinedivider", 320, 4)

local BRAND_HEX_PURPLE = "9b59b6"
local RED_HEX          = "ff6666"
local DIM_HEX          = "888c99"
local MUTE_HEX         = "ff9955"

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

-- t.target is "Name-Realm" (or just "Name" on the player's own realm).
-- strsplit returns nil for missing parts, which is exactly what
-- LibNBKApi expects for "use the player's current realm". | note Veplo
local function splitTarget(target)
    if not target or target == "" then return nil end
    local name, realm = strsplit("-", target, 2)
    if realm == "" then realm = nil end
    return name, realm
end

function TRP3NBK_Frame.Init()

    TRP3NBK_Frame.Config = {
        HIDE_NBK_TOOLTIPS_IC = "trp3_nbk_hide_tooltips_ic",
        ENABLE_DIVIDER       = "trp3_nbk_enable_divider",
        SHOW_REASON          = "trp3_nbk_show_reason",
        SHOW_NOTES           = "trp3_nbk_show_notes",
        SHOW_ZONE            = "trp3_nbk_show_zone",
        SHOW_ENCOUNTERS      = "trp3_nbk_show_encounters",
        SHOW_MUTE            = "trp3_nbk_show_mute",
        SHOW_PIN             = "trp3_nbk_show_pin",
    }

    TRP3_API.configuration.registerConfigKey(TRP3NBK_Frame.Config.HIDE_NBK_TOOLTIPS_IC, false)
    TRP3_API.configuration.registerConfigKey(TRP3NBK_Frame.Config.ENABLE_DIVIDER,       false)
    TRP3_API.configuration.registerConfigKey(TRP3NBK_Frame.Config.SHOW_REASON,          true)
    TRP3_API.configuration.registerConfigKey(TRP3NBK_Frame.Config.SHOW_NOTES,           true)
    TRP3_API.configuration.registerConfigKey(TRP3NBK_Frame.Config.SHOW_ZONE,            true)
    TRP3_API.configuration.registerConfigKey(TRP3NBK_Frame.Config.SHOW_ENCOUNTERS,      true)
    TRP3_API.configuration.registerConfigKey(TRP3NBK_Frame.Config.SHOW_MUTE,            true)
    TRP3_API.configuration.registerConfigKey(TRP3NBK_Frame.Config.SHOW_PIN,             true)

    local function cfg(key) return TRP3_API.configuration.getValue(key) end

    local function getApi()
        return LibStub and LibStub("LibNBKApi-1.0", true) or nil
    end

    local function renderTooltip(t)
        local api = getApi()
        if not api then return end

        local name, realm = splitTarget(t.target)
        if not name then return end

        if TRP3_API.dashboard and TRP3_API.dashboard.isPlayerIC
           and TRP3_API.dashboard.isPlayerIC()
           and cfg(TRP3NBK_Frame.Config.HIDE_NBK_TOOLTIPS_IC) then
            return
        end

        if not api:IsBlacklisted(name, realm) then return end
        local entry = api:GetBlacklistEntry(name, realm)
        if not entry then return end

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

        if cfg(TRP3NBK_Frame.Config.ENABLE_DIVIDER) then
            TRP3_CharacterTooltip:AddLine(" ")
            TRP3_CharacterTooltip:AddLine(TRP3NBK_Frame.DividerGraphic)
        else
            TRP3_CharacterTooltip:AddLine(" ")
        end

        local header = color(BRAND_HEX_PURPLE, L.NBK) .. " "
                     .. color(RED_HEX,        L.BLACKLISTED)
        TRP3_CharacterTooltip:AddDoubleLine(
            header,
            color(DIM_HEX, formatDate(entry.addedAt)),
            titleColor.r, titleColor.g, titleColor.b,
            mainColor.r,  mainColor.g,  mainColor.b)

        if cfg(TRP3NBK_Frame.Config.SHOW_REASON) then
            local reason = entry.reason
            if not reason or reason == "" then
                reason = color(DIM_HEX, L.NO_REASON)
            end
            TRP3_CharacterTooltip:AddLine(
                color(DIM_HEX, L.REASON .. ":") .. " " .. reason,
                mainColor.r, mainColor.g, mainColor.b, true)
        end

        if cfg(TRP3NBK_Frame.Config.SHOW_NOTES) and entry.notes and entry.notes ~= "" then
            TRP3_CharacterTooltip:AddLine(
                color(DIM_HEX, L.NOTES .. ":") .. " " .. entry.notes,
                mainColor.r, mainColor.g, mainColor.b, true)
        end

        if cfg(TRP3NBK_Frame.Config.SHOW_ZONE) and entry.zone and entry.zone ~= "" then
            TRP3_CharacterTooltip:AddLine(
                color(DIM_HEX, L.ADDED_IN .. ":") .. " " .. entry.zone,
                mainColor.r, mainColor.g, mainColor.b, true)
        end

        if cfg(TRP3NBK_Frame.Config.SHOW_ENCOUNTERS) then
            local count = entry.encounterCount or 0
            if count > 0 then
                local lastTxt = entry.lastSeen and formatDate(entry.lastSeen) or "-"
                TRP3_CharacterTooltip:AddLine(
                    color(DIM_HEX, L.ENCOUNTERS .. ":") .. " "
                    .. ("%d "):format(count)
                    .. color(DIM_HEX, "(" .. L.LAST_SEEN:format(lastTxt) .. ")"),
                    mainColor.r, mainColor.g, mainColor.b, false)
            end
        end

        if cfg(TRP3NBK_Frame.Config.SHOW_MUTE) and entry.mute ~= false then
            TRP3_CharacterTooltip:AddLine(color(MUTE_HEX, L.CHAT_MUTED), 1, 0.6, 0.33, false)
        end

        if cfg(TRP3NBK_Frame.Config.SHOW_PIN) and entry.pinned then
            TRP3_CharacterTooltip:AddLine(color(DIM_HEX, L.PINNED), 0.7, 0.7, 0.8, false)
        end

        TRP3_CharacterTooltip:Show()
    end

    TRP3NBK_Frame:SetScript("OnEvent", function(self, event)
        if event == "PLAYER_LOGIN" and not TRP3NBK_Frame.LoadedStuff then
            TRP3NBK_Frame.LoadedStuff = true

            if TRP3_CharacterTooltip then
                hooksecurefunc(TRP3_CharacterTooltip, "AddDoubleLine", function()
                    TRP3NBK_Frame.FixFonts()
                end)

                TRP3_CharacterTooltip:HookScript("OnShow", function(t)
                    renderTooltip(t)
                end)
            end

            local api = getApi()
            if api and api.RegisterCallback then
                api:RegisterCallback("BLACKLIST_CHANGED", function()
                    if TRP3_CharacterTooltip and TRP3_CharacterTooltip:IsShown() then
                        TRP3_CharacterTooltip:Hide()
                        TRP3_CharacterTooltip:Show()
                    end
                end)
            end
        end
    end)

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
                DEFAULT_CHAT_FRAME.editBox:SetText("/nbk config")
                ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
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
    version      = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version"):gsub("v", ""),
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

TRP3NBK_Frame.OpenConfigCommand = {
    id       = "nbktrp3",
    helpLine = " " .. L.ADCOM_HELP,
    handler  = function() TRP3NBK_Frame:OpenConfig() end,
}

TRP3_API.slash.registerCommand(TRP3NBK_Frame.OpenConfigCommand)
