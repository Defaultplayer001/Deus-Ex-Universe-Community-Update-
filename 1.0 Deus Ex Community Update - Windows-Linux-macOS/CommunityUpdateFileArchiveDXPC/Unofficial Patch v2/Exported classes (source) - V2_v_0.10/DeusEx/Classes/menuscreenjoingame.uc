//=============================================================================
// MenuScreenJoinGame (multiplayer)
//=============================================================================

class MenuScreenJoinGame expands MenuUIScreenWindow
	config;

var MenuUIChoiceButton HostButton;
var MenuUIChoiceButton JoinButton;
var MenuUIChoiceButton RefreshButton;

var localized string HeaderIPWindowLabel;
var MenuUIEditWindow IPWindow;

// Array of button text
var localized string HostButtonName;
var localized string JoinButtonName;
var localized string RefreshButtonName;
var string FilterString;

var localized string HostButtonHelpText;
var localized string JoinButtonHelpText;
var localized string RefreshButtonHelpText;

// Stuff for finding servers.

var() config string		MasterServerAddress;	// Address of the master server
var() config int		MasterServerTCPPort;	// Optional port that the master server is listening on
var() config int 		Region;					// Region of the game server
var() config int		MasterServerTimeout;
var() config string		GameName;

var MenuUIScrollAreaWindow			ServerScroll;
var MenuUIListWindow				ServerList;

var DeusExServerList PingedList;
var DeusExServerList UnPingedList;

var bool bShowFailedServers;
var bool bPingSuspend;
var bool bPingResume;
var bool bPingResumeInitial;

var MenuUIListHeaderButtonWindow	btnHeaderHostName;
var MenuUIListHeaderButtonWindow	btnHeaderMapName;
var MenuUIListHeaderButtonWindow	btnHeaderGameType;
var MenuUIListHeaderButtonWindow	btnHeaderNumPlayers;
var MenuUIListHeaderButtonWindow	btnHeaderPing;

var bool bHostNameSortOrder;
var bool bMapNameSortOrder;
var bool bGameTypeSortOrder;
var bool bNumPlayersSortOrder;
var bool bPingSortOrder;

var localized string strHostNameLabel;
var localized string strMapNameLabel;
var localized string strGameTypeLabel;
var localized string strNumPlayersLabel;
var localized string strPingLabel;

var MenuUIScrollAreaWindow GameInfoScroll;
var MenuUIListWindow GameInfoList;

var MenuUICheckboxWindow   chkShowGameTypeOne;
var MenuUICheckboxWindow   chkShowGameTypeTwo;
var MenuUICheckboxWindow   chkShowAllGameTypes;
var localized string GameTypeOneLabel;
var localized string GameTypeTwoLabel;
var localized string ShowAllGameTypesLabel;
var string GameTypeOneClassName;
var string GameTypeTwoClassName;

var globalconfig String GameClassNames[24];
var globalconfig String GamePackages[24];
var localized String GameHumanNames[24];

var bool bShowGameTypeOne;
var bool bShowGameTypeTwo;
var bool bShowAllGameTypes;

var float ClickTimer; //for double clicks
var float TimeToClick; // for double clicks
var int   ClickRowID;

var localized String FullServerWarningTitle;
var localized String FullServerWarningMessage;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	CreateJoinMenuButtons();
   CreateIPEditWindow();
   CreateGamesList();
   CreatePingLists();
   CreateHeaderButtons();
   PopulateServerList();
   CreateGameInfoList();
   CreateGameFilterBoxes();
   Query();

   bTickEnabled = Default.bTickEnabled;
}

