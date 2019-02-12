//=============================================================================
// MenuScreenLoadGame
//=============================================================================

class MenuScreenLoadGame expands MenuUIScreenWindow;

enum EMessageBoxModes
{
	MB_Delete,
	MB_Overwrite,
	MB_LowSpace,
	MB_None
};

// Windows
var MenuUIListWindow				lstGames;
var MenuUILabelWindow               winSaveInfo;
var MenuUILabelWindow				winFreeSpace;
var Window							winSnapshot;
var MenuUIListHeaderButtonWindow	btnHeaderName;
var MenuUIListHeaderButtonWindow	btnHeaderDate;
var MenuUIScrollAreaWindow			winScroll;
var MenuUICheckboxWindow			chkConfirmDelete;
var MenuUILabelWindow               winCheatsEnabled;

// Other stuff
var int					saveRowId;
var EMessageBoxModes	msgBoxMode;
var bool				bNameSortOrder;
var bool				bDateSortOrder;
var int					freeDiskSpace;
var bool				bLoadGamePending;
var int					loadGameRowId;
var int                 minFreeDiskSpace;

// Localized Strings
var localized string strHeaderNameLabel;
var localized string strHeaderDateLabel;
var localized string NewSaveGameButtonText;
var localized string DeleteGameButtonText;
var localized string LoadGameButtonText;
var localized string OverwriteTitle;
var localized string OverwritePrompt;
var localized string DeleteTitle;
var localized string DeletePrompt;
var localized string LoadGameTitle;
var localized string SaveGameTitle;
var localized string SaveInfoMissing_Label;
var localized string TimeAMLabel;
var localized string TimePMLabel;
var localized string LocationLabel;
var localized string SaveCountLabel;
var localized string PlayTimeLabel;
var localized string FileSizeLabel;
var localized string FreeSpaceLabel;
var localized string ConfirmDeleteLabel;
var localized string CheatsEnabledLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Create controls
	PopulateGames();
	EnableButtons();
	UpdateFreeDiskSpace();

	Show();
	SetFocusWindow(lstGames);
}

// ----------------------------------------------------------------------
// DestroyWindow()
// ----------------------------------------------------------------------

event DestroyWindow()
{
	player.SaveConfig();
	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// ToggleChanged()
// ----------------------------------------------------------------------

event bool ToggleChanged(Window button, bool bNewToggle)
{	
	if (button == chkConfirmDelete)
	{
		player.bConfirmSaveDeletes = bNewToggle;
		return True;
	}
	else
	{
		return False;
	}
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled = True;

	if (Super.ButtonActivated(buttonPressed))
		return True;

	switch( buttonPressed )
	{
		case btnHeaderName:
			bNameSortOrder = !bNameSortOrder;
			lstGames.SetSortColumn(0, bNameSortOrder);
			lstGames.Sort();
			break;

		case btnHeaderDate:
			bDateSortOrder = !bDateSortOrder;
			lstGames.SetSortColumn(2, bDateSortOrder);
			lstGames.Sort();
			break;

		default:
			bHandled = False;
			break;
	}

	return bHandled;
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

	if ( IsKeyDown( IK_Alt ) || IsKeyDown( IK_Shift ) || IsKeyDown( IK_Ctrl ))
		return False;

	switch( key ) 
	{	
		case IK_Delete:
			if (IsActionButtonEnabled(AB_Other, "DELETE"))
				ProcessAction("DELETE");
			break;

		default:
			bKeyHandled = False;
	}

	if ( !bKeyHandled )
		return Super.VirtualKeyPressed(key, bRepeat);
	else
		return bKeyHandled;
}

// ----------------------------------------------------------------------
// ListRowActivated()
// ----------------------------------------------------------------------

event bool ListRowActivated(window list, int rowId)
{
	if (IsKeyDown(IK_Enter))
	{
		loadGameRowId = rowId;
		bLoadGamePending = True;
	}
	else
	{
		LoadGame(rowId);
	}

	return true;
}

// ----------------------------------------------------------------------
// RawKeyPressed()
// ----------------------------------------------------------------------

event bool RawKeyPressed(EInputKey key, EInputState iState, bool bRepeat)
{
	if ((key == IK_Enter) && (iState == IST_Release) && (bLoadGamePending))
	{
		LoadGame(loadGameRowId);
		return True;
	}
	else
	{
		return false;  // don't handle
	}
}

// ----------------------------------------------------------------------
// ListSelectionChanged() 
//
// When the user clicks on an item in the list, update the screenshot
// and info box appropriately
// ----------------------------------------------------------------------

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
	UpdateSaveInfo(focusRowID);
	EnableButtons();
	return False;
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	CreateGamesList();
	CreateHeaderButtons();
	CreateSnapshotWindow();
	CreateSaveInfoWindow();
	CreateFreeSpaceWindow();
	CreateConfirmCheckbox();
}

