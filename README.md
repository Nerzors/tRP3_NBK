<div align="center">
<img src="https://media.nerzors.de/addons/nbk/nbkAddon_tRP3.final-v1.png" alt="Nerzors Blacklist Keeper Logo with Total RP3 Tooltip"/>

<h1>Total RP 3: Nerzors Blacklist Keeper Tooltip Support</h1>

<p><i>See the players you blacklisted right inside Total RP 3's tooltip - without leaving the roleplay flow.</i></p>

<p>
  <a href="https://www.curseforge.com/wow/addons/trp3-nbk-tooltip">
    <img src="https://img.shields.io/badge/CurseForge-1B1F2B?style=for-the-badge&logo=curseforge&logoColor=e04e14&labelColor=1B1F2B" alt="CurseForge"/>
  </a>
  <a href="https://www.curseforge.com/wow/addons/trp3-nbk-tooltip">
    <img src="https://img.shields.io/badge/WoWUp-1B1F2B?style=for-the-badge&logoColor=A87CE8&labelColor=1B1F2B" alt="WoWUp"/>
  </a>
  <a href="https://addons.wago.io/addons/trp3-nbk">
    <img src="https://img.shields.io/badge/Wago.io-1B1F2B?style=for-the-badge&logoColor=A87CE8&labelColor=1B1F2B" alt="Wago.io"/>
  </a>
</p>

<p>
  <img src="https://cf.way2muchnoise.eu/1593811.svg?gameVersionTypeId=517" alt="CurseForge Downloads"/>
  <img src="https://img.shields.io/github/v/release/Nerzors/tRP3_NBK?style=flat-square&color=252669&labelColor=1B1F2B" alt="Latest Release"/>
  <img src="https://img.shields.io/github/last-commit/Nerzors/tRP3_NBK?style=flat-square&color=A87CE8&labelColor=1B1F2B" alt="Last Commit"/>
  <img src="https://img.shields.io/github/issues/Nerzors/tRP3_NBK?style=flat-square&color=252669&labelColor=1B1F2B" alt="Open Issues"/>
  <img src="https://img.shields.io/github/stars/Nerzors/tRP3_NBK?style=flat-square&color=A87CE8&labelColor=1B1F2B" alt="Stars"/>
</p>

</div>

<br/>

## About

This addon bridges **NerzorsBlacklistKeeper** and **Total RP 3**.
When you mouse over a roleplay character that you have blacklisted, the blacklist information - reason, notes, the zone you met them in, encounter history, and more.
appears directly inside the TRP3 character tooltip instead of the default Blizzard one.

<br/>

## Requirements