function DestroyWindow()
{
   ShutdownLink();

   DestroyPingLists();

   UnPingedList = None;
   PingedList = None;

   Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled = True;

	switch( buttonPressed )
	{
		case HostButton:
         ProcessMenuAction(MA_MenuScreen,Class'MenuScreenHostGame');
			break;

		case JoinButton:
         HandleJoinGame();
			break;

      case RefreshButton:
         RefreshServerList();
         break;

      case btnHeaderHostName:
         bHostNameSortOrder = !bHostNameSortOrder;
         ServerList.SetSortColumn(0, bHostNameSortOrder);
         ServerList.Sort();
         break;

      case btnHeaderMapName:
         bMapNameSortOrder = !bMapNameSortOrder;
         ServerList.SetSortColumn(1, bMapNameSortOrder);
         ServerList.Sort();
         break;

      case btnHeaderGameType:
         bGameTypeSortOrder = !bGameTypeSortOrder;
         ServerList.SetSortColumn(2, bGameTypeSortOrder);
         ServerList.Sort();
         break;

      case btnHeaderNumPlayers:
         bNumPlayersSortOrder = !bNumPlayersSortOrder;
         ServerList.SetSortColumn(3, bNumPlayersSortOrder);
         ServerList.Sort();
         break;

      case btnHeaderPing:
         bPingSortOrder = !bPingSortOrder;
         ServerList.SetSortColumn(4, bPingSortOrder);
         ServerList.Sort();
         break;

		default:
			bHandled = False;
			break;
	}

	if ( !bHandled )
		bHandled = Super.ButtonActivated(buttonPressed);

	return bHandled;
}

// ----------------------------------------------------------------------
// RawKeyPressed()
// ----------------------------------------------------------------------

event bool RawKeyPressed(EInputKey key, EInputState iState, bool bRepeat)
{
	if ((key == IK_Enter) && (iState == IST_Release))
	{
      HandleJoinGame();
		return True;
	}
	else
	{
		return Super.RawKeyPressed(key,iState,bRepeat);
	}
}

// ----------------------------------------------------------------------
// FocusEnteredDescendant() : Called when a descendant window gets focus
// ----------------------------------------------------------------------

event FocusEnteredDescendant(Window enterWindow)
{
	if (enterWindow.IsA('MenuUIChoiceButton'))
	{
      if ((winHelp != None) && (MenuUIChoiceButton(enterWindow).helpText != ""))
      {
         winHelp.Show();
         winHelp.SetText(MenuUIChoiceButton(enterWindow).helpText);
      }
   }
}


// ----------------------------------------------------------------------
// FocusLeftDescendant() : Called when a descendant window loses focus
// ----------------------------------------------------------------------

event FocusLeftDescendant(Window leaveWindow)
{
	if ((winHelp != None) && (!bHelpAlwaysOn))
		winHelp.Hide();
}

// ----------------------------------------------------------------------
// TextChanged() : Called when an edit descendant window changes
// ----------------------------------------------------------------------

event bool TextChanged(Window changedWindow, bool ChangedFromDefault)
{
   if (ChangedWindow == IPWindow)
   {
      if (IPWindow.GetText() == "")
      {
         JoinButton.SetSensitivity(False);
      }
      else
      {
         JoinButton.SetSensitivity(True);
      }
      return true;
   }
   return false;
}

// ======================================================================
// Server Lookup Functions
// ======================================================================

// ----------------------------------------------------------------------
// Query()
// Stub, implement in subclass
// ----------------------------------------------------------------------

function Query()
{
}

// ---------------------------------------------------------------------
// QueryFinished()
// Stub, implement in subclass
// ---------------------------------------------------------------------

function QueryFinished(bool bSuccess, optional string ErrorMsg)
{
}

// ---------------------------------------------------------------------
// ListQueryFinished()
// ---------------------------------------------------------------------
function ListQueryFinished(UBrowserServerListFactory Fact, bool bSuccess, optional string ErrorMsg)
{
}

// ---------------------------------------------------------------------
// PingUnpingedServers()
// ---------------------------------------------------------------------
function PingUnpingedServers()
{
   local DeusExServerList CurrentServer;

   CurrentServer = UnpingedList;
   
   UnPingedList.PingServers(True,False);
}


// ---------------------------------------------------------------------
// PingFinished()
// ---------------------------------------------------------------------

function PingFinished()
{
   return;
}

// ---------------------------------------------------------------------
// ShutdownLink()
// Stub, implement in subclass
// ---------------------------------------------------------------------

function ShutdownLink()
{
}

// --------------------------------------------------------------------
// CreatePingLists()
// --------------------------------------------------------------------

function CreatePingLists()
{
   if (UnpingedList == None)
      UnpingedList = New(None) class'DeusExServerList';

   UnpingedList.Owner = Self;
   UnpingedList.SetupSentinel(False);
   
   if (PingedList == None)
      PingedList = New(None) class'DeusExServerList';

   PingedList.Owner = Self;
   PingedList.SetupSentinel(True);
}

