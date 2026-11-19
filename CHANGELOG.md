# Changelog

All notable changes to **Total RP 3: NerzorsBlacklistKeeper Tooltip Support** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.1] - 2026-11-19

### Added
- New: players on NBK’s Remember Me list show up with their star rating, notes, zone and Mythic+ run (the blacklist always wins). There’s a checkbox for it on your config page.
- Add Local for new "Remember Me"

### Fixed
- BLACKLIST_CHANGED only hides the tooltip now, Hide + Show re-ran OnShow and added the NBK lines twice.
- An entry without a reason no longer errors
- The loading Hooks has been fixed, previously an error would occur in the background of the tooltip, or it would not display correctly.

### Change
- Secret names are skipped, and a pcall around the render keeps an error from breaking TRP3’s tooltip.

## [1.1.0] - 2026-11-16

### Added
- bump toc (retail: 12.1.7)

### Fixed
- players who are blacklisted, this was not displayed in the tooltip in Forever.
- Issues resulting from changes in the stable release version of NBK 2.x have been fixed.

### Change
- The built-in reasons from NBK were always displayed in English, now they are shown in the respective language.

## [1.0.8] - 2026-10-18

### Added
- we add Locals for Italian, Portuguese, Spanish and French. Thanks Community.
	- Italian (Italy) localization by d3nn!s_novum
	- Portuguese (Brazil) localization by d3nn!s_novum
	- Spanish (Latin America) localization by d3nn!s_novum
	- French (French) localization by Sanoca - marécage-de-zangar.
- for Russian i use Translator, If anything has been translated incorrectly, please report it! Simply edit `locale/locale.ruRU.lua` and submit a PR or open an [issue](https://github.com/Nerzors/tRP3_NBK/issues).

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

[Unreleased]: https://github.com/Nerzors/tRP3_NBK/compare/1.1.1...HEAD
[1.0.8]: https://github.com/Nerzors/tRP3_NBK/compare/1.0.0...1.1.1
[1.0.0]: https://github.com/Nerzors/tRP3_NBK/releases/tag/1.0.0
