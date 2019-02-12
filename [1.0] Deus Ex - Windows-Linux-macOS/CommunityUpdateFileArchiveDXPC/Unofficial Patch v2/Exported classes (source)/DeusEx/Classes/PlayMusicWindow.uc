//=============================================================================
// PlayMusicWindow
//=============================================================================
class PlayMusicWindow expands ToolWindow;

// Windows 
var RadioBoxWindow      radSongType;
var Window              winSongType;
var ToolListWindow		lstSongs;
var ToolButtonWindow	btnPlay;    
var ToolButtonWindow	btnClose;  

var ToolRadioButtonWindow	btnAmbient;
var ToolRadioButtonWindow	btnCombat;
var ToolRadioButtonWindow	btnConversation;
var ToolRadioButtonWindow	btnOutro;
var ToolRadioButtonWindow	btnDying;

// list of songs
var String songList[35];
var String songNames[35];

// Current song playing
var int savedSongSection;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Center this window	
	SetSize(370, 430);
	SetTitle("Play Song");

	// Create the controls
	CreateControls();
	PopulateSongsList();

	// Save current song playing
	savedSongSection = player.SongSection;
}

// ----------------------------------------------------------------------
// DestroyWindow()
// ----------------------------------------------------------------------

event DestroyWindow()
{
	// Shut down the music
	player.ClientSetMusic(player.Level.Song, savedSongSection, 255, MTRAN_FastFade);
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	// Songslist box
	CreateSongsList();

	// Create a RadioBox window for the boolean radiobuttons
	radSongType = RadioBoxWindow(NewChild(Class'RadioBoxWindow'));
	radSongType.SetPos(280, 65);
	radSongType.SetSize(100, 130);
	winSongType = radSongType.NewChild(Class'Window');

	btnAmbient = ToolRadioButtonWindow(winSongType.NewChild(Class'ToolRadioButtonWindow'));
	btnAmbient.SetText("|&Ambient");
	btnAmbient.SetPos(0, 0);

	btnCombat = ToolRadioButtonWindow(winSongType.NewChild(Class'ToolRadioButtonWindow'));
	btnCombat.SetText("Co|&mbat");
	btnCombat.SetPos(0, 20);

	btnConversation = ToolRadioButtonWindow(winSongType.NewChild(Class'ToolRadioButtonWindow'));
	btnConversation.SetText("Co|&nvo");
	btnConversation.SetPos(0, 40);

	btnOutro = ToolRadioButtonWindow(winSongType.NewChild(Class'ToolRadioButtonWindow'));
	btnOutro.SetText("|&Outro");
	btnOutro.SetPos(0, 60);

	btnDying = ToolRadioButtonWindow(winSongType.NewChild(Class'ToolRadioButtonWindow'));
	btnDying.SetText("|&Dying");
	btnDying.SetPos(0, 80);

	btnAmbient.SetToggle(True);

	// Buttons
	btnPlay  = CreateToolButton(280, 362, "Play |&Song");
	btnClose = CreateToolButton(280, 387, "|&Close");
}

// ----------------------------------------------------------------------
// CreateSongsList()
// ----------------------------------------------------------------------

function CreateSongsList()
{
	// Now create the List Window
	lstSongs = CreateToolList(15, 38, 255, 372);
	lstSongs.EnableMultiSelect(False);
	lstSongs.EnableAutoExpandColumns(True);
	lstSongs.SetColumns(2);
	lstSongs.HideColumn(1);
}

// ----------------------------------------------------------------------
// PopulateSongsList()
// ----------------------------------------------------------------------

function PopulateSongsList()
{
	local int songIndex;

	lstSongs.DeleteAllRows();

	for( songIndex=0; songIndex<arrayCount(songList); songIndex++)
		lstSongs.AddRow(songList[songIndex] $ ";" $ songNames[songIndex]);

	// Sort the maps by name
	lstSongs.Sort();

	EnableButtons();
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
		case btnPlay:
			PlaySong(lstSongs.GetSelectedRow());
			break;

		case btnClose:
			root.PopWindow();
			break;

		default:
			bHandled = False;
			break;
	}

	if ( !bHandled ) 
		bHandled = Super.ButtonActivated( buttonPressed );

	return bHandled;
}