// --------------------------------------------------------------------
// DestroyPingLists()
// --------------------------------------------------------------------

function DestroyPingLists()
{
	if(UnpingedList != None)
   {
		UnpingedList.DestroyList();
   }

   if(PingedList != None)
   {
		PingedList.DestroyList();
   }
}

// --------------------------------------------------------------------
// FoundServer()
// --------------------------------------------------------------------

function FoundServer(string IP, int QueryPort, string Category, string GameName, optional string HostName)
{
	local DeusExServerList NewListEntry;

	NewListEntry = UnPingedList.FindExistingServer(IP, QueryPort);

   if (NewListEntry == None)
      NewListEntry = PingedList.FindExistingServer(IP, QueryPort);

	// Don't add if it's already in the existing list
	if(NewListEntry == None)
	{
		// Add it to the server list(s)
		NewListEntry = New(None) class'DeusExServerList';

		NewListEntry.IP = IP;
		NewListEntry.QueryPort = QueryPort;

		NewListEntry.Ping = 9999;
		if(HostName != "")
			NewListEntry.HostName = HostName;
		else
			NewListEntry.HostName = IP;
		NewListEntry.Category = Category;
		NewListEntry.GameName = GameName;
		NewListEntry.bLocalServer = False;

		UnPingedList.AppendItem(NewListEntry);
	}

	NewListEntry.bOldServer = False;
}

// ----------------------------------------------------------------------
// UpdateSelectionInfo()
// ----------------------------------------------------------------------

function UpdateSelectionInfo(int RowID)
{
   local string ServerIP;
   local int ServerQueryPort;
   local int ServerGamePort;
   local DeusExServerList ListEntry;

   ServerIP = ServerList.GetField(RowID,6);
   ServerQueryPort = int(ServerList.GetField(RowID,5));
   ServerGamePort = int(ServerList.GetField(RowID,7));
   if (ServerGamePort == 0)
	   IPWindow.SetText(ServerIP);
   else 
	   IPWindow.SetText(ServerIP$":"$ServerGamePort);

   ListEntry = PingedList.FindExistingServer(ServerIP,ServerQueryPort);
   if (ListEntry != None)
   {
      ListEntry.ServerStatus();
   }

   UpdateGameInfo(ListEntry);
}

// ----------------------------------------------------------------------
// UpdateGameInfo()
// ----------------------------------------------------------------------

function UpdateGameInfo(DeusExServerList ListEntry)
{
   local UBrowserRulesList CurrentRule;

   GameInfoList.DeleteAllRows();
   if (ListEntry == None)
      return;

   CurrentRule = ListEntry.RulesList;

   //skip sentinel
   if (CurrentRule != None)
      CurrentRule = UBrowserRulesList(CurrentRule.Next);

   while (CurrentRule != None)
   {
      GameInfoList.AddRow(CurrentRule.Rule$":  "$CurrentRule.Value);
      CurrentRule = UBrowserRulesList(CurrentRule.Next);
   }

}

// ----------------------------------------------------------------------
// ListSelectionChanged() 
//
// When the user clicks on an item in the list, update the game info
// appropriately
// ----------------------------------------------------------------------

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
   if ((list == ServerList) && (FocusRowID == ClickRowID) && (JoinButton.IsSensitive()))
   {
      HandleJoinGame();
      return false;
   }

	if (list == ServerList)
   {
      ClickRowID = focusRowID;
      ClickTimer = 0;
      UpdateSelectionInfo(focusRowID);
   }
	return False;
}

// ----------------------------------------------------------------------
// CreateServerList()
//
// Creates the listbox containing the deusex game servers
//
// Column 0 = Server Name
// Column 1 = Map Name
// Column 2 = Type of Game (deathmatch, team deathmatch etc)
// Column 3 = # Players
// Column 4 = Ping
// Column 5 = Port
// Column 6 = IP
// Column 7 = Game Port
// ----------------------------------------------------------------------

