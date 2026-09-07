# Pick up here

Written 2026-09-07, ~03:30, end of day one of the revival.

## Before you touch anything

**Do not open the Godot editor until the indent setting is changed.** Today the editor
rewrote `scenes/splash_screen/splash_screen.gd` from 2-space to tabs, mixed them, and threw
`Parse Error: Mixed tabs and spaces`. It was reverted, but it will happen again to whatever
file the editor touches. Editor Settings, Text Editor, Indent, Type = Spaces, Size = 2.

**There is uncommitted work in the tree.** Six modified files plus two untracked
(`swing.wav`, `swing.wav.import`), and the whole of `docs/` staged. If the editor mangles
indentation on top of that, separating the two is miserable. Commit or stash first.

## 1. Review and commit

- `git diff --cached` for the docs, `git diff` for the combat work
- `swing.wav` and `swing.wav.import` are untracked and both are required. Without the
  `.import`, Godot cannot load the audio and `nom_nom.tscn` fails to parse
- `docs-backup` tag still points at the three original doc commits if you want them back

## 2. Indentation, going with 2 spaces

- Editor setting as above, per device. Godot 3 has no project-level override
- Repo is currently 47 files spaces, 29 tabs, 2 genuinely mixed
  (`common/collisions/weapon_hitbox.gd`, `ui/cheat_panel/cheat_panel.gd`)
- The `format` target in the Makefile runs `gdformat`, which is **not installed** and
  enforces **tabs**. Going with spaces means dropping it, or pinning gdtoolkit 4.x which
  supports `--use-spaces=2`
- Normalise after merging `melee-rework`, not before, or the conflict will be ugly

## 3. Runtime bugs

Known, in rough priority:

- `character.gd:265` returns null from `equiped_weapon()` with a live `# TDOO` and no guard.
  Callers at 141, 155, 185-191 dereference it. Latent crash
- `death_restart_button_pressed` is connected in a scene on main but only declared on
  `melee-rework`. The death screen restart button is wired to nothing. **Merging the branch
  fixes it**
- `scenes/warp/` level changing exists but is unreliable
- Two Noms spawn in the demo level, probably a signal firing twice in the start scene
- Opening cutscene cannot be skipped, hardcoded in `scenes/opening/`
- Nine open bug cards in Codecks, plus the coin sound one you already fixed and can close

## 4. Rescope

Your framing from tonight: cards double as "do I want this" and as work items, archive to
scrap, edit the description to revise. The alternative you floated is working backwards from
how the story beats play out and deriving features from that. Worth trying the second on
Chapter 1's opening, since `story.md` already has the beats written.

`docs/SYSTEMS.md` holds the 44-row verdict table. Still unresolved from it:

- Blessings full set. Only Comet and Devil exist in code. Wife and Dog have no defined
  effect anywhere. **This is a writing decision, not a code task**, and it blocks every
  character past Nom and Emuwaa
- Class vocabulary. Drive uses Melee / Ranged / Ranger / Mage / Magic across one document
- Monster naming has two layers that do not map to each other
- Is `story.md` pre- or post-rescope. Google Docs exports carry no timestamps, so read the
  modified date off Drive's file list

## 5. The melee-rework branch

4 commits, 45 files, +507/-285, last touched 2024-05-23, which is **four months newer than
main**. Contains `physics_fps` 240 to 165 (your refresh rate fight) and the
`death_restart_button_pressed` signal that main is missing.

It also touches `cum_stained_sword.gd`, `cum_stained_sword.tscn` and `character.gd`, which
are exactly the files tonight's combat work changed. **Conflicts are certain.**

Suggested order: commit tonight's work to a branch so it is safe, merge `melee-rework` into
main, then rebase tonight's branch onto it. Do the indentation normalisation after all of
that, never between.

Five other branches (`refactor`, `demo`, `level`, `character`, `party`) are 0 commits ahead
of main and safe to delete. `rc/1` and the `PS-*` branches are yours to ignore.

## 6. Emuwaa is boring next to Nom

She is the "before" state. Nom got interesting because of **commitment**: give up mobility,
gain rhythm and escalation. Emuwaa has no commitment at all.

- Her staff already has `chargable_light` and `holdable_light` with `light_charge` and
  `light_attack` animations. The mechanism exists and is not leaned on. Tap stays mobile and
  weak, hold plants her, release is worth planting for. Same grammar as Nom, inverted curve
