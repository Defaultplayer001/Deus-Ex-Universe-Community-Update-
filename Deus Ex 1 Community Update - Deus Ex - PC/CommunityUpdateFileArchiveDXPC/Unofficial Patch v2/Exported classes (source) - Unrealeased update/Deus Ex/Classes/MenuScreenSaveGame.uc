//=============================================================================
// MenuScreenSaveGame
//=============================================================================

class MenuScreenSaveGame expands MenuScreenLoadGame;

var ClipWindow               clipName;
var MenuUILoadSaveEditWindow editName;

var String  currentSaveName;
var int	    editRowId;
var int     newSaveRowId;
var bool    bInitializing;
var int     tickCount;
var int     saveRowID;

// Used for the new savegame slot
var String  missionLocation;
var Texture newSaveSnapshot;
var String  defaultSaveText;
var Bool    bGenerateSnapShot;
var Float   snapshotWidth;
var Float   snapshotHeight;

var localized String DiskSpaceTitle;
var localized String DiskSpaceMessage;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	bInitializing = True;

	Super.InitWindow();

	// Need to do this because of the edit control used for 
	// saving games.
	SetMouseFocusMode(MFOCUS_Click);

	NewSaveGame();

	SetFocusWindow(editName);

	// Don't mask this window, as we need to take a snapshot of 
	// the 3D scene without worry about the snapshot or a black screen.
	if (player.UIBackground > 0)
		root.HideSnapshot();

	root.Hide();

	bGenerateSnapShot = True;
	bTickEnabled      = True;
	bInitializing     = False;
}

// ----------------------------------------------------------------------
// DestroyWindow()
// ----------------------------------------------------------------------

function DestroyWindow()
{
	if (newSaveSnapshot != None)
	{
		CriticalDelete(newSaveSnapshot);
		newSaveSnapshot = None;
	}
	root.ShowSnapshot(True);
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	CreateEditControl();
	EnableButtons();
}

// ----------------------------------------------------------------------
// CreateEditControl()
//
// Creates the edit control used when saving games and hides it
// ----------------------------------------------------------------------

function CreateEditControl()
{
	clipName = ClipWindow(lstGames.newChild(Class'ClipWindow'));
	clipName.SetWidth(235);
	clipName.ForceChildSize(False, True);

	editName = MenuUILoadSaveEditWindow(clipName.newChild(Class'MenuUILoadSaveEditWindow'));
	clipName.Hide();
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local int keyIndex;
	local bool bKeyHandled;

	switch(key)
	{
		case IK_Up:
			SelectPreviousRow();
			bKeyHandled = True;
			break;

		case IK_Down:
			SelectNextRow();
			bKeyHandled = True;
			break;

		case IK_Enter:
			bKeyHandled = True;
			ConfirmSaveGame();
			break;

		default:
			bKeyHandled = False;
	}

	if (bKeyHandled)
		return True;
	else
		return Super.VirtualKeyPressed(key, bRepeat);
}

// ----------------------------------------------------------------------
// BoxOptionSelected()
// ----------------------------------------------------------------------

event bool BoxOptionSelected(Window msgBoxWindow, int buttonNumber)
{
	local string newName;
	local int deleteRowId;

	// Destroy the msgbox!  
	root.PopWindow();

	switch(msgBoxMode)
	{
		case MB_Overwrite:
			if ( buttonNumber == 0 ) 
			{
				SaveGame(saveRowId);
			}
			else
			{
				msgBoxMode = MB_None;
				clipName.Show();
				SetFocusWindow(editName);
			}
			break;

		case MB_Delete:

			if ( buttonNumber == 0 )
			{
				msgBoxMode  = MB_None;
				deleteRowId = editRowId;
				MoveEditControl(newSaveRowID);				
				DeleteGame(deleteRowId);			
			}
			else
			{
				clipName.Show();
				SetFocusWindow(editName);
			}

			break;

		case MB_LowSpace:
			break;

		default:
			msgBoxMode = MB_None;
	}

	return True;
}

// ----------------------------------------------------------------------
// ListRowActivated()
// ----------------------------------------------------------------------

event bool ListRowActivated(window list, int rowId)
{
	if (rowId != editRowId)
		MoveEditControl(rowId);

	return true;
}

