Just like the Demo Version of UPV2 this was made by Defaultplayer001, with assistance from Han of Revision (He just told me exactly what to do, thanks Han!)

This changes the render restart under video options to relaunch with as a first time setup, which lets you customize audio options as well, and otherwise doesn't differ functionally from the regular video configuration

The value is in MenuChoice_RenderDevice.uc, found it by opening deusex.u on notepad++ and just searching for the "changevideo" value you mentioned, just had to change -changevideo to -firstrun and it works as wanted!

Default readme below:

A patch released in 2010, to address the remaining bugs & various issues still present in the game. However it never really took off, with Y|yukichigai present on other things he instead opted to slowly work on Shifter releases and his bigger projects.

Okay, so years ago (several) I suggested that perhaps we as a community of skilled coders should put together some kind of "v2.0 patch" for Deus Ex to address all of the remaining bugs and shortcomings in the game. The idea seemed to garner a certain amount of enthusiasm but nothing ever came of it, in part I think because we were all busy on our own projects. Now that hasn't changed for all of us, but I finally got off my duff and started doing something. Actually, I'm doing it. Right now, as I type this, my other monitor is filled with the text of Mission02.uc. Yay geeky.

Anyway, I'd like to re-propose that we as a community get together and make a v2.0 patch. I'm thinking we could do this pretty easily through Google Code (SVN for the win) and with the combined efforts of the talent I know is available here we could probably get it done in a matter of weeks if we really wanted. Who's interested?

CURRENT LIST (+ = fixed, - = not fixed, / = partially fixed, ? = should we do anything?):

text code:
+ Castle Clinton Slaughter check tags JC as a murderer too easily
+ MJ12 Confiscate grenade count glitch
+ Ghost Laser Sight in the MJ12 capture sequence
+ Modified Bot alliance in MJ12 lab is reset by breaking a window
+ Datacube falls out of the MJ12 lab level
+ Belt isn't cleared prior to being sent to the MJ12 lab
+ Able to drop items just before they are confiscated at the MJ12 lab
+ Various fixes to keep Paul alive and present until the 'Ton raid
+ Going out the window even when Paul has been saved makes Paul dead
+ Ford Shick doesn't show up in later missions after you've rescued him
+ Statue secret entrance to the lab in Maggie's flat doesn't move in GOTY
+ MJ12 troops in the secret lab play audio barks, making it not very secret
+ Hopping out of the Triad compound makes Gordon Quick try to kill you
+ You can kill Bob Page in the lab under Versalife
+ Entering the code twice for the UC lab destruct stops a bunch of the hazards
+ Final Hell's Kitchen visit has no music (GOTY only)
+ Ray the Odd Mechanic isn't neutral
+ No MissionScript or startup text for the Vandenberg tunnels
+ Hologram of Bob Page at X-51 can be startled into running with a grenade
+ Things shot over water never properly die
+ Changing weapons relies on inefficient Unreal Tournament SwitchWeapon command
+ Ford Shick tries to give you an Aug Upgrade with the wrong object name
+ Buttons do not light obviously enough (bUnlit is not used)
+ Couch texture switch doesn't work
+ Invincible NPCs will drop their weapons sometimes
+ Weapon info screen doesn't display bonuses in Recoil or Reload time due to skill
+ Sometimes there will be two JoJo Fines in the 'Ton
+ Game can only process 16 resolutions at a time, starting with the lowest
+ No upper limit on the amount of skillpoints you can have, which can cause a crash
+ Some Mission Scripts require the exact name "Unconscious" to count properly
+ Pistol Downgrade trick
+ Targeting aug uses BindName for display instead of Familiar/Unfamiliar Name
+ Phones ring while playing "this phone doesn't work" noises
+ Phones still ring when ringFreq variable is set to zero
+ Phones do not properly support the variable which determines their ring sound
+ Crossbow doesn't play the proper firing sound
+ Targeting aug uses itemName for weapons/etc. instead of display name
+ bTriggerOnceOnly doesn't work right for triggers (various infinite skillpoint loops)
+ Aggressive Defense can "detonate" throwing knives, darts, and flamethrower fire
+ Being captured by UNATCO while using a charged item causes glitches
+ Silenced Assault Rifle doesn't make enough silenced shots
+ Carried items are forcibly thrown at the start of a conversation (e.g. TNT to Gunther's face)

/ "Hack/Pick/Multitool then pause" exploit
/ Various NPCs are friendly instead of neutral (Lebedev, etc.)

- "Inventory Received" window doesn't combine two instances of the same item
- Friendly bots at Vandenberg will kill the X-51 scientists if they're hit with friendly fire
- Conversation system doesn't support transfers from non-DeusEx classes
- Cloaking is not nullified when you are on fire
- Non-explosive projectiles don't break glass
- Checking bodies for inventory can lead to an infinite loop, or somehow derail to your/another NPC's inventory
- Logspam when NPCs weilding GEP Guns try to lock on to you
- Various instances of logspam due to shoddy DX code
- Shooting on the main dock before Alex's message makes Paul hate you
- Paul can hate you during the 'Ton raid
- Throwing knife "ammo" has no icon for the items received window

? Paul can be tricked into using lethal weapons against the NSF
? Ammo you haven't picked up is displayed in the weapon info screen
? Bullet tracers move very slow
? Overlap inventory exploit
? Patrol and teleport MissionScript functions do nothing
? Unarmed NPCs can plow through obstacles (A.K.A. "Nicolette the Tank")
? "Inventory Received" window doesn't show proper counts for ammo given
? NPCs magically stop burning when they die
? Bullet spread is weird and inconsistent
? No price and product display on Vending Machines
? NPCs know your exact position when you are cloaked
? Extra Soda/Candy textures are not used
? Conversations with animal speakers attempt to invoke nonexistant animations
? There are two additional unused sounds for Rats
? Paul's answering machine (and the message it comes with) is not in the game
? Unused VOIP conversation between Lebedev and the unknown party
? Ammo pickup amounts from frobbed corpses is always 1-4, instead of based on the default pickup ammount
? OMG I CANT GET ON TEH BOTE
? Throwing Knives suck
? Spawned AugmentationCannisters (using the summon cheat) have no augs in them
? Unconscious NPC description doesn't include the name
? Manderley's Safe is walled up
? Hazmat suit doesn't protect against fire/electricity/etc. (description says it does)

Finally, I have a few ideas for things to go into the patch which may straddle the line between "bugfix" and "changing the game". A good example would be the message you're supposed to hear on Paul's answering machine during your first visit to the 'Ton: should it be added back into the game? Would that disrupt the "established" Deus Ex experience too much? (Ditto for the later unused conversation between Lebedev and someone else) There are going to be some difficult decisions to make, and input would be appreciated.

Offtopicproductions.com

UPDATEx2: PLEASE, WEIGH IN ON THE "MAYBE" (marked with a ?) ITEMS IN THE BUG LIST. These are things which could be considered design flaws or design choices, depending. I really want community input on these things, lest I inadvertently turn this into a "lite" version of Shifter.

UPDATE: I've established a Google Code account for this project under the name "deusexv2". The project homepage is Code.google.com. You can retrieve the source code via your favorite SVN client (I recommend Tortoise SVN). If you want to contribute via the project, message or email me with an email address so I can add you to the project. (If you aren't one of the TNM folks or someone I know well you should get someone to vouch for you though)