| Addon | Minimum | Source |
|------|---------|--------|
| **Total RP 3** | latest | [GitHub](https://github.com/Total-RP/Total-RP-3) · [CurseForge](https://www.curseforge.com/wow/addons/total-rp-3) |
| **NerzorsBlacklistKeeper** | latest | [GitHub](https://github.com/Nerzors/NerzorsBlacklistKeeper) · see below for CurseForge / Wago links |

Supported clients: **Retail · Classic Mists of Pandaria · Classic Era**.

<br/>

## Installation

### Via addon manager (recommended)

Install from any of:

- [CurseForge](https://www.curseforge.com/wow/addons/trp3-nbk-tooltip)
- [Wago.io](https://addons.wago.io/addons/trp3-nbk)
- [WoWUp](https://www.curseforge.com/wow/addons/trp3-nbk-tooltip) (uses CurseForge feed or WagoIO)

Make sure both Total RP 3 and NerzorsBlacklistKeeper are installed and enabled. this addon is inert without them.

### Manual

1. Download the latest release zip from the page above (or from [GitHub Releases](https://github.com/Nerzors/tRP3_NBK/releases))
2. Extract the `totalRP3_NerzorsBlacklistKeeper` folder into `World of Warcraft\_retail_\Interface\AddOns\` (or `_classic_\...` / `_classic_era_\...`)
3. Restart WoW or `/reload`

<br/>

## Configuration

Open the config page with `/nbktrp3`, or via the **Total RP 3** menu → **Modules** → **Nerzors Blacklist Keeper**.

### Main Settings

| Setting | Default | What it does |
|---------|---------|--------------|
| **Show NBK Info on TRP3 Tooltip** | *When IC and OOC* | Choose whether the blacklist section also appears while you're in-character, or only when out-of-character. |
| **Add Divider Graphic above NBK Info** | Off | Inserts a thin divider line between TRP3's lore section and the NBK block, for a cleaner visual separation. |

### Tooltip Fields

Each row of the blacklist block can be toggled independently. Default for all of them is **On**.

| Field | What it shows | Source |
|-------|--------------|--------|
| **Reason** | The reason you blacklisted the player (or *"no reason logged"* when empty) | `entry.reason` |
| **Notes** | Free-form notes attached to the entry | `entry.notes` |
| **Zone (Added in)** | The zone you were in when you blacklisted them | `entry.zone` |
| **Encounter History** | How many times you've crossed paths since, and when last | `entry.encounterCount` + `entry.lastSeen` |
| **Chat-Muted Flag** | A *"Chat muted"* line when the mute flag is set | `entry.mute` |
| **Pinned Flag** | A *"Pinned"* line when the entry is pinned | `entry.pinned` |

The header row (brand · *"Blacklisted"* · date) is always shown when the player is on your list - turning off every field still leaves the header in place so you never silently lose the signal.

<br/>

## Slash Commands

| Command | Effect |
|---------|--------|
| `/nbktrp3` | Open the TRP3 NBK Tooltip Support config page |

The main NerzorsBlacklistKeeper addon's `/nbk` commands (add, remove, list, check...) are unchanged -> see its [documentation](https://github.com/Nerzors/NerzorsBlacklistKeeper) for those.

<br/>

## Localization

| Locale | Status |
|--------|--------|
| English (`enUS`) | Full |
| Deutsch (`deDE`) | Full |
| Other locales | Fall back to English via metatable |

Translations are very welcome - open a PR against `locale/locale.<locale>.lua`.

<br/>

## Addon Core Information

| Property | Value |
|----------|-------|
| Author | Veplo |
| Co-Author | Nerzors |
| Language | Multi-Language |
| Game Versions | WoW Retail · Classic MoP · Classic Era |
| Current Version | `1.0.1` |

<br/>

## Where to find NerzorsBlacklistKeeper

**CurseForge**

- Retail (12.0.7) - All-in-One: <https://www.curseforge.com/wow/addons/nerzorsblacklistkeeper>
- Retail (12.0.7), Classic Era (1.15.8), Classic MoP (5.5.4) - Core Only: <https://www.curseforge.com/wow/addons/nerzorsblacklistkeepercore>

**Wago.io**

- Retail (12.0.7) - Core Only: <https://addons.wago.io/addons/nerzorsblacklistkeeper-core-only>
- Retail (12.0.7) - All-in-One: <https://addons.wago.io/addons/nerzorsblacklistkeeper>
- Classic Era (1.15.8) / Classic MoP (5.5.4) - Classic Core Only: <https://addons.wago.io/addons/nerzorsblacklistkeeper-classic>

**GitHub**

- <https://github.com/Nerzors/NerzorsBlacklistKeeper>

<br/>

## Issues & Support

Found a bug, want a feature, or have a translation to contribute? Open an issue on the [GitHub repository](https://github.com/Nerzors/tRP3_NBK/issues).

For bugs *inside* NerzorsBlacklistKeeper itself (e.g. an entry not registering), please use the [NerzorsBlacklistKeeper issue tracker](https://github.com/Nerzors/NerzorsBlacklistKeeper/issues) instead. this addon is only the TRP3 bridge.

<div align="center">
<sub>Created with ♥️ by Veplo (Discord: Veplo) | because someone has to remember who pulled without asking.</sub>
</div>