// ----------------------------------------------------------------------
// CreateConfirmCheckbox()
// ----------------------------------------------------------------------

function CreateConfirmCheckbox()
{
	chkConfirmDelete = MenuUICheckboxWindow(winClient.NewChild(Class'MenuUICheckboxWindow'));

	chkConfirmDelete.SetPos(389, 256);
	chkConfirmDelete.SetText(ConfirmDeleteLabel);
	chkConfirmDelete.SetFont(Font'FontMenuSmall');
	chkConfirmDelete.SetToggle(player.bConfirmSaveDeletes);
}

// ----------------------------------------------------------------------
// CreateSaveInfoWindow()
// ----------------------------------------------------------------------

function CreateSaveInfoWindow()
{
	winSaveInfo = MenuUILabelWindow(winClient.NewChild(Class'MenuUILabelWindow'));

	winSaveInfo.SetFont(Font'FontMenuSmall');
	winSaveInfo.SetPos(390, 166);
	winSaveInfo.SetSize(155, 60);
	winSaveInfo.SetTextMargins(0, 0);
	winSaveInfo.SetTextAlignments(HALIGN_Left, VALIGN_Center);
}

// ----------------------------------------------------------------------
// CreateFreeSpaceWindow()
// ----------------------------------------------------------------------

function CreateFreeSpaceWindow()
{
	winFreeSpace = MenuUILabelWindow(winClient.NewChild(Class'MenuUILabelWindow'));
	winFreeSpace.SetFont(Font'FontMenuSmall');
	winFreeSpace.SetPos(390, 228);
	winFreeSpace.SetSize(155, 12);
	winFreeSpace.SetTextMargins(0, 0);
}

// ----------------------------------------------------------------------
// CreateGamesList()
//
// Creates the listbox containing the save games
//
// Column 0 = Save Description (typed by user)
// Column 1 = Human Readable Date/Time stamp
// Column 2 = Sort column on Julian date
// Column 3 = 
// Column 4 = Save File Index (0 - 9999)
// ----------------------------------------------------------------------

function CreateGamesList()
{
	winScroll = CreateScrollAreaWindow(winClient);

	winScroll.SetPos(11, 22);
	winScroll.SetSize(371, 270);

	lstGames = MenuUIListWindow(winScroll.clipWindow.NewChild(Class'MenuUIListWindow'));
	lstGames.EnableMultiSelect(False);
	lstGames.EnableAutoExpandColumns(False);

	lstGames.SetNumColumns(5);

	lstGames.SetColumnWidth(0, 240);
	lstGames.SetColumnType(0, COLTYPE_String);
	lstGames.SetColumnWidth(1, 131);
	lstGames.SetColumnType(1, COLTYPE_String);
	lstGames.SetColumnFont(1, Font'FontFixedWidthSmall');

	lstGames.SetColumnType(2, COLTYPE_Float);
	lstGames.SetSortColumn(2, bDateSortOrder);
	lstGames.EnableAutoSort(True);
	
	lstGames.SetColumnType(4, COLTYPE_Float);

	lstGames.HideColumn(2);
	lstGames.HideColumn(3);
	lstGames.HideColumn(4);
}

// ----------------------------------------------------------------------
// CreateHeaderButtons()
// ----------------------------------------------------------------------

function CreateHeaderButtons()
{
	btnHeaderName = CreateHeaderButton(10,  3, 238, strHeaderNameLabel, winClient);
	btnHeaderDate = CreateHeaderButton(251, 3, 131, strHeaderDateLabel, winClient);
}

// ----------------------------------------------------------------------
// CreateSnapshotWindow()
//
// Creates the window that will display the snapshot stored in the 
// savegame.
// ----------------------------------------------------------------------

function CreateSnapshotWindow()
{
	winSnapshot = winClient.NewChild(Class'Window');
	winSnapshot.SetPos(387, 24);
	winSnapshot.SetSize(160, 120);

	winCheatsEnabled = MenuUILabelWindow(winSnapShot.NewChild(Class'MenuUILabelWindow'));
	winCheatsEnabled.SetPos(0, 0);
	winCheatsEnabled.SetSize(160, 120);
	winCheatsEnabled.SetTextMargins(0, 0);
	winCheatsEnabled.SetText(CheatsEnabledLabel);
	winCheatsEnabled.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winCheatsEnabled.Hide();
}

