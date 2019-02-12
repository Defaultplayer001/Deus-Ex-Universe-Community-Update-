//=============================================================================
// CreditsWindow
//=============================================================================
class CreditsWindow extends CreditsScrollWindow;

var Texture CreditsBannerTextures[6];
var Texture TeamPhotoTextures[6];
var Float   creditsEndSoundLength;

// Easter egg processing
var String easterStrings[7];
var String foundStrings[7];
var String easterSearch;
var Int    easterPhraseIndex;
var Float  easterEggTimer;
var int    maxRandomPhrases;
var bool   bShowEasterPhrases;
var int    phraseCount;
var int    phraseIndex;

// Easter Egg Sounds
var Sound  EggBadLetterSounds[8];
var Sound  EggGoodLetterSounds[5];
var Sound  EggFoundSounds[3];

// ----------------------------------------------------------------------
// ProcessText()
// ----------------------------------------------------------------------

function ProcessText()
{
	PrintPicture(CreditsBannerTextures, 2, 1, 505, 75);
	PrintLn();
	Super.ProcessText();
}

// ----------------------------------------------------------------------
// ProcessFinished()
// ----------------------------------------------------------------------

function ProcessFinished()
{
	PrintLn();
	PrintPicture(TeamPhotoTextures, 3, 1, 600, 236);
	Super.ProcessFinished();
}

// ----------------------------------------------------------------------
// FinishedScrolling()
// ----------------------------------------------------------------------

function FinishedScrolling()
{
	if (player.bQuotesenabled)
	{
		// Shut down the music
//		player.ClientSetMusic(player.Level.Song, savedSongSection, 255, MTRAN_FastFade);
		player.PlaySound(Sound'CreditsEnd');
	}
	else
	{
		Super.FinishedScrolling();
	}
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	if (!bScrolling)
	{
		creditsEndSoundLength -= deltaTime;

		if (creditsEndSoundLength < 0.0)
		{
			bTickEnabled = False;
			InvokeQuotesWindow();
		}
	}

	if (bShowEasterPhrases)
	{
		easterEggTimer -= deltaTime;

		phraseCount = Rand(maxRandomPhrases);
		// Create a random number of phrases
		for(phraseIndex=0; phraseIndex<phraseCount; phraseIndex++)
			CreateEasterPhrase();

		if (easterEggTimer < 0.0)
		{
			bShowEasterPhrases = False;
			easterEggTimer = Default.easterEggTimer;
		}
	}
}

// ----------------------------------------------------------------------
// InvokeQuotesWindow()
// ----------------------------------------------------------------------

function InvokeQuotesWindow()
{
	local QuotesWindow winQuotes;

	// Check to see if the 
	if (player.bQuotesEnabled)
	{
		winQuotes = QuotesWindow(root.InvokeMenuScreen(Class'QuotesWindow'));
		winQuotes.SetLoadIntro(bLoadIntro);
		winQuotes.SetClearStack(True);
	}
}

// ----------------------------------------------------------------------
// DestroyWindow()
// ----------------------------------------------------------------------