// ----------------------------------------------------------------------
// ListSelectionChanged() 
//
// When the user clicks on an item in the list, update the buttons
// appropriately.  If we're in Save mode and the user clicks on a 
// name *twice* (but doesn't double-click), then allow the user 
// to rename the box by displaying the edit control on top of the 
// list item.
// ----------------------------------------------------------------------

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
	if (!bInitializing)
	{
		if (focusRowId != editRowId)
		{
			MoveEditControl(focusRowId);
			UpdateSaveInfo(focusRowId);

			EnableButtons();
		}
	}

	return false;
}

// ----------------------------------------------------------------------
// UpdateSaveInfo()
// ----------------------------------------------------------------------

function UpdateSaveInfo(int rowId)
{
	// If this is the saveRowId, then use our stored away
	// snapshot
	if (rowId == newSaveRowID)
	{
		winSnapshot.SetBackground(newSaveSnapshot);	
		winSaveInfo.SetText(Sprintf(LocationLabel, MissionLocation));
		winSaveInfo.AppendText(Sprintf(SaveCountLabel, player.saveCount));
		winSaveInfo.AppendText(Sprintf(PlayTimeLabel, BuildElapsedTimeString(Int(player.saveTime))));

		// Show the "Cheats Enabled" text if cheats were enabled for this savegame
		if (player.bCheatsEnabled)
			winCheatsEnabled.Show();
	}
	else
	{
		Super.UpdateSaveInfo(rowId);
	}
}

// ----------------------------------------------------------------------
// SelectNextRow()
// ----------------------------------------------------------------------

function SelectNextRow()
{
	local int rowId;
	local int rowIndex;

	rowId    = lstGames.GetSelectedRow();
	rowIndex = lstGames.RowIdToIndex(rowId);

	if (rowIndex < lstGames.GetNumRows() - 1)
	{
		rowIndex++;
		rowId = lstGames.IndexToRowId(rowIndex);
		lstGames.SelectRow(rowId);
	}
}

// ----------------------------------------------------------------------
// SelectPreviousRow()
// ----------------------------------------------------------------------

function SelectPreviousRow()
{
	local int rowId;
	local int rowIndex;

	rowId    = lstGames.GetSelectedRow();
	rowIndex = lstGames.RowIdToIndex(rowId);

	if (rowIndex > 0)
	{
		rowIndex--;
		rowId = lstGames.IndexToRowId(rowIndex);
		lstGames.SelectRow(rowId);
	}
}

// ----------------------------------------------------------------------
// GenerateNewSnapShot()
// ----------------------------------------------------------------------

function GenerateNewSnapShot()
{
   // DEUS_EX CAC - only take screenshot if not using OpenGL   
	if (GetConfig("Engine.Engine", "GameRenderDevice") != "OpenGlDrv.OpenGLRenderDevice")
   {
      root.SetSnapshotSize(snapshotWidth, snapshotHeight);
  	   newSaveSnapshot = root.GenerateSnapshot(True);
	   winSnapshot.SetBackground(newSaveSnapshot);	
   }
}

// ----------------------------------------------------------------------
// NewSaveGame()
// ----------------------------------------------------------------------

function NewSaveGame()
{
	local String timeString;
	local DeusExSaveInfo saveInfo;
	local GameDirectory saveDir;

	// Save away the mission string
	SaveMissionLocationString();

	// Create our Map Directory class
	saveDir = player.CreateGameDirectoryObject();

	saveInfo = saveDir.GetTempSaveInfo();
	saveInfo.UpdateTimeStamp();

	// Insert a new row at the top of the listbox and move the 
	// edit window there.

	// TODO: Come up with a better default save game name
	// (level title and some counter, maybe?)

	timeString = BuildTimeString(
		saveInfo.Year, saveInfo.Month, saveInfo.Day,
		saveInfo.Hour, saveInfo.Minute);

	newSaveRowID = lstGames.AddRow(missionLocation $ ";" $ timeString $ ";9999999999;;-2");

	lstGames.SetRow(newSaveRowID);
	MoveEditControl(newSaveRowID, True);
	editName.SetSelectedArea(0, Len(missionLocation));

	CriticalDelete(savedir);
}