// ----------------------------------------------------------------------
// UpdateSaveInfo()
// ----------------------------------------------------------------------

function UpdateSaveInfo(int rowId)
{
	local DeusExSaveInfo saveInfo;
	local GameDirectory saveDir;
	local int fileSize;

	saveDir = GetSaveGameDirectory();
	if (saveDir != None)
	{
		saveInfo  = saveDir.GetSaveInfo(Int(lstGames.GetField(rowId, 4)));

		if (saveInfo != None)
		{
			winSnapshot.SetBackground(saveInfo.Snapshot);
			winSaveInfo.SetText(Sprintf(LocationLabel, saveInfo.MissionLocation));
			winSaveInfo.AppendText(Sprintf(SaveCountLabel, saveInfo.SaveCount));
			winSaveInfo.AppendText(Sprintf(PlayTimeLabel, BuildElapsedTimeString(saveInfo.saveTime)));

			// divide to GetSaveDirectorSize by 1024 to get size of directory in MB
			// Round up by one for comfort (and so you don't end up with "0MB", only 
			// possible with really Tiny maps). 

			fileSize = (saveDir.GetSaveDirectorySize(Int(lstGames.GetField(rowId, 4))) / 1024) + 1;
			winSaveInfo.AppendText(Sprintf(FileSizeLabel, fileSize));

			// Show the "Cheats Enabled" text if cheats were enabled for this savegame
			winCheatsEnabled.Show(saveInfo.bCheatsEnabled);
		}
		else
		{
			winSaveInfo.SetText("");
			winSnapshot.SetBackground(None);
			winCheatsEnabled.Hide();
		}

		CriticalDelete(saveDir);
	}
}

// ----------------------------------------------------------------------
// PopulateGames()
// ----------------------------------------------------------------------

function PopulateGames()
{
	local int saveIndex;
	local DeusExSaveInfo saveInfo;
	local GameDirectory saveDir;

	lstGames.EnableAutoSort(False);
	lstGames.DeleteAllRows();

	saveDir = GetSaveGameDirectory();

	// First check to see if the QuickLoad game exists
	saveInfo = saveDir.GetSaveInfo(-1);

	if (saveInfo != None)
	{	
		AddSaveRow(saveInfo, -1);
		saveDir.DeleteSaveInfo(saveInfo);
	}

	// Loop through all the files and strip off the filename
	// extension

	for( saveIndex=0; saveIndex<saveDir.GetDirCount(); saveIndex++)
	{
		saveInfo = saveDir.GetSaveInfoFromDirectoryIndex(saveIndex);

		if (saveInfo == None)
		{
			lstGames.AddRow(SaveInfoMissing_Label $ ";;;;-2");
		}
		else
		{
			AddSaveRow(saveInfo, saveIndex);
			saveDir.DeleteSaveInfo(saveInfo);
		}
	}

	// Sort the maps by Date
	lstGames.EnableAutoSort(True);

	CriticalDelete(saveDir);

	EnableButtons();
}

// ----------------------------------------------------------------------
// AddSaveRow()
// ----------------------------------------------------------------------

function AddSaveRow(DeusExSaveInfo saveInfo, int saveIndex)
{
	if (saveInfo != None)
	{
		lstGames.AddRow( saveInfo.Description              $ ";" $ 
						 BuildTimeStringFromInfo(saveInfo) $ ";" $ 
						 BuildTimeJulian(saveInfo)         $ ";" $ 
						 BuildTimeStringFromInfo(saveInfo) $ ";" $
						 String(saveInfo.DirectoryIndex));
	}
}

// ----------------------------------------------------------------------
// EnableButtons()
//
// Checks the state of the list control and updates the pushbuttons
// appropriately
// ----------------------------------------------------------------------

function EnableButtons()
{
	EnableActionButton(AB_Other, (lstGames.GetNumSelectedRows() > 0), "LOAD");

	// Cannot delete rows that have a saveindex < 0
	if ((lstGames.GetNumSelectedRows() > 0) && (Int(lstGames.GetField(lstGames.GetSelectedRow(), 4)) >= 0))
		EnableActionButton(AB_Other, True,  "DELETE");
	else
		EnableActionButton(AB_Other, False, "DELETE");
}

// ----------------------------------------------------------------------
// ProcessAction()
//
// Meant to be called in derived class
// ----------------------------------------------------------------------