function CreateGamesList()
{
	ServerScroll = CreateScrollAreaWindow(winClient);

	ServerScroll.SetPos(7, 40);
	ServerScroll.SetSize(611, 188);

	ServerList = MenuUIListWindow(ServerScroll.clipWindow.NewChild(Class'MenuUIListWindow'));
	ServerList.EnableMultiSelect(False);
	ServerList.EnableAutoExpandColumns(False);

	ServerList.SetNumColumns(8);

	ServerList.SetColumnWidth(0, 225);
	ServerList.SetColumnType(0, COLTYPE_String);
	
   ServerList.SetSortColumn(0, True);
	ServerList.EnableAutoSort(True);

   ServerList.SetColumnWidth(1, 154);
	ServerList.SetColumnType(1, COLTYPE_String);

   ServerList.SetColumnWidth(2, 96);
	ServerList.SetColumnType(2, COLTYPE_String);
	
   ServerList.SetColumnWidth(3, 72);
	ServerList.SetColumnType(3, COLTYPE_String);

   ServerList.SetColumnWidth(4, 52);
   ServerList.SetColumnType(4, COLTYPE_Float, "%.0f");

   ServerList.SetColumnWidth(5, 10);
   ServerList.SetColumnType(5, COLTYPE_String);

   ServerList.HideColumn(5);

   ServerList.SetColumnWidth(6,10);
   ServerList.SetColumnType(6, COLTYPE_String);

   ServerList.HideColumn(6);

   ServerList.SetColumnWidth(7,10);
   ServerList.SetColumnType(7, COLTYPE_String);

   ServerList.HideColumn(7);
}

// ----------------------------------------------------------------------
// CreateHeaderButtons()
// ----------------------------------------------------------------------

function CreateHeaderButtons()
{
	btnHeaderHostName = CreateHeaderButton(7,  17, 224, strHostNameLabel, winClient);
	btnHeaderMapName = CreateHeaderButton(234, 17, 151, strMapNameLabel, winClient);
	btnHeaderGameType = CreateHeaderButton(388,  17, 94, strGameTypeLabel, winClient);
	btnHeaderNumPlayers = CreateHeaderButton(485, 17, 68, strNumPlayersLabel, winClient);
	btnHeaderPing = CreateHeaderButton(556,  17, 54, strPingLabel, winClient);
}

// ----------------------------------------------------------------------
// CreateGameInfoList()
// ----------------------------------------------------------------------

function CreateGameInfoList()
{
	GameInfoScroll = CreateScrollAreaWindow(winClient);

	GameInfoScroll.SetPos(144, 241);
	GameInfoScroll.SetSize(464, 85);

	GameInfoList = MenuUIListWindow(GameInfoScroll.clipWindow.NewChild(Class'MenuUIListWindow'));
	GameInfoList.EnableMultiSelect(False);
	GameInfoList.EnableAutoExpandColumns(False);

	GameInfoList.SetNumColumns(1);

	GameInfoList.SetColumnWidth(0, 345);
	GameInfoList.SetColumnType(0, COLTYPE_String);
	GameInfoList.EnableAutoSort(False);

   GameInfoList.SetSensitivity(False);
}

// ----------------------------------------------------------------------
// CreateGameFilterBoxes()
// ----------------------------------------------------------------------

function CreateGameFilterBoxes()
{
	chkShowGameTypeOne = MenuUICheckboxWindow(winClient.NewChild(Class'MenuUICheckboxWindow'));

	chkShowGameTypeOne.SetPos(154, 333);
	chkShowGameTypeOne.SetText(GameTypeOneLabel);
	chkShowGameTypeOne.SetFont(Font'FontMenuSmall');
	chkShowGameTypeOne.SetToggle(bShowGameTypeOne);

   chkShowGameTypeTwo = MenuUICheckboxWindow(winClient.NewChild(Class'MenuUICheckboxWindow'));

	chkShowGameTypeTwo.SetPos(154, 347);
	chkShowGameTypeTwo.SetText(GameTypeTwoLabel);
	chkShowGameTypeTwo.SetFont(Font'FontMenuSmall');
	chkShowGameTypeTwo.SetToggle(bShowGameTypeTwo);

   chkShowAllGameTypes = MenuUICheckboxWindow(winClient.NewChild(Class'MenuUICheckboxWindow'));

	chkShowAllGameTypes.SetPos(154, 360);
	chkShowAllGameTypes.SetText(ShowAllGameTypesLabel);
	chkShowAllGameTypes.SetFont(Font'FontMenuSmall');
	chkShowAllGameTypes.SetToggle(bShowAllGameTypes);
}