// ----------------------------------------------------------------------
// SaveMissionLocationString()
//
// Save away the mission string
// ----------------------------------------------------------------------

function SaveMissionLocationString()
{
	local DeusExLevelInfo aDeusExLevelInfo;

	missionLocation = "";

	// Grab the mission location, which we'll use to build a default
	// save game string
	foreach player.AllActors(class'DeusExLevelInfo', aDeusExLevelInfo)
	{
		if (aDeusExLevelInfo != None)
		{
			missionLocation = aDeusExLevelInfo.MissionLocation;	
			break;
		}
	}

	if (missionLocation == "")
		missionLocation = defaultSaveText;
}

// ----------------------------------------------------------------------
// ConfirmSaveGame()
//
// If the user is overwriting an existing savegame, then prompt to 
// confirm first.
// ----------------------------------------------------------------------

function ConfirmSaveGame()
{
	// First check to see how much disk space we have. 
	// If < the minimum, then notify the user to clear some 
	// disk space.

	if ((freeDiskSpace / 1024) < minFreeDiskSpace)
	{
		msgBoxMode = MB_LowSpace;
		root.MessageBox(DiskSpaceTitle, DiskSpaceMessage, 1, False, Self);
	}
	else
	{
		if (editRowId == newSaveRowId)
		{
			SaveGame(editRowId);
		}
		else
		{
			saveRowId = editRowId;
			msgBoxMode = MB_Overwrite;
			root.MessageBox( OverwriteTitle, OverwritePrompt, 0, False, Self);
		}
	}
}

// ----------------------------------------------------------------------
// SaveGame()
// ----------------------------------------------------------------------

function SaveGame(int rowId)
{
	// Okay, we need to do some trickery in order to take a snapshot
	// of the game that doesn't have the UI in it!

	saveRowID = rowId;

	if (player.UIBackground > 0)
		root.HideSnapshot();

	root.Hide();
	bTickEnabled  = True;
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	if (bGenerateSnapShot)
	{
		if (tickCount++ == 1)
		{
			bGenerateSnapShot = False;
			tickCount = 0;

			GenerateNewSnapShot();
			root.ShowSnapshot(True);
			UpdateSaveInfo(newSaveRowId);
			bTickEnabled = False;
			root.Show();
			Show();
		}
	}
	else
	{
		if (tickCount++ == 1)
		{
			root.HideSnapshot();
			bTickenabled = False;
			PerformSave();	
		}
	}
}

// ----------------------------------------------------------------------
// PerformSave()
// ----------------------------------------------------------------------

function PerformSave()
{
	local DeusExRootWindow localRoot;
	local DeusExPlayer localPlayer;
	local int gameIndex;
	local String saveName;

	// Get the save index if this is an existing savegame
	gameIndex = int(lstGames.GetFieldValue(saveRowID, 4));

	// If gameIndex is -2, this is our New Save Game and we 
	// need to set gameIndex to 0, which is not a valid
	// gameIndex, in which case the DeusExGameEngine::SaveGame()
	// code will be kind and get us a new GameIndex (Really!
	// If you don't believe me, go look at the code!)

	if (gameIndex == -2)
		gameIndex = 0;

	saveName = editName.GetText();

	localPlayer   = player;
	localRoot     = root;

	localRoot.ClearWindowStack();
	localPlayer.SaveGame(gameIndex, saveName);
	localRoot.Show();
}

// ----------------------------------------------------------------------
// DeleteGame()
// ----------------------------------------------------------------------

function DeleteGame(int rowId)
{
	// Hide the edit box
	clipName.Hide();

	editRowId = newSaveRowId;
	currentSaveName = missionLocation;

	Super.DeleteGame(rowId);
}

// ----------------------------------------------------------------------
// ProcessAction()
//
// Meant to be called in derived class
// ----------------------------------------------------------------------

function ProcessAction(String actionKey)
{
	local int deleteRowId;

	if (actionKey == "SAVE")
	{
		ConfirmSaveGame();
	}
	else if (actionKey == "DELETE")
	{
		// Only confirm 
		if (chkConfirmDelete.GetToggle())
		{
			ConfirmDeleteGame(lstGames.GetSelectedRow());
		}
		else
		{
			deleteRowId = editRowId;
			MoveEditControl(newSaveRowID);				
			DeleteGame(deleteRowId);
		}
	}
	else
	{
		Super.ProcessAction(actionKey);
	}
}

