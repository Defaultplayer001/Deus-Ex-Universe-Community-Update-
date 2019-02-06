//=============================================================================
// QuotesWindow
//=============================================================================
class QuotesWindow expands CreditsScrollWindow;

var Texture TeamPhotoTextures[6];
var bool    bClearStack;

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	local int logoIndex;

	for(logoIndex=0; logoIndex<10; logoIndex++)
		CreateLogo();

	Super.CreateControls();
}

// ----------------------------------------------------------------------
// CreateLogo()
// 
// Create bouncing logo
// ----------------------------------------------------------------------

function CreateLogo()
{
	local SpinningLogoWindow winLogo;

	winLogo = SpinningLogoWindow(NewChild(Class'SpinningLogoWindow'));
	winLogo.SetPos(Rand(root.width), Rand(root.height));
	winLogo.horizontalDir = Rand(320) - 160;
	winLogo.verticalDir = Rand(320) - 160;

	winLogo.Lower();
}

// ----------------------------------------------------------------------
// DeleteLogo()
// ----------------------------------------------------------------------

function DeleteLogo()
{
	local Window currentWindow;

	// Loop through the windows and when we find the first
	// logo, delete it then abort

	currentWindow = GetTopChild();
	while(currentWindow != None)
	{
		if (currentWindow.IsA('SpinningLogoWindow'))
		{
			currentWindow.Destroy();
			break;
		}
		currentWindow = currentWindow.GetLowerSibling();
	}
}

// ----------------------------------------------------------------------
// DeleteAllLogos()
// ----------------------------------------------------------------------

function DeleteAllLogos()
{
	local Window currentWindow;
	local Window nextWindow;

	// Loop through the windows and when we find a logo, delete it!

	currentWindow = GetTopChild();
	while(currentWindow != None)
	{
		nextWindow = currentWindow.GetLowerSibling();

		if (currentWindow.IsA('SpinningLogoWindow'))
		{
			currentWindow.Destroy();
		}

		currentWindow = nextWindow;
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
// SetClearStack()
// ----------------------------------------------------------------------

function SetClearStack(bool bNewClearStack)
{
	bClearStack = bNewClearStack;
}

// ----------------------------------------------------------------------
// FinishedScrolling()
// ----------------------------------------------------------------------

function FinishedScrolling()
{
	if (bClearStack)
		root.ClearWindowStack();
	else
		Super.FinishedScrolling();
}

// ----------------------------------------------------------------------
// ProcessFinished()
// ----------------------------------------------------------------------

function ProcessFinished()
{
	PrintLn();
	PrintPicture(TeamPhotoTextures, 3, 1, 600, 214);
	Super.ProcessFinished();
}

// ----------------------------------------------------------------------
// ProcessTextTag()
// ----------------------------------------------------------------------

function ProcessTextTag(DeusExTextParser parser)
{
	local String text;
	local byte tag;
	local bool bTagHandled;

	bTagHandled = False;

	tag  = parser.GetTag();

	switch(tag)
	{
		case 0:				// TT_Text:
			text = parser.GetText();

			if (text == "")
			{
				PrintLn();
			}
			else
			{
				if (bBold)
				{
					bBold = False;
					PrintHeader(parser.GetText());
				}
				else
				{
					ProcessQuoteLine(parser.GetText());
				}
			}
			bTagHandled = True;
			break;
	}

	if (!bTagHandled)
		Super.ProcessTextTag(parser);
}

// ----------------------------------------------------------------------
// ProcessQuoteLine()
// ----------------------------------------------------------------------

function ProcessQuoteLine(String parseText)
{
	local string personText;
	local string quoteText;
	local int colonPos;

	// Find the colon
	colonPos = InStr(parseText, ":");

	if (colonPos == -1)
	{
		PrintText(parseText);
	}
	else
	{
		PrintAlignText(Left(parseText, colonPos + 1), Right(parseText, Len(parseText) - colonPos - 1));
	}
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bKeyHandled;

	bKeyHandled = True;

	if ( IsKeyDown( IK_Alt ) || IsKeyDown( IK_Shift ) )
		return False;

	switch( key ) 
	{	
		case IK_Escape:
			FinishedScrolling();
			break;

		case IK_Insert:
			CreateLogo();
			break;

		case IK_Delete:
			DeleteLogo();
			break;

		case IK_End:
			DeleteAllLogos();
			break;

		default:
			bKeyHandled = False;
			break;
	}

	if (bKeyHandled)
		return bKeyHandled;
	else
		return Super.VirtualKeyPressed(key, bRepeat);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     TeamPhotoTextures(0)=Texture'DeusExUI.UserInterface.TeamBack_1'
     TeamPhotoTextures(1)=Texture'DeusExUI.UserInterface.TeamBack_2'
     TeamPhotoTextures(2)=Texture'DeusExUI.UserInterface.TeamBack_3'
     ScrollMusicString="Quotes_Music.Quotes_Music"
     textName=DeusExQuotes
     colHeader=(R=192,B=192)
     colText=(R=128,G=255,B=128)
}