function ProcessAction(String actionKey)
{
	if (actionKey == "LOAD")
	{
		if (IsKeyDown(IK_Enter))
		{
			loadGameRowId = lstGames.GetSelectedRow();
			bLoadGamePending = True;
		}
		else
		{		
			LoadGame(lstGames.GetSelectedRow());
		}
	}
	else if (actionKey == "DELETE")
	{
		// Only confirm 
		if (chkConfirmDelete.GetToggle())
			ConfirmDeleteGame(lstGames.GetSelectedRow());
		else
			DeleteGame(lstGames.GetSelectedRow());
	}
}

// ----------------------------------------------------------------------
// LoadGame()
// ----------------------------------------------------------------------

function LoadGame(int rowId)
{
	local DeusExPlayer localPlayer;
	local int gameIndex;

	localPlayer = player;

	gameIndex = int(lstGames.GetField(rowId, 4));

	localPlayer.LoadGame(gameIndex);
}

// ----------------------------------------------------------------------
// DeleteGame()
// ----------------------------------------------------------------------

function DeleteGame(int rowId)
{
	local int rowIndex;

	player.ConsoleCommand("DeleteGame " $ int(lstGames.GetField(rowID, 4)));

	// Get the row index so we can highlight it after we delete this item
	rowIndex = lstGames.RowIdToIndex(rowID);

	// Delete the row
	lstGames.DeleteRow(rowID);

	// Attempt to highlight the next row
	if ( lstGames.GetNumRows() > 0 )
	{
		if ( rowIndex >= lstGames.GetNumRows() )
			rowIndex = lstGames.GetNumRows() - 1;
		
		rowID = lstGames.IndexToRowId(rowIndex);

		lstGames.SetRow(rowID);
	}

	UpdateFreeDiskSpace();

	EnableButtons();
}

// ----------------------------------------------------------------------
// ConfirmDeleteGame()
// ----------------------------------------------------------------------

function ConfirmDeleteGame(int rowId)
{
	saveRowId = rowId;
	msgBoxMode = MB_Delete;
	root.MessageBox(DeleteTitle, DeletePrompt, 0, False, Self);
}

// ----------------------------------------------------------------------
// BoxOptionSelected()
// ----------------------------------------------------------------------

event bool BoxOptionSelected(Window msgBoxWindow, int buttonNumber)
{
	local string newName;

	// Destroy the msgbox!  
	root.PopWindow();

	switch(msgBoxMode)
	{
		case MB_Delete:
			if ( buttonNumber == 0 )
			{
				msgBoxMode = MB_None;
				DeleteGame(saveRowId);
			}
			break;

		default:
			msgBoxMode = MB_None;
			
	}

	return true;
}

// ----------------------------------------------------------------------
// TrimSpaces()
// ----------------------------------------------------------------------

function String TrimSpaces(String trimString)
{
	local int trimIndex;
	local int trimLength;

	if ( trimString == "" ) 
		return trimString;

	trimIndex = Len(trimString) - 1;
	while ((trimIndex >= 0) && (Mid(trimString, trimIndex, 1) == " ") )
		trimIndex--;

	if ( trimIndex < 0 )
		return "";

	trimString = Mid(trimString, 0, trimIndex + 1);

	trimIndex = 0;
	while((trimIndex < Len(trimString) - 1) && (Mid(trimString, trimIndex, 1) == " "))
		trimIndex++;

	trimLength = len(trimString) - trimIndex;
	trimString = Right(trimString, trimLength);

	return trimString;
}

// ----------------------------------------------------------------------
// BuildTimeStringFromInfo()
// ----------------------------------------------------------------------

function String BuildTimeStringFromInfo(DeusExSaveInfo saveInfo)
{
	local String retValue;
	

	if ( saveInfo == None )
	{
		retValue = "DeusExLevelInfo Missing";
		retValue = "";
	}
	else
	{
		retValue = BuildTimeString(
			saveInfo.Year, saveInfo.Month, saveInfo.Day,
			saveInfo.Hour, saveInfo.Minute);
	}

	return retValue;
}

// ----------------------------------------------------------------------
// BuildElapsedTimeString()
// ----------------------------------------------------------------------

function String BuildElapsedTimeString(int seconds)
{
	local int minutes;
	local int hours;

	hours   = seconds / 3600;
	minutes = (seconds / 60) % 60;
	seconds = seconds % 60;

	return TwoDigits(hours) $ ":" $ TwoDigits(minutes) $ ":" $ TwoDigits(seconds);
}

