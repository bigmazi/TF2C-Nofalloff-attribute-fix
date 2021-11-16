# TF2C Nofalloff attribute fix
Replicates no-falloff attribute for RPG and Hunting Revolver

No-damage-falloff-over-distance attribute is broken since 2.0.2: it gets applied onto all the weapons the player has, not just the one it's intended to be applied onto.
It means that SMG and shotgun don't lose damage past 512 hu whenever equipped together with Hunting Revolver and RPG respectively.
Applying "provide on active" isn't a solution in either of cases: this way RPG could lose no-falloff property if soldier holds shotgun/shovel the moment of explosion; sniper with Hunting Revolver, on the other hand, would lose +25hp whenever switched away from primary.

Proposed solution: enable attached items_game.txt (the only difference is that no-falloff attribute is disabled), and install the attached sourcemod plugin.

All the plugin does is replicating the attribute for RPG and Hunting Revolver.

"items_game" file  must be mounted through "custom" subfolder.
**Clients don't need to have this version of file**, it needs to be modified only server-side.
Server must be restarted for global items_game to be reloaded.
