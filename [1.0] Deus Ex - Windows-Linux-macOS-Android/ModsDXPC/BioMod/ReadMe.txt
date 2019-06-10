========================================
             BioMod Beta 8
         Based on Shifter 1.8.3
========================================

Author: Michael Justice ('Lork' on most forums)
Shifter's Author: Y|yukichigai
Promotional graphics: donhonk
WP Grenade Textures: KillHour

BioMod is an extension of Y|yukichigai's excellent Shifter mod for Deus Ex.  While I still think Shifter is a definite improvement over the original game,  I sometimes felt while playing it that it was too conservative for my tastes.  Eventually I decided to make my own mod which would contain some radical changes that might give some people pause, but would hopefully breathe new life into the game for everyone else.

As the name suggests, BioMod is primarily concerned with Deus Ex's augmentations, with the aim of making them more balanced, but also a lot easier to manage.  Most augs are now automated, using energy only when they're actually doing their jobs.  Some augs that were less useful or that would be a pain to manage have been made free or given extra abilities, while those that I thought were un-salvageable have been replaced with entirely new augs.  

In addition to the augmentation system, BioMod also makes some general gameplay changes, such as the addition of pickpocketing, an autosave feature, and a Thief style ledge grabbing system.


========================================
              About Shifter
========================================

Shifter, If you're not familiar with it, is a popular gameplay modification for Deus Ex, which the author describes as an attempt at "removing the suck" from Deux Ex (what little there is).  BioMod uses Shifter's code as a base, so any changes are made in addition to or in place of the ones made by it.  I highly recommend that you go over Shifter's readme, which I have provided with this file.  It will get you up to speed about any changes you might notice that aren't mentioned in this readme.    

========================================
       Installation Instructions
========================================

1. Make sure you have the v1112fm patch installed (GOTY has it already)
2. In your .\DeusEx\System\ folder, make a backup of DeusEx.u and DeusEx.int
3. Unzip the contents of this archive into your Deus Ex folder, overwriting when prompted
4. Rebind your jump key in the control settings menu if you want to make use of the mantling feature

If everything worked correctly you should see the current version of Shifter and BioMod at the bottom of the main menu.


========================================
             Augmentations
========================================

Augmentations now fall into three categories based on the way they use energy

Active: Uses energy constantly while turned on.  This is what all of the augmentations in the original game were like.
Automatic: When turned on, goes into an "idle" state which uses no energy.  When idle, will automatically activate when needed and drain energy while it works.
Passive: Uses no energy.

All augmentations, including passive ones can be toggled on and off at will.  This is so that, for example, if you have microfibral muscle, you can still throw a chair at somebody's head without killing them.

Regeneration
============
Type: Automatic
Cost: 300 Units/Minute while healing
Description: Regeneration now works like the health system in most modern shooters, meaning that there's a delay between when you get hurt and when the healing kicks in.  If you want instant healing you'll have to use a medkit.

Aqualung
========
Type: Passive
Description: Aqualung now actually restores some of your energy when you're in water, in addition to letting you breathe.

Energy Shield
=============
Type: Automatic
Cost: 50% of damage from energy attacks
Description: Energy shield can now be left on indefinitely, because it only uses energy when protecting you from damage.

Power Recirculator
==================
Type: Passive
Description: Power recirculator is now passive.

Environmental Resistance
========================
Type: Automatic
Cost: 40% of damage from toxins
Description: Environmental resistance can now be left on indefinitely, because it only uses energy when protecting you from hazards.

Spy Drone
=========
Type: Active
Cost: 100 Units/Minute
Description: In addition to increasing the speed and reducing the energy drain, I've added a few abilities to make the spy drone better at, well, spying.  You can now use the drone to gather intel from datacubes, trigger buttons and switches, and even hack computers without exposing yourself to danger.  On the other hand, the EMP attack has an energy cost, making the spy drone less overpowered (but still useful) as a guided EMP grenade.