// ----------------------------------------------------------------------
// ToggleChanged()
// ----------------------------------------------------------------------

event bool ToggleChanged(Window button, bool bNewToggle)
{	
	if (button == chkShowGameTypeOne)
	{
	  bShowGameTypeOne = bNewToggle;
	  if (bShowAllGameTypes && !bShowGameTypeOne)
	  {
		  bShowAllGameTypes = false;
		  chkShowAllGameTypes.SetToggle(bShowAllGameTypes);
	  }
      chkShowGameTypeOne.SetToggle(bShowGameTypeOne);
      PopulateServerList();
		return True;
	}
   else if (button == chkShowGameTypeTwo)
	{
	  bShowGameTypeTwo = bNewToggle;
	  if (bShowAllGameTypes && !bShowGameTypeTwo)
	  {
		  bShowAllGameTypes = false;
		  chkShowAllGameTypes.SetToggle(bShowAllGameTypes);
	  }
      chkShowGameTypeTwo.SetToggle(bShowGameTypeTwo);
      PopulateServerList();
		return True;
	}
   else if (button == chkShowAllGameTypes)
   {
      bShowAllGameTypes = bNewToggle;
      if (bShowAllGameTypes)
      {
         bShowGameTypeOne = True;
         bShowGameTypeTwo = True;
      }
      chkShowGameTypeOne.SetToggle(bShowGameTypeOne);
      chkShowGameTypeTwo.SetToggle(bShowGameTypeTwo);
      PopulateServerList();
      return True;
   }
	else
	{
		return False;
	}
}

// ----------------------------------------------------------------------
// PopulateServerList()
// ---------------------------------------------------------------------- 
function PopulateServerList()
{
   local DeusExServerList CurrentServer;
   local string ServerGameType;
   local string ServerName;
   local int ServerPing;

   ServerList.DeleteAllRows();

   CurrentServer = PingedList;
   if (CurrentServer != None)
      CurrentServer = DeusExServerList(PingedList.Next); //skip sentinel

   while (CurrentServer != None)
   {
      if (CanShowGame(CurrentServer.GameType))
      {
         ServerGameType = ConvertGameType(CurrentServer.GameType);
         ServerPing = CurrentServer.Ping;
         if (CurrentServer.HostName == "")
            ServerName = CurrentServer.IP;
         else
            ServerName = CurrentServer.HostName;
         ServerList.AddRow(ServerName$";"$CurrentServer.MapName$";"$ServerGameType$";"$CurrentServer.NumPlayers$"/"$CurrentServer.MaxPlayers$";"$ServerPing$";"$CurrentServer.QueryPort$";"$CurrentServer.IP$";"$CurrentServer.GamePort);      
      }
      CurrentServer = DeusExServerList(CurrentServer.Next);
   }
}

// ----------------------------------------------------------------------
// ConvertGameType()
// Gets human readable name version
// ----------------------------------------------------------------------
function string ConvertGameType(string GameTypeClassName)
{
   local int iClassIndex;

   for (iClassIndex = 0; iClassIndex < ArrayCount(GameClassNames); iClassIndex++)
   {
      if ((GameClassNames[iClassIndex] ~= GameTypeClassName) && (GameHumanNames[iClassIndex] != ""))
         return GameHumanNames[iClassIndex];
   }
    
   return GameTypeClassName;
}

// ----------------------------------------------------------------------
// GameTypePackage()
// Gets gametype package name
// ----------------------------------------------------------------------
function string GameTypePackage(string GameTypeClassName)
{
   local int iClassIndex;

   for (iClassIndex = 0; iClassIndex < ArrayCount(GameClassNames); iClassIndex++)
   {
      if ((GameClassNames[iClassIndex] ~= GameTypeClassName) && (GamePackages[iClassIndex] != ""))
         return GamePackages[iClassIndex];
   }
    
   return "";
}

