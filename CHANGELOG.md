# Changelog

All notable changes to **Total RP 3: NerzorsBlacklistKeeper Tooltip Support** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-07-01

### Added
- Initial public release.
- Total RP 3 module that renders NerzorsBlacklistKeeper info inside the TRP3 character tooltip.
- Tooltip fields (all individually toggle-able):
  - Header line with brand + *Blacklisted* + date the entry was added.
  - **Reason** | falls back to *"no reason logged"* when the field is empty.
  - **Notes** | free-form notes attached to the entry.
  - **Zone (Added in)** | the zone you were in when you blacklisted the player.
  - **Encounter History** | how many times you've crossed paths since and when last.
  - **Chat-Muted Flag** | shown when the mute flag is set.
  - **Pinned Flag** | shown when the entry is pinned.
- Main settings:
  - **IC / OOC gate** | show blacklist info always, or only when out-of-character.
  - **Divider graphic** | optional separator between TRP3's lore section and the NBK block.
- Font-size fix so dynamically added lines match TRP3's own tooltip typography.
- Config page under **Total RP 3 → Modules → Nerzors Blacklist Keeper**.
- Slash command `/nbktrp3` to jump straight to the config page.
- Localized in English (`enUS`) and German (`deDE`) with a metatable fallback for other locales.
- Client support: Retail, Classic Mists of Pandaria, Classic Era.

[Unreleased]: https://github.com/Nerzors/tRP3_NBK/compare/1.0.0...HEAD
[1.0.0]: https://github.com/Nerzors/tRP3_NBK/releases/tag/1.0.0