Aggressive Defense System
=========================
Type: Automatic
Cost: 15 Units/Projectile
Description: Aggressive defense now only drains energy when it's actually protecting you, so you can leave it on indefinitely.

Ballistic Protection
====================
Type: Automatic
Cost: 50% of damage from projectiles and bladed weapons
Description: Balistic protection can now be left on indefinitely, because it only uses energy when protecting you from damage.  Be careful though, as it can drain your energy very quickly if you find yourself getting riddled with bullets.

Radar Transparency
==================
Type: Active
Cost: 200 Units/Minute
Description: In order to reflect its usefulness relative to cloak, radar transparency's cost has been reduced by 100 units/Minute

EMP Shield
==========
Type: Passive
Description: Rather than making you spend energy to save energy, EMP Shield is now a passive reduction to EMP damage

Electrostatic Discharge
=======================
Type: Passive
Description: Similar to its counterpart in Invisible War, electrostatic discharge (added by Shifter) has been made passive

Microfibral Muscle
==================
Type: Passive
Description: Similar to its counterpart in Invisible War, microfibral muscle has been made passive

Speed Enhancement
=================
Type: Active
Cost: 40 Units/Minute
Description: Speed Enhancement no longer allows you move silently at high speeds.  You can still "crouchrun", but it'll make a racket.

Run Silent
==========
Type: Passive
Description: In addition to being made passive, run silent now reduces sounds made while jumping as well as running, similar to its counterpart in Invisible War

Tracking
========
Type: Automatic
Cost: 10 Units/Dart
Description: Replacing the targeting aug, tracking allows you to fire darts which when attached to a target will display its location on your HUD as well as the data you would get from targeting.

Vision Enhancement
==================
Type: Active
Cost: 40 Units/Minute
Description: The range of the sonar imaging effect of vision enhancement has been doubled, allowing you to see stuff through walls from a reasonable distance.


========================================
            Gameplay Changes
========================================

A "Challenge" system similar to xbox live achievements has been added

The swimming skill has been changed to "athletics" and determines movement speed on land and jumping ability in addition to swimming

An athletics skill of advanced unlocks the ledge Grab/mantling system: Hold the jump key down when next to a ledge and JC will hoist himself over it.  NOTE: YOU MUST REBIND YOUR JUMP KEY IN THE KEYBOARD/MOUSE SETTINGS MENU TO USE THIS FEATURE.

Changed the medicine skill to affect biocells as well as medkits to make it more useful

The demolition skill now determines the amount of grenades you can carry, making it worth upgrading if you care about explosives

Made the GEP gun take longer to lock on to things if your heavy weapons skill is low

Computers no longer make the player invisible when using them.  Now you'll have to beware of nearby enemies, cameras, etc. when hacking.

Removed the targeting reticles when using a scoped weapon unless you're actually looking through the scope.  That should give you something to think about before attempting to use your sniper rifle as a railgun, or slapping a scope on your tricked out superpistol

Added white phosphorus grenades to game using Shifter's NPC random inventory system

Ballistic armor, hazmat suits and rebreathers degrade with use rather than over time, and tech goggles have a much longer duration and can give you heat or sonar vision depending on your skill level.  These changes make the environmental training skill significantly more useful, so the skillpoint cost has been raised to be roughly equal to that of computers.

Pickpocketing system:  Press use on an enemy NPC who is unaware of you, and you'll steal their keys if they have any.

More convenient tools: Press use on an an item that can be unlocked, picked, or bypassed (except for keypads) and you'll automatically equip the appropriate tool.

Autosave feature: Automatically saves every time you change maps.

Unconscious NPCs can now be killed.  Also they dream, and have families who will miss them when you throw them off a building, you monster.

Added the ability to toggle buttons and switches by shooting them, Duke3D style.

Fixed a bug in the mission05 script where it didn't properly disable charged pickups before removing them.

Fixed hazmat suits so they actually do protect against fire, electricity and EMP like their description says they do.