// ----------------------------------------------------------------------
// BuildTimeString()
// ----------------------------------------------------------------------

function String BuildTimeString(
	int Year,
	int Month,
	int Day,
	int Hour,
	int Minute)
{
	local String retValue;

	retValue = TwoDigits(Month) $ "/" $ TwoDigits(Day) $ "/" $ Year $ " ";

	if (Hour > 12)
		retValue = retValue $ TwoDigits(Hour - 12);
	else if (Hour == 0)
		retValue = retValue $ "12";
	else
		retValue = retValue $ TwoDigits(Hour) ;

	retValue = retValue $ ":" $ TwoDigits(Minute);

	if (Hour > 11)
		retValue = retValue $ TimePMLabel;
	else
		retValue = retValue $ TimeAMLabel;

	return retValue;
}

// ----------------------------------------------------------------------
// TwoDigits()
// ----------------------------------------------------------------------

function String TwoDigits(int number)
{
	if ( number < 10 )
		return "0" $ number;
	else
		return String(number);
}

// ----------------------------------------------------------------------
// BuildTimeJulian()
// ----------------------------------------------------------------------

function Float BuildTimeJulian(DeusExSaveInfo saveInfo)
{
	local Float retValue;
	local Float seconds;

	if ( saveInfo == None )
	{
		retValue = 0;
	}
	else
	{
		retValue  = (saveInfo.Year - 1990) * 372;
		retValue += (saveInfo.Month * 31) + saveInfo.Day;
		retValue *= 100000;

		seconds = (saveInfo.Hour * 3600) + (saveInfo.Minute * 60) + saveInfo.Second;

		retValue += seconds;
	}

	return retValue;
}

// ----------------------------------------------------------------------
// GetSaveGameDirectory()
// ----------------------------------------------------------------------

function GameDirectory GetSaveGameDirectory()
{
	local GameDirectory saveDir;

	// Create our Map Directory class
	saveDir = player.CreateGameDirectoryObject();
	saveDir.SetDirType(saveDir.EGameDirectoryTypes.GD_SaveGames);
	saveDir.GetGameDirectory();

	return saveDir;
}

// ----------------------------------------------------------------------
// UpdateFreeDiskSpace()
// ----------------------------------------------------------------------

function UpdateFreeDiskSpace()
{
	local GameDirectory saveDir;

	saveDir = player.CreateGameDirectoryObject();
	freeDiskSpace = saveDir.GetSaveFreeSpace();
	winFreeSpace.SetText(Sprintf(FreeSpaceLabel, freeDiskSpace / 1024));

	// If free space is below the minimum, show in RED
	if ((freeDiskSpace / 1024) < minFreeDiskSpace)
		winFreeSpace.SetTextColorRGB(255, 0, 0);
	else
		winFreeSpace.StyleChanged();

	CriticalDelete(savedir);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bDateSortOrder=True
     minFreeDiskSpace=100
     strHeaderNameLabel="Name"
     strHeaderDateLabel="Date"
     NewSaveGameButtonText="New Save Game"
     DeleteGameButtonText="Delete Game"
     LoadGameButtonText="Load Game"
     OverwriteTitle="Overwrite Savegame?"
     OverwritePrompt="Are you sure you wish to overwrite this savegame?"
     DeleteTitle="Delete Savegame?"
     DeletePrompt="Are you sure you wish to delete this savegame?"
     LoadGameTitle="Load Game"
     SaveGameTitle="Save Game"
     SaveInfoMissing_Label="SAVEINFO.DXS Missing!!!"
     TimeAMLabel="am"
     TimePMLabel="pm"
     LocationLabel="Location: %s|n"
     SaveCountLabel="Save Count: %d|n"
     PlayTimeLabel="Play Time: %s|n"
     FileSizeLabel="File Size: %dMB"
     FreeSpaceLabel="Free Space: %dMB"
     ConfirmDeleteLabel="Confirm Savegame Deletion"
     CheatsEnabledLabel="- CHEATS ENABLED -"
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_Other,Text="|&Load Game",Key="LOAD")
     actionButtons(2)=(Action=AB_Other,Text="|&Delete Game",Key="DELETE")
     Title="Load Game"
     ClientWidth=552
     ClientHeight=296
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuLoadSaveBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuLoadSaveBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuLoadSaveBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuLoadSaveBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.MenuLoadSaveBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.MenuLoadSaveBackground_6'
     bUsesHelpWindow=False
     bEscapeSavesSettings=False
}