// ----------------------------------------------------------------------
// MoveEditControl()
// ----------------------------------------------------------------------

function MoveEditControl(int rowId, optional bool bNoSetOldName)
{	
	local int rowIndex;
	local String saveNamePlaceholder;

	// Check for valid edit row Id
	if (editRowId == -1)
		return;

	saveNamePlaceholder = lstGames.GetField(rowId, 0);

	// Restore the savegame from where we're currently located
	if (!bNoSetOldName)
		lstGames.SetField(editRowId, 0, currentSaveName);

	// Save the rowId so we can restore the list to its previous
	// state if the user hits Escape while editing the text
	editRowId = rowId;
	
	// Save the current savegame so we can restore it if the user 
	// hits Escape.
	currentSaveName = saveNamePlaceholder;

	lstGames.EnableAutoSort(False);
	lstGames.SetField(editRowId, 0, "");

	// If the user is over the QuickSave slot, then prevent 
	// him/her/it from modifying the text
	editName.EnableEditing(int(lstGames.GetField(lstGames.GetSelectedRow(), 4)) != -1);

	// Unselect the row and hide its text
	lstGames.SelectRow(editRowId, False);

	// Get the physical row location so we can position the 
	// edit control in the same place as the selected row
	rowIndex = lstGames.RowIdToIndex(editRowId);				
	clipName.SetPos(0, (rowIndex * lstGames.lineSize) + 1);

	// Set the edit text, move the cursor to the 
	// end of the line, and finally show the edit control.
	editName.SetText(currentSaveName);
	editName.MoveInsertionPoint(MOVEINSERT_End);

	// Show the edit control, which should be hidden when 
	// this function is called.
	clipName.Show();
	SetFocusWindow(editName);
}

// ----------------------------------------------------------------------
// HideEditControl()
// ----------------------------------------------------------------------

function HideEditControl()
{
	clipName.Hide();
	lstGames.EnableAutoSort(True);
}

// ----------------------------------------------------------------------
// EditActivated()
//
// If the user hit's [Return] while editing the filename, save it.
// ----------------------------------------------------------------------

event bool EditActivated(window edit, bool bModified)
{
	if ( edit != editName ) 
		return False;

	if ( editName.GetText() != "" ) 
	{
		HideEditControl();
		lstGames.SetField(editRowId, 0, editName.GetText());
		lstGames.SetRow(editRowId);
		ConfirmSaveGame();

		return True;
	}
	else
	{
		return False;
	}
}

// ----------------------------------------------------------------------
// TextChanged() 
// ----------------------------------------------------------------------

event bool TextChanged(window edit, bool bModified)
{
	// If this is the quicksave gameslot, don't allow the user 
	// to edit!!!
	if (int(lstGames.GetField(lstGames.GetSelectedRow(), 4)) == -1)
		editName.EnableWindow(False);

	EnableButtons();

	return false;
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	// Don't allow delete if we're on the new savegame or the QuickSave 
	// slot

	if ((editRowId != newSaveRowId) && (editRowId != -1))
		EnableActionButton(AB_Other, True, "DELETE");
	else
		EnableActionButton(AB_Other, False, "DELETE");
		
	if (editName != None)
	{
		if ((editName.IsVisible()) && (editName.GetText() == ""))
			EnableActionButton(AB_Other, False, "SAVE");
		else
			EnableActionButton(AB_Other, True, "SAVE");
	}
	else
	{
		EnableActionButton(AB_Other, True, "SAVE");	
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     newSaveSnapshot=Texture'Extension.Solid'
     defaultSaveText="ERROR! Report this as a BUG!"
     snapshotWidth=160.000000
     snapshotHeight=120.000000
     DiskSpaceTitle="Disk Space Low"
     DiskSpaceMessage="You must have at least 100MB of free disk space before you can save.  Please delete some save games or free up space in Windows."
     actionButtons(1)=(Text="|&Save Game",Key="SAVE")
     Title="Save Game"
}
