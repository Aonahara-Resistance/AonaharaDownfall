# Geography

Source: the Figma board, Blocking phase only. Surface Aonahara. The board carries its own
disclaimer, "SCALE IS NOT FINAL WE FUCKED UP SRY", so treat all sizes as placeholder.

Of the four phases the Figma Guide lays out (Blocking, Detailing, Keys and Doors, Loots),
only Blocking was ever done, and only for the surface. Chapter 1's actual gameplay happens
in the QA basement, which is not mapped anywhere.

## Surface layout

```
              Shrine 3            north is more mountainous
                 |
  Train interior |     Miracle Shrine area
  Station -----> |     "unsure on the size, might be too CHUNGUS"
                 |
  Plains?        |     Central area           lumber mill?         Foresty bit
  Shrine 2       |     inn + marketplace      east is forest       Shrine 1
                 |     economic center        "or TRES"
                 |
                 |     housing | entertainment / red light district
                 |
              Shrine 4 + entrance to aonadome        south = beach
```

## Areas

| Area | Notes |
|---|---|
| Station, far west | Train interior is a separate small box. The built demo level titles itself "Desolated Station", so this is the one area that exists in game |
| Plains, west | Marked with a question mark. Shrine 2 sits here |
| Miracle Shrine, centre north | Emuwaa's place of stay and first encounter in the Notion Characters DB. `story.md` sends Nom to find her in "some Rocky area", and she is a rock mage. Three sources agree |
| Central area | Inn plus marketplace, economic centre. This is Jason's Inn, and his spec has the shop expanding into an inn then declining as Aonahara stagnates |
| Housing and red light district | South of centre, two blocks, "sectioned off areas of the town" |
| Lumber mill and forest, east | Tentative. Shrine 1 sits in the forest |
| Mountains, north | Shrine 3 |
| Beach, south | "Mandatory beach episode". Shrine 4, plus the entrance to the aonadome |

## Shrines and blessings

The counts line up, which is probably not a coincidence.

**Six shrines.** Miracle plus the four numbered ones on the surface, plus the Comet Shrine,
which `story.md` places inside the QA dome rather than up here.

**Six blessings.** Comet, Devil, Angel, Wife and Dog in the Notion enum, plus
`Miracle blessing:` which sits as a bare header with nothing after it at the top of the
character spec doc.

**And the loading tips say** blessings are acquired by liberating deity shrines.

So the working hypothesis: Miracle Shrine grants Miracle, Comet Shrine grants Comet, and the
four numbered shrines on this map are the Devil, Angel, Wife and Dog shrines.

Two things support it. Nom's blessing is Comet, and the Comet Shrine is the first one she
reaches in Chapter 1. And Side Stories lists the Third Shrine and Fourth Shrine as
region-locked until later, matching them sitting on the periphery here.

This reframes CONSOLIDATION.md decision 3. Wife and Dog having no defined effect is not two
orphan enum values, it is two shrines on this map whose reward was never written. Designing
a shrine and its blessing together is a more tractable prompt than inventing a buff alone.

In code, only `comet_blessing` and `devil_blessing` exist under `common/blessings/`.

## Conflicts and gaps

- `story.md` has Nom arriving at a station "near the coastal area". This map puts the
  station west and the beach south
- Notion's Level Design listed nine areas. This map covers Aonahara surface and the inn.
  Missing: QA Basement, Great Archive, Basement Garden, Sus House, TH Basement, ED Basement,
  Aonohana
- The aonadome entrance is in the south by the beach and Shrine 4. `story.md` does not say
  where Nom and Emuwaa enter the underwater section, so this is the only source for it
- Codecks has four Comet Shrine cards (boss fight, layouts, theme, tilesheet), all not
  started. Nothing exists for any surface shrine