// ----------------------------------------------------------------------
// ListSelectionChanged() 
//
// When the user clicks on an item in the list, update the buttons
// appropriately
// ----------------------------------------------------------------------

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
	EnableButtons();

	return true;
}

// ----------------------------------------------------------------------
// ListRowActivated()
// ----------------------------------------------------------------------

event bool ListRowActivated(window list, int rowId)
{
	PlaySong(rowID);
	return true;
}

// ----------------------------------------------------------------------
// PlaySong()
// ----------------------------------------------------------------------

function PlaySong(int rowID)
{
	local String songName;
	local Int songSection;

//   0 - Ambient 1
//   1 - Dying
//   2 - Ambient 2 (optional)
//   3 - Combat
//   4 - Conversation
//   5 - Outro

	if (btnAmbient.GetToggle())
		songSection = 0;
	else if (btnCombat.GetToggle())
		songSection = 3;
	else if (btnConversation.GetToggle())
		songSection = 4;
	else if (btnOutro.GetToggle())
		songSection = 5;
	else if (btnDying.GetToggle())
		songSection = 1;

	songName = lstSongs.GetField(rowID, 1);
	player.PlayMusic(songName, songSection);
}

// ----------------------------------------------------------------------
// EnableButtons()
//
// Checks the state of the list control and updates the pushbuttons
// appropriately
// ----------------------------------------------------------------------

function EnableButtons()
{
	btnPlay.SetSensitivity( lstSongs.GetNumSelectedRows() > 0 );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     songList(0)="Area51 Bunker"
     songList(1)="Area51"
     songList(2)="Battery Park"
     songList(3)="Credits"
     songList(4)="Dance Mix"
     songList(5)="Endgame 1"
     songList(6)="Endgame 2"
     songList(7)="Endgame 3"
     songList(8)="Hong Kong Club 2"
     songList(9)="Hong Kong Club"
     songList(10)="Hong Kong Canal"
     songList(11)="Hong Kong Helipad"
     songList(12)="Hong Kong"
     songList(13)="Intro"
     songList(14)="Lebedev"
     songList(15)="Liberty Island"
     songList(16)="MJ12"
     songList(17)="Naval Base"
     songList(18)="NYC Bar 2"
     songList(19)="NYC Streets 2"
     songList(20)="NYC Streets"
     songList(21)="Ocean Lab 2"
     songList(22)="Ocean Lab"
     songList(23)="Paris Cathedral"
     songList(24)="Paris Chateau"
     songList(25)="Paris Club 2"
     songList(26)="Paris Club"
     songList(27)="Quotes"
     songList(28)="Title"
     songList(29)="Training"
     songList(30)="Tunnels"
     songList(31)="UNATCO Return"
     songList(32)="UNATCO"
     songList(33)="Vandenberg"
     songList(34)="VersaLife"
     songNames(0)="Area51Bunker_Music"
     songNames(1)="Area51_Music"
     songNames(2)="BatteryPark_Music"
     songNames(3)="Credits_Music"
     songNames(4)="DeusExDanceMix_Music"
     songNames(5)="Endgame1_Music"
     songNames(6)="Endgame2_Music"
     songNames(7)="Endgame3_Music"
     songNames(8)="HKClub2_Music"
     songNames(9)="HKClub_Music"
     songNames(10)="HongKongCanal_Music"
     songNames(11)="HongKongHelipad_Music"
     songNames(12)="HongKong_Music"
     songNames(13)="Intro_Music"
     songNames(14)="Lebedev_Music"
     songNames(15)="LibertyIsland_Music"
     songNames(16)="MJ12_Music"
     songNames(17)="NavalBase_Music"
     songNames(18)="NYCBar2_Music"
     songNames(19)="NYCStreets2_Music"
     songNames(20)="NYCStreets_Music"
     songNames(21)="OceanLab2_Music"
     songNames(22)="OceanLab_Music"
     songNames(23)="ParisCathedral_Music"
     songNames(24)="ParisChateau_Music"
     songNames(25)="ParisClub2_Music"
     songNames(26)="ParisClub_Music"
     songNames(27)="Quotes_Music"
     songNames(28)="Title_Music"
     songNames(29)="Training_Music"
     songNames(30)="Tunnels_Music"
     songNames(31)="UNATCOReturn_Music"
     songNames(32)="UNATCO_Music"
     songNames(33)="Vandenberg_Music"
     songNames(34)="VersaLife_Music"
}