event DestroyWindow()
{
	// Check to see if we need to load the intro
	if (bLoadIntro)
	{
		player.Level.Game.SendPlayer(player, "dxonly");
	}

	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// KeyPressed() 
// ----------------------------------------------------------------------

event bool KeyPressed(string key)
{
	local bool bKeyHandled;

	if (IsKeyDown(IK_Alt))
		return False;

	// Check to see if the key entered is one of the 
	// easter egg phrases
	// 
	// First check to see if this is an alphanum character

	if (player.bCheatsEnabled)
	{
		if (((key >= "A") && (key <= "Z")) ||
		    ((key >= "a") && (key <= "z")) ||
		    ((key >= "0") && (key <= "9")))
		{
			bKeyHandled = True;

			// Convert lower-case to upper
			if ((key >= "a") && (key <= "z"))
				key = Chr(Asc(key) - 32);

			easterSearch = easterSearch $ key;

			// If this egg wasn't found *AND* the string is at 
			// least two characters found, then play a BZZT sound
			if (!ProcessEasterEgg())
			{
				// If the string is > 1 character, play a BZZT 
				// sound.
				if (Len(easterSearch) > 1)
				{
					// Play BZZT
					PlayEggBadLetter();
				}

				// Reset string
				easterSearch = "";
			}
		}
	}

	if (bKeyHandled)
		return True;
	else
		return Super.KeyPressed(key);
}

// ----------------------------------------------------------------------
// ProcessEasterEgg()
// ----------------------------------------------------------------------

function bool ProcessEasterEgg()
{
	local Int eggIndex;
	local bool bPartialPhrase;
	local bool bEggFound;

	bPartialPhrase = False;

	// Loop through all the eggs and see if we have a matching phrase
	for(eggIndex=0; eggIndex<arrayCount(easterStrings); eggIndex++)
	{
		if (easterstrings[eggIndex] == easterSearch)
		{
			EggFound(eggIndex);
			bEggFound = True;
			bPartialPhrase = False;
			break;
		}

		// Do a partial search
		if (InStr(easterStrings[eggIndex], easterSearch) != -1)
		{
			bPartialPhrase = True;
		}
	}

	// If this was a partial match, play a sound
	if (bPartialPhrase)
		PlayEggGoodLetter();

	return (bPartialPhrase || bEggFound);
}

// ----------------------------------------------------------------------
// EggFound()
// ----------------------------------------------------------------------

function EggFound(int eggIndex)
{
	PlayEggFoundSound();

	easterPhraseIndex  = eggIndex;
	bShowEasterPhrases = True;

	// Now act on the phrase
	if (easterSearch == "QUOTES")
	{
		player.bQuotesEnabled = True;
		player.SaveConfig();
	}
	else if (easterSearch == "DANCEPARTY")
	{
		player.ConsoleCommand("OPEN 99_ENDGAME4");
	}
	else if (easterSearch == "THEREISNOSPOON")
	{
		player.Matrix();
	}
	else if (easterSearch == "HUTHUT")
	{
	}
	else if (easterSearch == "BIGHEAD")
	{
	}
	else if (easterSearch == "IAMWARREN")
	{
		player.IAmWarren();
	}

	easterSearch = "";
}

// ----------------------------------------------------------------------
// CreateEasterPhrase()
// ----------------------------------------------------------------------

function CreateEasterPhrase()
{
	local FadeTextWindow winFade;

	winFade = FadeTextWindow(NewChild(Class'FadeTextWindow'));
	winFade.SetText(foundStrings[easterPhraseIndex]);
	winFade.SetPos(Rand(width) - Rand(100), Rand(height));
}

// ----------------------------------------------------------------------
// PlayEggFoundSound()
// ----------------------------------------------------------------------

function PlayEggFoundSound()
{
	// Temporary
	player.PlaySound(EggFoundSounds[Rand(ArrayCount(EggFoundSounds))]);
}

// ----------------------------------------------------------------------
// PlayEggGoodLetter()
// ----------------------------------------------------------------------

function PlayEggGoodLetter()
{
	// Temporary
	player.PlaySound(EggGoodLetterSounds[Rand(ArrayCount(EggGoodLetterSounds))]);
}

// ----------------------------------------------------------------------
// PlayEggBadLetter()
// ----------------------------------------------------------------------

function PlayEggBadLetter()
{
	// Temporary
	player.PlaySound(EggBadLetterSounds[Rand(ArrayCount(EggBadLetterSounds))]);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     CreditsBannerTextures(0)=Texture'DeusExUI.UserInterface.CreditsBanner_1'
     CreditsBannerTextures(1)=Texture'DeusExUI.UserInterface.CreditsBanner_2'
     TeamPhotoTextures(0)=Texture'DeusExUI.UserInterface.TeamFront_1'
     TeamPhotoTextures(1)=Texture'DeusExUI.UserInterface.TeamFront_2'
     TeamPhotoTextures(2)=Texture'DeusExUI.UserInterface.TeamFront_3'
     creditsEndSoundLength=4.000000
     easterStrings(0)="QUOTES"
     easterStrings(1)="DANCEPARTY"
     easterStrings(2)="THEREISNOSPOON"
     easterStrings(3)="HUTHUT"
     easterStrings(4)="BIGHEAD"
     easterStrings(5)="IAMWARREN"
     easterStrings(6)="MOREFROGS"
     foundStrings(0)="QUOTES ENABLED!"
     foundStrings(1)="DANCE PARTY ENABLED!"
     foundStrings(2)="MAY TRICKS MODE ENABLED!"
     foundStrings(3)="HUT HUT HUT HUT HUT!"
     foundStrings(4)="SO YOU THINK YOU'RE SMART?"
     foundStrings(5)="GENERAL PROTECTION FAULT!"
     foundStrings(6)="I HAVE TEN FINGERS AND TEN TOES!"
     easterEggTimer=3.000000
     maxRandomPhrases=5
     EggBadLetterSounds(0)=Sound'DeusExSounds.Generic.Buzz1'
     EggBadLetterSounds(1)=Sound'DeusExSounds.Generic.LargeExplosion1'
     EggBadLetterSounds(2)=Sound'DeusExSounds.Generic.GlassBreakLarge'
     EggBadLetterSounds(3)=Sound'DeusExSounds.Generic.SplashLarge'
     EggBadLetterSounds(4)=Sound'DeusExSounds.Animal.CatDie'
     EggBadLetterSounds(5)=Sound'DeusExSounds.NPC.ChildDeath'
     EggBadLetterSounds(6)=Sound'DeusExSounds.Special.FlushToilet'
     EggGoodLetterSounds(0)=Sound'DeusExSounds.Generic.KeyboardClick1'
     EggGoodLetterSounds(1)=Sound'DeusExSounds.Generic.KeyboardClick2'
     EggGoodLetterSounds(2)=Sound'DeusExSounds.Generic.KeyboardClick1'
     EggGoodLetterSounds(3)=Sound'DeusExSounds.Generic.KeyboardClick2'
     EggGoodLetterSounds(4)=Sound'DeusExSounds.Generic.KeyboardClick3'
     EggFoundSounds(0)=Sound'DeusExSounds.Special.Airplane2'
     EggFoundSounds(1)=Sound'DeusExSounds.Generic.Beep2'
     EggFoundSounds(2)=Sound'DeusExSounds.Generic.Foghorn'
     ScrollMusicString="Credits_Music.Credits_Music"
     textName=DeusExCredits
}