Restored the crossbow's real, previously unused firing sound (in the original game it sounded like a stealth pistol).

Restored "ricochet" sounds that were supposed to play when bullets hit a wall (in the original game they made no sound at all!).

Added bullet impacts on decorations.

Restored "armor ricochet" sound when shooting armored targets.

Added poisoned throwing knives to the high end random inventory list.

Added fire propagation between NPCs.

Gave NPCs the ability to pick up and use fire extinguishers if they need to.

Added pain and death sounds that were previously only used by the player to NPCs.  No more people saying "oof!" when breathing in poison gas.

Made it so that NPCs can be "Stun-locked" by machinegun fire

Increased the amount of time between pain sounds on NPCs, to cut down on the "OOF OOF OOF OOF" factor.

Prevented the player from reloading their weapon when they shouldn't be able to.


========================================
             Bug and Issues
========================================

If you trouble getting BioMod working or notice any other issues, I recommend that you consult the FAQ in Shifter's readme, as it probably holds the solution.  If your problem isn't covered by the FAQ or known issues, send me an email and I'll see about fixing it or helping you out.

I must ask that you do NOT send reports about issues you've experienced in BioMod to Y|yukichigai (the author of Shifter).  The last thing I want to happen is for his email to be flooded with reports about bugs he had nothing to do with.  Unless you're absolutely sure that the problem is with Shifter (that is, you can reproduce it without BioMod), send all bug reports to me.  If the problem does turn out to be with Shifter, I will forward it to Y|yukichigai myself.


Known Issues:

I've made no attempt to maintain compatibility with Deus Ex's multiplayer, so at the very least, your augs will be wonky in MP.  All of the changes were made with singeplayer in mind anyway, so if you want to play MP, you should stick to regular Shifter.  I've actually been toying with the idea of removing multiplayer from the main menu completely and replacing it with something else.

The Nameless Mod is not supported at the moment.

When using the spy drone, the selection box/info when mousing over objects displays in the main screen rather than the drone window.  This is a minor visual issue, and the UI code is strange and terrifying, so don't count on a fix anytime soon.


I've done as much playtesting as I can, but Deus Ex is a massive game and I am only one man, so there are probably more bugs that I haven't run into.  BioMod is considered to be in beta right now, and I won't feel comfortable releasing a "final" version until I've gotten feedback by multiple people who have gone through the entire game with it.  Until then, you can think of yourself as a beta tester of sorts.  Don't worry, it won't bite... hard.


========================================
                Contact
========================================

If you have a bug to report, some criticism, or any other thoughts to share, you can reach me at contact@justicem.com

You can find the latest version of BioMod as well as any other mods I've worked on at www.justicem.com


========================================
                  Notes
========================================

My thought process when making this mod (for those who care):

When playing the original game I really liked the idea of being a nano-augmented super agent in theory, but in practice, turning the augmentations on and off all the time ended up being more trouble than it was worth.  Rather than trying to micro-manage my augs all the time, I (and I think most other players) usually ended up saving them for "emergencies".  The problem is that emergencies in Deus Ex tended to come up without warning and often lead to instant death.  In many situations in which I would've found my augs useful, I was frustratingly dead before I could activate them.  Then upon loading my last save, I would avoid the situation altogether.  Meanwhile, waiting for the need that never arised, my medkit and biocell stockpiles grew to ridiculous sizes.

By making augs easier to manage, I hope to not only remove a lot of hassle from the game, but turn many of those frustrating deaths into exciting, narrow escapes, at the cost of a lot of bioenergy.  Because your augmentations will always be there when you need them, you can worry less about whether you're using your energy efficiently and more about staying alive, and avoiding the situations that would drain your energy in the first place.  

And don't think that all of this turns the game into a cakewalk.  I still ran into plenty of challenging situations during playtesting, and despite all the energy saved by passive and automatic augs, I actually found myself using far more biocells and medkits than I would otherwise.  A consequence of being made to live with my mistakes, rather than always correcting them by loading a save game.