// ----------------------------------------------------------------------
// CanShowGame()
// ----------------------------------------------------------------------
function bool CanShowgame(string GameTypeClassName)
{
   local Class<GameInfo> GameClass;
   local GameInfo RemoteGame;
   local Class<GameInfo> TestClass;
   local GameInfo TestGame;
   local string GameLoadString;
   local string TypePackage;

   if (bShowAllGameTypes)
      return True;

   TypePackage = GameTypePackage(GameTypeClassName);
   if (TypePackage != "")
	   GameLoadString = TypePackage $ "." $ GameTypeClassName;
   else
	   GameLoadString = GameTypeClassName;

   GameClass = class<GameInfo>( Player.DynamicLoadObject( GameLoadString, class'Class', true) );
   if (GameClass == None)
      return false;

   RemoteGame = Player.Spawn(GameClass);

   if (RemoteGame == None)
      return false;

   // Test gametype one
   TestClass = class<GameInfo>( Player.DynamicLoadObject( "DeusEx." $ GameTypeOneClassName, class'Class', true) );
   if (TestClass != None)
   {
      if (RemoteGame.IsA(TestClass.Name))
      {
         RemoteGame.Destroy();
         return bShowGameTypeOne;
      }
   }

   TestClass = class<GameInfo>( Player.DynamicLoadObject( "DeusEx." $ GameTypeTwoClassName, class'Class', true) );
   if (TestClass != None)
   {
      if (RemoteGame.IsA(TestClass.Name))
      {
         RemoteGame.Destroy();
         return bShowGameTypeTwo;
      }
   }
  
   RemoteGame.Destroy();
   return false;
}

