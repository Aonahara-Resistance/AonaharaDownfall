# Enemies

Statblocks from Monster Details. `Type` uses the repo's taxonomy. See CONSOLIDATION.md
decision 5, resolved in the repo's favour: chaser, ranged, turret, dummy.


## Fromb

> Implemented: `entities/enemies/chaser/fromb/`

| Field | Value |
|---|---|
| HP | 500 |
| Type | Chaser |
| Movement Speed | 40 |
| Attack | Explodes near players after a 0.2 second delay. |

**Behavior:** Chases players and explodes to deal damage once it is within range. Due to its big size, it moves very slowly.

## Skacid

> Implemented: `entities/enemies/ranged/skacid/`

| Field | Value |
|---|---|
| HP | 250 |
| Type | Long Range |
| Movement Speed | 70 |
| Attack | Spits acid on players. |
| Bullet | Acid |
| Count | 1 |
| Velocity | 300 |
| Pattern | piss |
| Visual | green acid |

**Behavior:** Spits acid on players to deal damage. If the player is too close to them, they will move away before attacking again.

## Spider Mommy

> Not implemented.

| Field | Value |
|---|---|
| HP | 400 |
| Type | Chaser |
| Movement Speed | 60 |
| Attack | Short range slash attack using their spider body. |

**Behavior:** Spider Mommies chase players whenever they get close and attack using their lower spider body. When they die, they spawn smaller spiders from their own body.

## Spider Baby

> Not implemented.

| Field | Value |
|---|---|
| HP | 150 |
| Type | Chaser |
| Movement Speed | 70 |
| Attack | Short range slash attack using their spider body. |

**Behavior:** Spider Mommies chase players whenever they get close and attack using their lower spider body. When they die, they spawn smaller spiders from their own body.

## White (Cum) Slime

> Not implemented.

| Field | Value |
|---|---|
| HP | 200 |
| Type | Chaser |
| Movement Speed | 60 |
| Attack | Pounce at the player. |

**Behavior:** They will chase players if they get close and pounce on them to attack. They are always seen in groups together with yellow slimes. White slimes explode after they die.

## Yellow (Piss) Slime

> Not implemented.

| Field | Value |
|---|---|
| HP | 150 |
| Type | Long-range |
| Movement Speed | 70 |
| Attack | Shoots yellow liquid (piss) at the player. |
| Bullet | Piss |
| Count | 1 |
| Velocity | 300 |
| Pattern | piss |
| Visual | piss |

**Behavior:** Some of them are seen together with the white slimes. They attack players by spitting yellow liquid (piss) at them. They maintain a certain amount of distance before attacking the player.

## Green (Normal) Slime

> Implemented: `entities/enemies/chaser/green_slime/`

| Field | Value |
|---|---|
| HP | 200 |
| Type | Chaser |
| Movement Speed | 60 |
| Attack | Pounce at the player. |

**Behavior:** They chase players and pounce at them when they get too close.

## Pinthus

> Implemented: `entities/enemies/turret/pinthus/`

*Statblock is empty in the source.*

## Reck-O

> Not implemented.

*Statblock is empty in the source.*

## Geck-O

> Not implemented.

| Field | Value |
|---|---|
| Movement Speed | 75 |