========================================
              Legal Stuff
========================================

Since Y|yukichigai was kind enough to let me make a mod out of his mod, it's only fair for me to extend you the same courtesy.  You can change anything and redistribute this however you want, provided you credit me and follow the rules that Yuki laid out in the first place.  Namely these:

	From the Shifter readme:
	
	" - CAN I USE YOUR MOD AS PART OF MY MOD, OR USE PARTS OF YOUR CODE: Yes,
	as a matter of fact you can.  I'm very much an open-source kind of guy.
	The only requirement I have is that you 1) have a readme, and 2) note in
	it that you used my code as part of your mod.  You don't have to go into
	incredible detail about what specific sections you used or anything, but
	do at least try to mention how much of my code you used."


========================================
               Changelog
========================================

0.8
===
-Added white phosphorus (incendiary) grenades
-Added grenades to Shifter's NPC random inventory
-Using a computer no longer makes you invisible
-Changed swimming to athleticism
-Made the demolition skill affect the amount of grenades the player can carry
-Changed medicine skill so it affects biocells
-Removed targeting reticles when using a scoped weapon unzoomed
-Made it so the player's accuracy resets when scoping/unscoping
-Added an energy cost for detonating the spy drone
-Fixed crossbows counting as guns for the "No Guns" challenge
-Prevented the player from firing tracking darts when they have less energy than it takes to fire them
-Changed the tracking darts to hitscan rather than using an actual dart, which should prevent oddities like robots going crazy and killing you when you target them
-Changed the GEP lockon timer formula to make it take longer at low skill levels
-Reduced the amount of energy that augpower saves to make up for the fact that it's free
-Removed sparks and ricochet sounds from breakable decorations
-Made it so passive and automatic augs are automatically reactivated after turning off synthetic heart
-Anna now fears death
-Found a much better balance for the mantling controls.  It's now responsive and functional, but tapping jump won't send you scampering over the nearest crate
-Added a different sound effect for mantling


0.7
===
-Added challenge system
-Disabled experimental new damage system that I had accidentally left on (oops!)
-Added the ability to toggle buttons and switches by shooting them
-Aggressive defense no longer tracks/detonates planted mines
-Restored aggressive defense's warning sound
-Prevented mantling over a few things that you shouldn't be able to
-Restored "hum" sound for active augmentations
-Reverted the Heartlung aug to synthetic heart
-Aqualung now restores energy rather than draining it

0.6
===
-Greatly improved the way unconscious NPCs are handled
-Added some fire propagation between NPCs
-Gave NPCs the ability to use fire extinguishers
-Added pain sounds that were previously only used by the player to NPCs
-Enabled mantling on non level objects such as crates
-Prevented the player from reloading their weapon when they shouldn't be able to

0.5
===
-Added bullet impacts for decorations
-Restored "Armor ricochet" sound when shooting armored targets
-Prevented pickpocketing of NPCs who can talk to you
-Fixed a bug in the original game that prevented you from being blinded by grenades you didn't own

0.4
===
-Improved the mantling system.  It should feel a lot more natural now
-Removed JC's constipated grunt when jumping.  It's not the 90s anymore, you know?
-NPCs can now be stun-locked
-Increased the amount of time between pain sounds and added some randomness, to cut down on the OOF OOF OOF OOF factor

0.3
===
-Added mantling system
-Made the spy drone set off datalink convos, which should address most of the situations where you could use it to break the game's scripts
-Allowed the spy drone to trigger lightswitches
-Restored the crossbow's previously unused firing sound
-Improved the way the pickpocketing system determines whether an NPC is aware of you
-Gave a certain someone the key to the front door of the building she works in (HINT HINT)
-Halved the durability of ballistic armor
-Fixed jump volume not being reduced by run silent
-Restored "ricochet" sounds
-Added poisoned throwing knives

0.2
===
-First public release (that anyone cares about)