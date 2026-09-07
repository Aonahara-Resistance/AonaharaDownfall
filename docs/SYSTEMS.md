# Incomplete systems

Every planned-but-unfinished system, gathered from Codecks, the Notion board, the Drive
April Demo and Firing Range lists, the character specs, the story doc, and the loading tips.
Compiled September 2026 for the third rescope.

No scope judgement is applied here. That is the point of the Verdict column.

## Agreed order

1. **Systems.** Finish the mechanical layer.
2. **Boss fight.**
3. **Design iteration for feel**, if needed.
4. **Chapter 1 content.**

## How to use this

Fill the Verdict column: `in`, `out`, or `later`. Once marked, the Codecks deck gets a
subtract pass to match, and only then do new cards get added for whatever is `in` but
uncarded.

## In the live Codecks deck

| System | Card state | On disk | Verdict                                   |
|---|---|---|-------------------------------------------|
| Consumable System + HUD | assigned | nothing | Keep                                      |
| Equipment System + HUD | assigned | nothing | Keep                                      |
| Inventory System + HUD | snoozing | `ui/inventory/inventory.tscn`, no script | ?                                         |
| Hotbar System + UI | assigned | nothing | keep                                      |
| Currency HUD | assigned | `currency_manager.gd` exists, no HUD | keep                                      |
| Item Drop | assigned | `money_drop.gd` only, money not items | keep                                      |
| Leveling | assigned | nothing | keep                                      |
| Minimap | assigned | nothing | keep                                      |
| Hazard | assigned | nothing | keep                                      |
| Interactable | assigned | `common/interactions/interactable.*` exists. Rework, not new | keep (it was rigid)                       |
| Dynamic Party | assigned | `party.gd` and `ui/manage_party/` exist. Extension | keep (probably improvement)               |
| Add owner to projectile | assigned | `objects/projectiles/` exists, lacks owner | this is minor, keep                       |
| After Demo Release Refactor | assigned | your note: "starting to get ugly" | discard, we'll get there when we're there |
| Nom Full Animation | assigned | partial | keep                                      |
| Nom Full Sound | assigned | partial | keep                                      |
| Emuwaa Full Animation | assigned | partial | keep                                      |
| Emuwaa Full Sound | assigned | partial | keep                                      |

Also in the deck as `hero`: Nom Demo Boss Fight, Fromb Design, Emuwaa Cutscene. Those are
step 2 and step 4 work, not systems.

## Planned in older sources, absent from Codecks

Provenance is given so each can be judged on where it came from. Notion describes the
pre-2022 game and may not apply.

| System | Planned in | On disk | Verdict                                                   |
|---|---|---|-----------------------------------------------------------|
| Save and Load | Notion, April Demo | nothing | keep                                                      |
| Checkpoint | Notion | nothing | keep                                                      |
| Scriptable Cutscenes | Notion | `scenes/opening/` is hardcoded | keep                                                      |
| Loading Screen | Notion, and the 48 tips | `addons/game-template/transition/`, 44 of 48 tips hardcoded at `transition.gd:104` | **already shipped**, confirmed |
| Accessory System | Notion, loading tips | nothing | **fold into Equipment System**. Tips treat accessories as a stat slot, not a separate system |
| Character Upgrade | Notion | nothing | Extension of leveling, keep                               |
| Blessing Upgrade | Notion | nothing | keep                                                      |
| Blessings, full set | Notion, character specs | only `comet_blessing` and `devil_blessing` | keep                                                      |
| Deity Soul, weapon enhancement | Notion, loading tips | nothing | keep (end game progression)                               |
| Shrine liberation grants blessings | story doc, loading tips | nothing | keep (serves as exploration)                              |
| Pisstus and Replenish Pisstus | Notion, story doc | nothing | keep, main mechanic                                       |
| Reward System | Notion | nothing | **drop**. Bare 2022 row, no description ever existed. Covered by Item Drop plus shrine loot |
| Side Quest System | Notion | nothing | keep                                                      |
| Character Storyline System | Notion | nothing | keep                                                      |
| Archive Access | Notion | nothing | discard for now, content is too volatile for this feature |
| Interactable Music Player | Notion | tied to Nothing's side story | discard content is too volatime atm                       |
| Snail Murderer Trinket | Notion | nothing. Emuwaa flavour item | discard                                                   |
| Elite and boss enemy tiers | loading tips only | nothing | part of enemy and boss, discard                           |
| Loom limit break unlocks exclusive skill | loading tips only | passives exist, no unlock path | keep                                                      |
| Character info page | loading tips only | nothing | keep                                                      |
| Weapon swap changes light and heavy attacks | loading tips only | `character.gd:261` `equiped_weapon()` dispatches to `sword.gd` / `staff.gd` | **already there**, confirmed |
| Exploration, level changing | April Demo | `scenes/warp/` exists but unreliable | **exists, buggy**. Bug card, not a system |

## Firing range

The tuning rig for step 3. One of the eight original items is ticked.

Built: Enemy Spawner, Buff/Debuff selector (`ui/modifier_selector/`), dummy targets with
damage numbers.

| Item | Verdict |
|---|---|
| Character stat reset (cooldown and hp) | discard for now |
| Race track | discard for now |
| Ground surface tester | discard for now |
| Designated battle test area | discard for now |
| AI confusion zone / AI maze | discard for now |

discard this for now, no specific design we'll need it later either way will naturally be a new task later on
## Open bugs in Codecks

Not systems, but they are real outstanding work and should not be lost in the rescope.

Coin drop sound volume · death does not always switch to a living character · character can
take damage immediately after the other one dies · Nom's Get Excited buff grants immortality
· slime AI · broken melee block · i-frame dash check · melee hitbox does not destroy
destructibles · Emuwaa's hand.

all true probably take priority before appending new codes

## Three things worth knowing before judging

**Interactable and Dynamic Party are not new work.** Both have shipped predecessors in the
repo, so they are reworks and will estimate very differently from the genuinely empty rows.

**The loading tips are the sole source for four systems:** elite and boss tiers, loom limit
break, the character info page, and weapon swap changing attacks. Nothing else documents
them. Dropping `loading-tips.md` drops those design decisions with it.

**The blessing set is where code and design contradict.** Five blessings are named across
the docs, two exist in code, and two of the missing three (Wife, Dog) have no defined effect
anywhere. See CONSOLIDATION.md decision 3. This blocks any character beyond Nom Nom and
Emuwaa.

## Outcome of the rescope pass

Settled September 2026.

**Already shipped, no work needed:** Loading Screen (with 44 of the 48 tips), weapon swap
changing attacks.

**Discarded:** After Demo Release Refactor · Archive Access · Interactable Music Player ·
Snail Murderer Trinket · Elite and boss tiers (folded into boss work) · Reward System ·
all five firing range items.

**Folded:** Accessory System into Equipment System. Character Upgrade into Leveling as its
second half.

**Still parked:** Inventory System and HUD stay `snoozing` in Codecks, unmarked here.

**Added to Codecks:** 13 system cards and 3 bug cards, generated as importable CSVs. Each
carries provenance and dependencies in its body, which the pre-existing cards do not have.

**New bugs found while verifying:** `scenes/warp/` unreliable · `character.gd:265`
dereferences a possibly-null weapon with a live TODO and no guard · three loading tips
missing from `tip_list`, all describing unbuilt systems.
