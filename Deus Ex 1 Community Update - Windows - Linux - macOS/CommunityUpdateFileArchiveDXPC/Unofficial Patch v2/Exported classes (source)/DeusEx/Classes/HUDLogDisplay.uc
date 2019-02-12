//=============================================================================
// HUDLogDisplay
//=============================================================================
class HUDLogDisplay expands HUDSharedBorderWindow;

// ----------------------------------------------------------------------
// Local Variables
// ----------------------------------------------------------------------

var Bool          bMessagesWaiting;
var Window        winIcon;
var TextLogWindow winLog;

// Timer
var Float displayTime;
var Float lastLogMsg;

// Sound
var Sound logSoundToPlay;

// defaults
var Font  fontLog;
var Float logMargin;
var int   MinLogLines;
var int   MaxLogLines;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Create Controls
	CreateControls();

	StyleChanged();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	// Create the icon in the upper left corner
	winIcon = NewChild(Class'Window');
	winIcon.SetSize(32, 32);
	winIcon.SetPos(logMargin * 2, topMargin + 5);
	winIcon.SetBackgroundStyle(DSTY_Masked);
	winIcon.SetBackground(Texture'LogIcon');

	// Create the text log
	winLog = TextLogWindow(NewChild(Class'TextLogWindow'));
	winLog.SetTextAlignments(HALIGN_Left, VALIGN_Top);
	winLog.SetTextMargins(0, 0);
	winLog.SetFont(fontLog);
	winLog.SetLines(MinLogLines, MaxLogLines);
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
//
// Set the size of stuff and stuff.
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	local float qWidth, qHeight;
	local float windowStart;

	winIcon.QueryPreferredSize(windowStart, qHeight);
	windowStart += (logMargin * 3);

	// Text Log
	qHeight = winLog.QueryPreferredHeight(width - windowStart - logMargin);
	winLog.ConfigureChild(windowStart, topMargin, width - windowStart - logMargin, qHeight);
}

// ----------------------------------------------------------------------
// ParentRequestedPreferredSize() 
// ----------------------------------------------------------------------

event ParentRequestedPreferredSize(bool bWidthSpecified, out float preferredWidth,
                                   bool bHeightSpecified, out float preferredHeight)
{
	local float qHeight;
	local float logWidth;
	local float windowStart;
	local float minWindowHeight;

	if ( bWidthSpecified )
	{
		preferredHeight =  topMargin;

		winIcon.QueryPreferredSize(windowStart, minWindowHeight);

		if (minWindowHeight < minHeight)
			minWindowHeight = minHeight;

		windowStart += (logMargin * 3);

		logWidth  = preferredWidth - windowStart - logMargin;
		preferredHeight += winLog.QueryPreferredHeight(logWidth) + logMargin;

		preferredHeight = Max(minWindowHeight, preferredHeight);
	}
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

event bool ChildRequestedReconfiguration(window childWin)
{
	return False;
}

// ----------------------------------------------------------------------
// VisibilityChanged()
// ----------------------------------------------------------------------

event VisibilityChanged(bool bNewVisibility)
{
	Super.VisibilityChanged( bNewVisibility );

	bTickEnabled = bNewVisibility;

	if ( winLog != None )
		winLog.PauseLog( !bNewVisibility );

	// If we just became visible and we have a log sound to play,
	// then do it now

	if ( bNewVisibility && ( logSoundToPlay != None ))
	{
		PlaySound(logSoundToPlay, 0.75);
		logSoundToPlay = None;
	}
}

// ----------------------------------------------------------------------
// MessagesWaiting()
// ----------------------------------------------------------------------

function Bool MessagesWaiting()
{
	return bMessagesWaiting;
}

// ----------------------------------------------------------------------
// Tick()
//
// Used to display the log window for 'x' number of seconds before
// hiding it again.
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
	// If a DataLink or Conversation is being played, then don't count down,
	// so we don't miss any log messages the player might receive.

	if ((player.dataLinkPlay == None) && 
	    ((player.conPlay == None) ||
		 ((player.conPlay != None) && (player.conPlay.GetDisplayMode() == DM_FirstPerson))))
	{
		if (( lastLogMsg > 0.0 ) && ( lastLogMsg + deltaSeconds > displayTime ))
		{
			bTickEnabled     = False;
			bMessagesWaiting = False;
			Hide();
			winLog.PauseLog(False);
			AskParentForReconfigure();
		}
		lastLogMsg = lastLogMsg + deltaSeconds;
	}
}

// ----------------------------------------------------------------------
// AddLog()
// ----------------------------------------------------------------------

function AddLog(coerce String newLog, Color linecol)
{
	local DeusExRootWindow root;
	local PersonaScreenBaseWindow winPersona;

	if ( newLog != "" )
	{
		root = DeusExRootWindow(GetRootWindow());

		// If a PersonaBaseWindow is visible, send the log message 
		// that way as well.

		winPersona = PersonaScreenBaseWindow(root.GetTopWindow());
		if (winPersona != None)
			winPersona.AddLog(newLog);

		// If the Hud is not visible, then pause the log
		// until we become visible again
		//
		// Don't show the log if a DataLink is playing

		if (( GetParent().IsVisible() ) && ( root.hud.infolink == None ))
		{
			Show();
		}
		else
		{
			bMessagesWaiting = True;
			winLog.PauseLog( True );
		}

		bTickEnabled = TRUE;
		winLog.AddLog(newLog, linecol);
		lastLogMsg = 0.0;
		AskParentForReconfigure();
	}
}

// ----------------------------------------------------------------------
// SetIcon()
// ----------------------------------------------------------------------

function SetIcon(Texture newIcon)
{
	winIcon.SetBackground(newIcon);
}

// ----------------------------------------------------------------------
// SetLogTimeout()
// ----------------------------------------------------------------------

function SetLogTimeout(Float newTimeout)
{
	displayTime = newTimeout;
	winLog.SetTextTimeout(newTimeout);
}

// ----------------------------------------------------------------------
// SetMaxLogLines()
// ----------------------------------------------------------------------

function SetMaxLogLines(Byte newLogLines)
{
	winLog.SetLines(MinLogLines, newLogLines);
}

// ----------------------------------------------------------------------
// PlayLogSound()
// ----------------------------------------------------------------------

function PlayLogSound(Sound newLogSound)
{
	// If the log is visible, play this sound right now.
	// Otherwise wait until we become visible

	if ( IsVisible() )
	{
		PlaySound(newLogSound, 0.75);
		logSoundToPlay = None;
	}
	else
	{
		logSoundToPlay = newLogSound;
	}
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	Super.StyleChanged();

	if (winLog != None)
		winLog.SetTextColor(colText);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     displayTime=3.000000
     fontLog=Font'DeusExUI.FontMenuSmall_DS'
     logMargin=10.000000
     MinLogLines=4
     maxLogLines=10
}