// ----------------------------------------------------------------------
// RefreshServerList()
// ----------------------------------------------------------------------
function RefreshServerList()
{
   ShutdownLink();
   DestroyPingLists();
   CreatePingLists();
   PopulateServerList();
   Query();
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------
function Tick(float Delta)
{
	PingedList.Tick(Delta);

   ClickTimer += Delta;

   if (ClickTimer > TimeToClick)
   {
      ClickRowID = -1;
   }

	if(PingedList.bNeedUpdateCount)
	{
		PingedList.UpdateServerCount();
		PingedList.bNeedUpdateCount = False;
	}

}

// ----------------------------------------------------------------------
// ListPingDone()
// ----------------------------------------------------------------------
function ListPingDone(DeusExServerList DoneList)
{
   PopulateServerList();
}

// ----------------------------------------------------------------------
// PingStatusDone()
// If the done list is the same one whose info we are trying to display,
// update it.
// ----------------------------------------------------------------------
function PingStatusDone(DeusExServerList DoneList)
{
   local string ServerIP;
   local int ServerQueryPort;
   local DeusExServerList ListEntry;

   ServerIP = ServerList.GetField(ServerList.GetFocusRow(),6);   
   ServerQueryPort = int(ServerList.GetField(ServerList.GetFocusRow(),5));

   if ((DoneList.IP == ServerIP) && (DoneList.QueryPort == ServerQueryPort))
      UpdateGameInfo(DoneList);
}

// ======================================================================
// End Server Lookup Functions
// ======================================================================

// ----------------------------------------------------------------------
// CreateJoinMenuButtons()
// ----------------------------------------------------------------------

function CreateJoinMenuButtons()
{
   //Create Host Game button
   HostButton = MenuUIChoiceButton(winClient.NewChild(Class'MenuUIChoiceButton'));
	HostButton.SetButtonText(HostButtonName);
	HostButton.SetPos(7, 239);
	HostButton.SetWidth(121);
   HostButton.SetHelpText(HostButtonHelpText);

   //Create Join Game Button
   JoinButton = MenuUIChoiceButton(winClient.NewChild(Class'MenuUIChoiceButton'));
	JoinButton.SetButtonText(JoinButtonName);
	JoinButton.SetPos(7, 267);
	JoinButton.SetWidth(121);
   JoinButton.SetHelpText(JoinButtonHelpText);
   JoinButton.SetSensitivity(False);

   //Create Refresh button
   RefreshButton = MenuUIChoiceButton(winClient.NewChild(Class'MenuUIChoiceButton'));
   RefreshButton.SetButtonText(RefreshButtonName);
   RefreshButton.SetPos(527,337);
   RefreshButton.SetWidth(83);
   RefreshButton.SetHelpText(RefreshButtonHelpText);
}

// ----------------------------------------------------------------------
// CreateIPEditWindow()
// ----------------------------------------------------------------------

function CreateIPEditWindow()
{
   //Create label
   CreateMenuLabel( 7, 322, HeaderIPWindowLabel, winClient );


   //Create edit window
	IPWindow = CreateMenuEditWindow(7, 337, 121, 24, winClient);

   IPWindow.SetText("");
	IPWindow.SetFilter(filterString);
}

// ----------------------------------------------------------------------
// HandleJoinGame()
// ----------------------------------------------------------------------

function HandleJoinGame()
{
   local string ServerIP;
   local int ServerQueryPort;
   local int ServerGamePort;
   local DeusExServerList ListEntry;
   local String FullString;

   ServerIP = ServerList.GetField(ServerList.GetFocusRow(),6);
   ServerQueryPort = int(ServerList.GetField(ServerList.GetFocusRow(),5));
   ServerGamePort = int(ServerList.GetField(ServerList.GetFocusRow(),7));

   if (ServerGamePort == 0)
	   FullString = ServerIP;
   else 
	   FullString = ServerIP$":"$ServerGamePort;

   ListEntry = PingedList.FindExistingServer(ServerIP,ServerQueryPort);
   if ((ListEntry != None) && (IPWindow.GetText() ~= FullString))
   {
	   //check max players.
      if (ListEntry.NumPlayers >= ListEntry.MaxPlayers)
	  {
		  messageBoxMode = MB_JoinGameWarning;
		  root.MessageBox(FullServerWarningTitle, FullServerWarningMessage, 0, False, Self);
		  return;
	  }

   }

   player.StartMultiplayerGame("open " $ IpWindow.GetText() $ GetExtraJoinOptions());
}

// ----------------------------------------------------------------------
// GetExtraJoinOptions()
// subclasses implement for any extra join options (like "?lan")
// ----------------------------------------------------------------------

function string GetExtraJoinOptions()
{
   return "";
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HeaderIPWindowLabel="IP Address"
     HostButtonName="Host Game"
     JoinButtonName="Join Game"
     RefreshButtonName="Refresh"
     filterString="01234567890:."
     HostButtonHelpText="Host a multiplayer game"
     JoinButtonHelpText="Join the currently selected game"
     RefreshButtonHelpText="Refresh the list of servers"
     MasterServerAddress="master0.gamespy.com"
     MasterServerTCPPort=28900
     MasterServerTimeout=10
     GameName="deusex"
     bShowFailedServers=True
     strHostNameLabel="HostName"
     strMapNameLabel="Map"
     strGameTypeLabel="Game Type"
     strNumPlayersLabel="Players"
     strPingLabel="Ping"
     GameTypeOneLabel="Show Deathmatch Games"
     GameTypeTwoLabel="Show Team Deathmatch Games"
     ShowAllGameTypesLabel="Show All Games"
     GameTypeOneClassName="Deathmatchgame"
     GameTypeTwoClassName="teamdmgame"
     GameClassNames(0)="Deathmatchgame"
     GameClassNames(1)="TeamDMGame"
     GameClassNames(2)="AdvTeamDMGame"
     GameClassNames(3)="BasicTeamDMGame"
     GamePackages(0)="DeusEx"
     GamePackages(1)="DeusEx"
     GamePackages(2)="DeusEx"
     GamePackages(3)="DeusEx"
     GameHumanNames(0)="Deathmatch"
     GameHumanNames(1)="Team Deathmatch"
     GameHumanNames(2)="Adv. Team DM"
     GameHumanNames(3)="Basic Team DM"
     bShowGameTypeOne=True
     bShowGameTypeTwo=True
     bShowAllGameTypes=True
     TimeToClick=0.200000
     FullServerWarningTitle="Server Full"
     FullServerWarningMessage="The selected server is detected as full.  Refresh list?"
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     Title="Start Multiplayer Game"
     ClientWidth=614
     ClientHeight=420
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuJoinBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuJoinBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuJoinBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuJoinBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.MenuJoinBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.MenuJoinBackground_6'
     helpPosY=378
     bTickEnabled=True
}
