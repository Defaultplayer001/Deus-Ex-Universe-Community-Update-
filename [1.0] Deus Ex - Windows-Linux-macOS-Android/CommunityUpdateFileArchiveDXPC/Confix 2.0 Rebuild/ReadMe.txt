Confix 2.0 Rebuild is a rebuild of Confix based off the original, done so that fixes could be recorded into macros.
This allows automated translation of updates to the logic! Text still needs to be done seperately per language.

Confix is a mod targeting to fix and optionally expand conversations in Deus Ex. Such fixes include things as big as broken logic preventing access to dialogue and gameplay to the more benign typo fixes. 
Expansions include features that are hinted-at in the lore - for instance, if Louis Pan stole something money from the newsstand, why isn't it added to his inventory and you aren't able to steal it from him when you kill him? 
It may seem very specific, but the intent here is to make the conversations more whole.

If you wish to expand on Confix, you should know that it was made using ConEdit, the conversation editing tool for Deus Ex (uploaded here as well). 
The language it uses resembles assembler - After a line will play it will immediately load the next line, ad infinitum or until reaching an end event.
It can check and do simple ALU functions on a very specific number of variables. The most common tools are flag sets (setting a variable), flag checks (branch), and jumps.
The naming convention of the audio files is very strict, and generally ignores the filenames stated explicitly by ConEdit - rather it's always ActorName_LineNumber.
The pathing is strict as well, but can be figured out by auto-generating the filenames. Compiling the files after they're all in order is done through UCC, and for more knowledge about that you should consult the Deus Ex SDK.

-shortened/edited by Defaultplayer001 from Dalvik/maiden_china's original Confix post : http://www.moddb.com/mods/confix/news/what-is-confix

Confix 2.0 Rebuild changelog:
Note: Old crediting was too vague, credit new changes *individually*!

Audio files (Audio files taken directly from original Confix):
BOGIE:			Converted all audio to mono


Mission1:
			AnnaNavarre.AnnaBarks - Typo fix ("wating" => "waiting")
HAWK:			AnnaNavarre.AnnaBarks - Check for MeetCarter_Played before M02Briefing_Played (originally mislabled as being a change to MeetAnna.)
			GuntherHermann.GuntherAttackingBarks - Typo fix ("nanoaugmentation" => "nano-augmentation")

DEFAULTPLAYER001:	GuntherHermann.GuntherRescued - ConvoTrapCheck

Original Confix changelog below.

Changelog :

Audio files:
BOGIE:			Converted all audio to mono

