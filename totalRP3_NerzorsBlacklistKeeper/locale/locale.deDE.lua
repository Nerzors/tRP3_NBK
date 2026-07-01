local _, L = ...;
if GetLocale() ~= "deDE" then return end

L.ADDON_NAME       = "NerzorsBlacklistKeeper Tooltip-Unterstützung"
L.ADDON_DESC       = "Erlaubt Total RP 3, NerzorsBlacklistKeeper-Informationen im Tooltip anzuzeigen."
L.NBK              = "NBK"
L.NBK_FULL         = "Nerzors Blacklist Keeper"

L.ADCOM_HELP       = "Öffnet die Tooltip-Konfiguration für NerzorsBlacklistKeeper."

L.BLACKLISTED      = "Auf der Blacklist"
L.REASON           = "Grund"
L.NOTES            = "Notizen"
L.ADDED_IN         = "Hinzugefügt in"
L.ENCOUNTERS       = "Begegnungen"
L.LAST_SEEN        = "zuletzt %s"
L.CHAT_MUTED       = "Chat stummgeschaltet"
L.PINNED           = "Angeheftet"
L.NO_REASON        = "kein Grund hinterlegt"

L.CONFIG_TITLE          = "NerzorsBlacklistKeeper-Optionen öffnen"
L.CONFIG_TITLE_HELP     = "Öffnet das ingame Optionen-Panel des NerzorsBlacklistKeeper-Addons."
L.CONFIG_TITLE_TEXT     = "NBK-Optionen öffnen"

L.CONFIG_MAINSETTINGS_TITLE = "Haupteinstellungen"

L.CONFIG_SHOWNBK_TITLE  = "NBK-Info im TRP3-Tooltip anzeigen"
L.CONFIG_SHOWNBK_HELP   = "Legt fest, ob NBK-Infos angezeigt werden, wenn du IC oder OOC bist."

L.DROPDOWN_IC_OOC       = "IC und OOC"
L.DROPDOWN_OOC_ONLY     = "Nur wenn OOC"

L.CONFIG_DIVGRAPHIC_TITLE = "Trenngrafik über den NBK-Infos einblenden"
L.CONFIG_DIVGRAPHIC_HELP  = "Wenn aktiviert, wird eine Trenngrafik eingefügt, die den TRP3-Tooltip-Inhalt von den NBK-Infos trennt."

L.CONFIG_FIELDS_TITLE       = "Tooltip-Felder"
L.CONFIG_SHOW_REASON_TITLE  = "Grund anzeigen"
L.CONFIG_SHOW_REASON_HELP   = "Zeigt den Grund, warum der Spieler auf die Blacklist gesetzt wurde (Fallback: '%s' wenn leer)."
L.CONFIG_SHOW_NOTES_TITLE   = "Notizen anzeigen"
L.CONFIG_SHOW_NOTES_HELP    = "Zeigt die zum Blacklist-Eintrag hinterlegten Notizen an."
L.CONFIG_SHOW_ZONE_TITLE    = "Zone anzeigen (Hinzugefügt in)"
L.CONFIG_SHOW_ZONE_HELP     = "Zeigt die Zone an, in der der Spieler auf die Blacklist kam."
L.CONFIG_SHOW_ENC_TITLE     = "Begegnungs-Historie anzeigen"
L.CONFIG_SHOW_ENC_HELP      = "Zeigt, wie oft du dem Spieler erneut begegnet bist und wann zuletzt."
L.CONFIG_SHOW_MUTE_TITLE    = "Chat-Stumm-Markierung anzeigen"
L.CONFIG_SHOW_MUTE_HELP     = "Zeigt eine Zeile 'Chat stummgeschaltet', wenn das Mute-Flag gesetzt ist."
L.CONFIG_SHOW_PIN_TITLE     = "Anheft-Markierung anzeigen"
L.CONFIG_SHOW_PIN_HELP      = "Zeigt eine Zeile 'Angeheftet', wenn der Eintrag angeheftet ist."