- Her shards already pierce. Reward enemies lined up and positioning becomes skill
- Recoil on the heavy pushes her back. Mirror of Nom's lunge, gives her a movement tool
- Golden Shower and BDSM are both zoning skills. Her identity is area denial and her basic
  attack does not support that fantasy yet
- **Reference: the same game you studied tonight.** You said most of its cast is ranged and
  you went frame by frame through the melee one. Do that pass on a ranged character

## Party roles and why you switch

Do not homogenise the cast. If everyone is a mobile lunging character, the party switch is
just a shared health bar. Emuwaa should not feel like Nom, she should feel like the answer
to a different problem.

The role chart already exists in the character specs, written 2022-2023:

| Character | HP | Role as specced |
|---|---|---|
| Nom Nom | 4, highest | Bruiser. Melee, eats projectiles for charge, has to close |
| Emuwaa | 2 | Glass zoner. 20 damage, highest. Rain and meteor are area denial |
| Nitsuppi | 3 | Tank. Shield and sword, and the spec says only Nitsu can use the shield |
| Nothing | 3 | Support. Boombox gives party heal, party damage, party attack speed |
| Lightbulbe | 2 | Control. Flamethrower, plus a freeze that stacks damage for release |
| Khanh | 3 | Summoner. Handgun plus helper entities |

Roles are not the missing piece. The **interaction layer** is: why you switch, and what
carries across the switch. Three levers, cheapest first.

- **Switch as a combat verb.** If switching cancels the outgoing character's recovery, the
  switch becomes a mechanic instead of a menu. Nom commits to a swing, switch mid-recovery,
  Emuwaa arrives already zoning. Commitment stops being pure downside and the party system
  earns its existence. The `Dynamic Party` card in Codecks is probably already reaching for
  this
- **Coverage.** A bullet-dense room favours Nom, who converts projectiles into charge. A
  crowded room favours Emuwaa. The switch becomes a read on the situation rather than a
  cooldown
- **Handoff.** Lightbulbe's freeze already stacks damage for release. That is setup and
  payoff designed across two characters, years ago

Blessings are a second differentiation axis already designed and only half built. Comet and
Devil exist in code, Angel is specced, Wife and Dog are named with no defined effect.

## Combat feel, remaining and all code, no art needed

- **Hitstop.** Roughly 10 lines next to `singletons/shake.gd`. Two to four frames of
  near-zero `time_scale` on connect. Biggest single impact left
- **Stagger.** No enemy has a `hurt` state. All three state machines are
  idle / patrol / chase / retreat / attack / die, so a hit has nothing to interrupt
- **`knockback_strength = 0`**, hardcoded in `_ready` of both `weapon_hitbox.gd` and
  `hitbox.gd`. Everything downstream works, enemies default to `receives_knockback = true`.
  Make it an export
- Body animation for the swing. The tilt added tonight is a stand-in. The real version is
  a state in the existing `AnimationTree`, started from `_swing()`. The weapon's
  `AnimationPlayer` stays independent
- The `slash` effect animation on `EffectAnimation` is fully authored and **never played**.
  `sword.gd` declares `effect` and never calls it. Free VFX, 0.4s so it needs retiming

## Tuning dials added tonight

All exported on the sword, all adjustable in the inspector.

| Dial | Default | What it does |
|---|---|---|
| `commit_time` | 0.18 | Uncancelable window. **Lower this first if planting still bothers you** |
| `combo_reset_time` | 0.6 | How long the chain remembers |
| `lunge_strength` | 260 | Thrust finisher distance |
| `swing_lunge_strength` | 150 | Hits 1 and 2 |
| `body_tilt_degrees` | 8.0 | Body English on the swing |
| `rest_return_time` | 0.16 | Ease back to guard when the combo is not continued |

Lunge distance scales with the square of strength against the 1400/s decay, so 150 to 200
is roughly 8px to 14px, not a linear step.

## Loose ends not worth doing yet

- Discord was never pulled. Nothing depends on it
- Figma holds the map, never reviewed
- Codecks import CSVs are sitting in `exported/`, never imported. 13 system cards, 3 bug
  cards, plus one card to archive by hand (`After Demo Release Refactor`)
- Godot tries to import those CSVs as translation files and errors. A `.gdignore` file in
  `exported/` stops it. Engine only, nothing to do with git