General:
			Triggers and flag sets are moved to be earlier in conversations and infolinks, so they will be activated regardless and to promote fluidity
			All mentions of "J. C. Denton" are changed to "JC Denton"
			Made ellipses formatting uniform -- most were either missing a space after them, or had 4 dots instead of 3
			All Comments removed to prevent any possible issues with DEED (Deus Ex Extract and Decompile)
			Added Demo detection for Unofficial Patch V3(Now unused thanks to Han's help with DeusEx.u)
AIBarks:
			Added GuntherHermannPissed class, to replace GuntherHermann after Anna has died (AnnaNavarre_Dead == true)
BOGIE:			Added MJ12Elite class
			Added MJ12TroopInSewer class, to replace MJ12Troop before being exposed to the MJ12 (prior to Mission 5)
			Added MJ12TroopInSewerB class, to replace MJ12TroopB before being exposed to the MJ12 (prior to Mission 5)
			Added TriadLumPathPeace class, to replace TriadLumPath after peace has been established (TriadCeremony_Played == true)
			Added UNATCOTroopEnemy class, to replace UNATCOTroop after you've defected to the NSF (NSFSignalSent == true, or Mission 5 and beyond [latter is prefered])
			Added UNATCOTroopEnemyB class, to replace UNATCOTroopB after you've defected to the NSF (NSFSignalSent == true, or Mission 5 and beyond [latter is prefered])
			MJ12Troop.MJ12Troop_BarkGore - Restored the A4 bark (was misplaced under UNATCOTroop)
			MJ12Troop.MJ12Troop_BarkSearchGiveUp - Restored the A5 bark (was misplaced under UNATCOTroop)
			MJ12TroopB.MJ12TroopB_BarkGore - Restored the A4 bark (was misplaced under UNATCOTroopB)
			MJ12TroopB.MJ12TroopB_BarkSearchGiveUp - Restored the A5 bark (was misplaced under UNATCOTroopB)
			SamCarter.SamCarter_BarkFutz - Typo fix ("assinine" => "asinine")

HK_Shared:
			AlexJacobson.M06MeetAlexJacobson - Typo fix ("witchhunt" => "witch hunt")
HAWK:			Base_Guard.Base_Guard_MiddleBarks + Base_Guard.Base_Guard_FinalBarks - Paul and Jaime are mentioned at the right time (with certain GMDX exclusivity checks)
			Brawl_Red_Arrow.Brawl_Red_ArrowBarks - Typo fix ("guailo" => "gwailo")
			Canal_Cop.Canal_CopBarks - Dialogue mismatch fix ("back" => "by")
			ClubBartender.ClubBartenderConvos - Typo fix ("deathwish" => "death wish")
			MarketBum.MarketBumBarks - Typo fix (removed rogue apostrophe)
			MarketHKMilitary.MarketHKMilitaryBarks - Will play the triad unison barks based on the proper flag ("TriadCeremony_Played")
BOGIE:			MarketKid.KidStealsSomething + MarketKid.KidSetsFire - Whenever Louis Pan steals credits, they will be added to his inventory
			ChenBeforeCeremony - Restored unused barks (A3, A4)
HAWK:			MJ12Lab_BioWeapons.MJ12Lab_BioWeapons_Overheard - MJ12Lab_Assistant_BioWeapons had wrong actor name
BOGIE:			TeaHouseRedArrow.CatererConvo - Caterer (cop ingame) will be added credits when bribed
			(too many to count) - Typo fix ("Versalife" => "VersaLife")

Mission0_Infolink:
			Many small typos fix (most obvious one - "breech" => "breach")

Mission1:
			AnnaNavarre.AnnaBarks - Typo fix ("wating" => "waiting")
HAWK:			AnnaNavarre.MeetAnna - Check for MeetCarter_Played before M02Briefing_Played
			GuntherHermann.GuntherAttackingBarks - Typo fix ("nanoaugmentation" => "nano-augmentation")
DEFAULTPLAYER001:	GuntherHermann.GuntherRescued - Added support for giving Gunther a weapon of your choosing
			JaimeReyes.MeetJaime - Typo fix ("Versalife" => "VersaLife")
			JosephManderley.M02Briefing - Typo fix ("embarasses" => "embarrasses")
HAWK:			PaulDenton.MeetPaul - Added a NoRoom response
			PaulDenton.MeetPaul - Typo fix (2 occurrences of "nonlethal" => "non-lethal")
			TechSergeantKaplan.MeetKaplan - Edited and restored sharp-shooter line
			TechSergeantKaplan.MeetKaplanStart - Will play in proximity, removing proximity detection for all other instances of the main conversation
			TechSergeantKaplan.MeetKaplan - When buying darts while hated, he doesn't say his ammo response line - instead, he replies with "Don't forget to read them their rights".
			TerroristCommander.TerroristStatueBarks - Typo fix ("seccessionism" => "secessionism")
HAWK:			Trooper2.Trooper2Barks - Checks if A1 has played in order for A4 to play

Mission1_Infolink:
			JCDenton.DL_FrontEntranceBot - Will play even after the statue (case is handled in vanilla), so the player will know he can use EMP grenades on bots
			JCDenton.DL_libertyruinsairshaft - "millenial" => "millennial"
			JCDenton.DL_StartGame - Added a check for GMDX, sets flag *Enhancement_Detected*

Mission2:
			AnnaNavarre.AnnaDock - Will not initiate that conversation if you already found the Ambrosia
HAWK:			AnnaNavarre.AnnaThanks - Sets a flag that will persist across missions, *AnnaAppreciatesPlayer*
BJORN:			ClinicMaleBum1.ClinicMaleBum1Overhead + ClinicMaleBum2.ClinicMaleBum2Squalnomie + ClinicMaleBum2.ClinicMaleBum2Military - Fix flags and logic
			Doctor2.Doctor2Barter - Typo fix (added missing period)
BJORN:			GilbertRenton.MeetRenton - Fix typo ("unintended" => "unattended")
			GilbertRenton.RentonRescued - Set the ToldRentonAboutSandra flag at the appropriate time
			GilbertRenton.RentonRescuedBarks - Typo fix ("Why's" => "Why'd")
			Janey.JaneyThankful - Logic fix, will be able to react to Sandra's state even if she died before she reached the bar
DEFAULTPLAYER001:	Jock.MeetJock - Warm beer bug fix
			JoeGreen.MeetJoeGreen - Typo fix ("Joe Green" => "Joe Greene")
HAWK:			Pimp.MeetPimp - Right amount of credits is taken (200)
			Sally.MeetSally2 - Added missing punctuation
DEFAULTPLAYER001:	SandraRenton.SandraInBar - Will set the flag for Smuggler's password
			SmugglerDoorBell.SmugglerDoorBellConvo - Can try "Underworld" as the password if you found it out (only once)
BOGIE:			SubHostageMale.SubHostageMaleRescuedBarks - Will choose a bark based on the map he's in
			UNATCOGrenade1.UNATCOGrenade1Meet - Will give you 3 gas grenades when talking to them a second time, instead of 8
			Worker.ReconciledBarks - Fix dialogue mismatch ("Crummy part of town." => "What IS this stuff, heavy water?")

Mission2_Infolink:
			JCDenton.DL_Alleys - Typo fix ("LAM's" => "LAMs")
			JCDenton.DL_WaterTreatment - Typo fix ("para miltary" => "paramilitary")

Mission3:
HAWK:			AnnaNavarre.AnnaEntrance - Sets a flag that will persist across missions, *Anna747Dialogue*
			GuntherHermann.M03GuntherBarks - Typo fix ("mistake" => "mistakes")
DEFAULTPLAYER001:	HarleyFilben.M03MeetFilben - Can buy the code from him regardless if you know the Underworld password
HAWK:			JuanLebedev.MeetLebedev2 - Sets a flag that will persist across missions, *PlayerHeardAboutParents*
DEFAULTPLAYER001:	JugHead.M03MeetJugHead - Added limiting factors to getting more LAMs from him
			Lenny.MeetLenny - Added the ability to get the LAM if you didn't have room at first
			NSFCrate1.CrateNSFOverheard - Added handling to the NSF being alerted to your presence (talked to the leader)
			TechBum.M03TechBumBarks - Dialogue mismatch fix (missing "to")
			Veteran.VeteranConvos - Buying 2 boxes of ammo will give you 2 boxes ammo

Mission4:
			AnnaNavarre.AnnaBadMama + GuntherHermann.GuntherShowdown - Removed TalkedToPaulAfterMessage prequisite, allowing the player to progress even if they sequence break. Implemented it as an internal flag set to ensure Paul dies during sequence breaks.
			GilbertRenton.InterruptFamilySquabble - You can give Renton most of the firearms, removed the ability to give him the knife due to dialogue conflict
			JaimeReyes.JaimeOverheard - Added 2 new flags, *WaltonOvercharges* and *WaltonStopsOvercharging*
			JoJoFine.JoJoAloneBarks - Typo fix ("things" => "thinks")
			PaulDenton.M04PaulWaiting - Dialogue mismatch fix ("half-dozen" => "half a dozen")
			PaulDenton.PaulInjured - Removed Paul telling you Smuggler's password because he gives you the wrong directions to Smuggler's, and because it blocks off a future dialogue line with StantonDowd
HAWK:			PaulDenton.PaulInjured2 - Changed a deprecated flag check to a new flag, *PlayerHeardAboutParents*
			PaulDenton.PaulAfterBadMama + PaulDuringAttack + PaulAfterAttack - Barks will play in that order during the raid, allowing Paul to be pessimstic at first, then optimistic, then plan for the future
			SamCarter.M04MeetCarter - Added missing punctuation
			SmugglerDoorBell.SmugglerDoorBellConvo - Can try "Underworld" as the password if you found it out (only once)
			TrooperTalking1.M04TroopersOverheard - Typo fix ("Nietzche" => "Nietzsche")
			UNATCOTroop.M04TroopBarks - Changed a deprecated flag check to a new flag, *Anna747Dialogue*

Mission4_Infolink:
			JCDenton.DL_PaulGoodJob - Fixed the signal trasmission quest, forces proper dish alignment to end it

Mission5:
HAWK:			AlexJacobson.M05MeetAlexJacobson - Fix some logic, allowing access to all of Alex's lines
BOGIE + KAFZIEL:	Miguel.MeetMiguel + Miguel.ChangeMiguel - GMDX EXCLUSIVE - Added the ability to arm Miguel
			ScientistConsulting.ScientistConsultingBarks - Typo fix ("JCDenton" => "JC Denton")
			Sven.SvenConvos - Added missing End event, preventing the convo from entering an infinite loop draining you of your money and giving you a lot of 7.62 ammo
			Sven.SvenConvos - Typo fix ("762" => "7.62")

Mission5_Infolink:
			JCDenton.DL_Choice - Typo fix ("floorplan" => "floor plan")

Mission8:
HAWK:			ClinicBum1.ClinicBum1Barks - Typo fix ("whose" => "who's")
			FordSchick.M08MeetFordSchick - Fix transfered item name to a proper one ("AugmentationUpgrade" => "AugmentationUpgradeCannister"), added NoRoom handling
			JoeGreen.M08MeetJoeGreen - Typo fix ("Joe Green" => "Joe Greene")
			JordanShea.M08JordanSheaConvos - Implemented a NoRoom response
			SmugglerDoorBell.SmugglerDoorBellConvo - Can try "Underworld" as the password if you found it out (only once)
			Smuggler.M08SmugglerConvos - Will reward you the first time you buy explosives, not only if you bought a GEP Gun
DEFAULTPLAYER001:	StantonDowd.StantonDowd - Dialogue mismatch fix (Original Text: "The only way to make sure it's destroyed will be to scuttle the ship" Audio: "Audio "The only way -- cough -- to, the only way to make sure it's destroyed will be to scuttle the ship")

Mission9:
			Gatekeeper.GatekeeperBarks - Typo fix ("cemetary" => "cemetery")
HAWK:			Jock.M09JockLeave - Wrong flag checked, logic fix
			Mechanic1.Mechanic1Barks - Typo fix (added missing space)
			CafWorker2.CafWorker2Barks - Fix multiple small dialogue mismatches
HAWK:			StantonDowd.M09MeetStantonDowd - Dialogue mismatch fix ("near" => "at")

Mission10:
			Agathe.AgatheInterrupted + Joshua.JoshuaInterrupted - Allow the conversation to be started only once, no matter which actor is the starting point
			Bums.BumsConvos - Added missing flag set when you buy darts, so the player won't be able to buy infinite darts
			Bums.BumsConvos - Dialogue mismatch fix ("these" => "those")
			Chad.ChadThankful - Typo fix ("be be" => "be")
HAWK:			Jean.JeanConvos - Improper jump fix (would jump to KristiConvos instead of JeanConvos because of cut-and-paste script)
			Kareena.KareenaBarks - Typo fix ("litte" => "little")
			Nicolette.NicoletteOutside - Typo fix ("siezing" => "seizing")
			Renault.RenaultPays - Split the parts with Guy to Renault.RenaultGuyHack, so the conversation can start without Guy nearby

Mission10_Infolink:
			JCDenton.DL_entered_chateau - Typos fix ("floorplan" => "floor plan")
			JCDenton.DL_tunnels_oldplace - Added missing apostrophe
			JDenton.DL_tunnels_rearentry - Typo fix ("seige" => "siege")
			(too many to count) - Typo fix ("Duclare" => "DuClare")

Mission11:
			AIPrototype.MeetAI2 - Typo fix ("succint" => "succinct")
			M11WaltonButton.M11WaltonHolo - Changed the camera from wide to zoomed in, to prevent it clipping through the wall
			M11WaltonButton.M11WaltonHolo - Typo fix ("tuneup" => "tune-up")
HAWK:			MetroTechnician.MetroTechnicianConvos - Will only mention Toby Atanwe after he's spawned
			MorganEverett - Redid the convo tree logic for more streamlined flag checks and less unintuitive redirections (now there's only 1 EverettBarks instead of 6)
HAWK:			MorganEverett.MeetEverett + MorganEverett.MeetEverett2 - Proper transition when from mentioning DeBeers to killing the mechanic
			MorganEverett.MeetEverett - Dialogue mismatch fix (add missing "the")
			MorganEverett.MeetEverett2 - Dialogue mismatch fix ("never even been" => "never been")
			TobyAtanwe.AtanweAtEveretts - Dialogue mismatch fix (he never says the part about the neuro-paralytic)

Mission11_Infolink:
			JCDenton.DL_chapel - Dialogue mismatch and typo fix ("I once knelt in this chapel for communion" => "Once I knelt in this chapel for Communion")

Mission12:
			GarySavage.GaryComputerBriefing - Typo fix ("Milnet" => "MILNET")
			LuciusDeBeers.MeetLuciusDeBeers - Typo fix (removed rogue dash)
			Mechanic_comm_1.Mechanic_comm_1Barks + Mechanic_comm_2.Mechanic_comm_2Barks + TonyMares.MeetTonyMares + Jock.TongSick - Added case handling for not destroying the bots in Vandenberg prior to entering the comm building
			MiBChatting.M12MiBOverheard - Added GMDX variation, to allow for custom NPC pathing when the conversation is done
HAWK:			"StephanieMaxwell.StephanieMaxwellOverheard" => "MJ12ToughGuy.StephanieMaxwellOverheard" - Fix activation and changed owner to prevent bugginess, added variations for MJ12Elite (GMDX only)
HAWK:			TiffanyMiB.TiffanyGuardsOverheard - Transfered from Mission14 to Mission12
			TiffanySavage.MeetTiffanySavage - COMMENTED OUT - Added the option of giving Tiffany a thermoptic camo to help her escape
			TiffanySavage.MeetTiffanySavage + Jock.M12JockFinal2 - Moved the goal completion to Jock's conversation, allowing it to be completed even when the mission has failed (Tiffany has died)

Mission12_Infolink:
			JCDenton.DL_command_bots_destroyed - Added case handling for not destroying the bots in Vandenberg prior to entering the comm building
			JCDenton.DL_Daedalus - Typo fix ("Milnet" => "MILNET")
			JCDenton.DL_JockLeaving - Typo fix ("Milnet" => "MILNET")
			JCDenton.DL_HeliosBorn - Typo fix (removed rogue apostrophe)

Mission14:
HAWK:			CardPlayer1.ChattingGuards - Removed sueprfluous space, added variations for MJ12Elite (GMDX only)
			DrBrittanyPrinzler.BrittanyBarks2 - Dialogue mismatch fix ("You" => "You'd")
HAWK:			DrCorwell.MeetDrCorwell - Check for the proper flag ("TankKharkian_Dead" => "TankKarkian_Dead"), also check for the wrong flag name for legacy support
BJORN:			GarySavage.GaryWaitingForSchematics - Infinite skillpoints bug fix
HAWK:			TiffanyMiB.TiffanyGuardsOverheard - Transfered from Mission14 to Mission12
			WaltonSimons.WaltonShowdown - Add 2 BioelectricCells to WaltonSimons based on *WaltonOvercharges* and *WaltonStopsOvercharging*
			WaltonSimons.WaltonShowdown - Typo fix ("breakroom" => "break room")

Mission15:
HAWK:			MorganEverett.M15MeetEverett - Bypass him mentioning Toby Atanwe if he's dead
HAWK:			ScaredSoldier.MeetScaredSoldier - Typo fix ("then" => "than")
			TracerTong.M15MeetTong - Dialogue mismatch fixes ("its" => "his", "electronic" => "electronics")
			WaltonSimons.WaltonBadass - Add 2 BioelectricCells to WaltonSimons based on *WaltonOvercharges* and *WaltonStopsOvercharging*

Mission15_Infolink:
HAWK:			JCDenton.DL_Final_Helios03_5 - Dialogue mismatch fix ("Yes, you" => "You")
			JCDenton.DL_Morgan_Missed_Convo - Added a note ("Crew-complex security code: 8946.")
HAWK:			JCDenton.DL_Final_Page02 + JCDenton.DL_elevator - Check for health instead of credits when mocking the player, revamped logic, allows checking health of up to 150
			JCDenton.DL_Final_Page02 - Typo fix ("then" => "than")
			JCDenton.DL_tong1 - Dialogue mismatch fix (remove "deep underground")

NYC_Clinic_Shared:
			Doctor1.Doctor1Barter - Typo fix (added missing period)

NYC_Smuggler_Shared:
			FordSchick.MeetFordSchickRescue - Removed proximity trigger due to small room making it incredibly annoying to maneuver around him