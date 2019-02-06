//=============================================================================
// MenuScreenAugSetup (multiplayer)
//=============================================================================

class MenuScreenAugSetup expands MenuUIScreenWindow;

var String ChosenAugs[9]; //List of chosen augs

var localized string HeaderPlayerNameLabel;
var string FilterString;

var localized string HeaderAugChosenLabel;

var MenuUIScrollAreaWindow		 ChosenScroll;

var MenuUIListWindow  ChosenAugList;

var MenuUISpecialButtonWindow btnAugUp;
var MenuUISpecialButtonWindow btnAugDown;

var MenuUIChoiceButton btnAugChoice[18];
var String ChoiceNames[18];

var int ChosenRowID;

var Name AugPrefs[9];

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

   ReadChosenAugs();

   CreateChosenList();
   PopulateChosenList();

   ChosenAugList.SetFocusRow(0);
   ChosenAugList.SelectAllRows(False);

   EnableButtons();

   winHelp.Hide();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();
      
   CreateAugChosenHeader();
   CreateAugButtons();
   CreatePriorityButtons();
}

// ----------------------------------------------------------------------
// CreateAugChosenHeader()
// ----------------------------------------------------------------------

function CreateAugChosenHeader()
{
   CreateMenuLabel( 381, 12, HeaderAugChosenLabel, winClient );
}

// ----------------------------------------------------------------------
// CreateAugButtons()
// ----------------------------------------------------------------------

function CreateAugButtons()
{
   local int iButtonIndex;
   local MenuUIChoiceButton CurButton;
   local bool bShiftRight;
   local AugmentationManager AugSys;
   local Augmentation CurAug;

   AugSys = Player.AugmentationSystem;

   if (AugSys == None)
      return;

   for (CurAug = AugSys.FirstAug; CurAug != None; CurAug = CurAug.Next)
   {
      if ((CurAug.MPConflictSlot < 1) || (CurAug.MPConflictSlot >=10))
         continue;
      iButtonIndex = (CurAug.mpConflictSlot-1) * 2;
      bShiftRight = btnAugChoice[iButtonIndex] != None;
      if (bShiftRight)
         iButtonIndex++;

      if (btnAugChoice[iButtonIndex] == None)
      {
         btnAugChoice[iButtonIndex] = MenuUIChoiceButton(winClient.NewChild(Class'MenuUIChoiceButton'));
         btnaugChoice[iButtonIndex].SetButtonText(curAug.augmentationName);
         if (iButtonIndex < 16)
         {
            if (!bShiftRight)
            {
               btnAugChoice[iButtonIndex].SetPos(6, 4 + 23 * CurAug.mpConflictSlot);
            }
            else
            {
               btnAugChoice[iButtonIndex].SetPos(172, 4 + 23 * CurAug.mpConflictSlot);
            }
         }
         else // Last button is aqualung, centered
         {
            btnAugChoice[iButtonIndex].SetPos(92, 4 + 23 * CurAug.mpConflictSlot);
         }
         btnAugChoice[iButtonIndex].SetWidth(163);
         btnAugChoice[iButtonIndex].SetHelpText(curAug.MPInfo);         
         btnAugChoice[iButtonIndex].fontButtonText = font'FontMenuSmall';

         ChoiceNames[iButtonIndex] = String(CurAug.Class.Name);
      }
   }
}

// ----------------------------------------------------------------------
// CreatePriorityButtons()
// ----------------------------------------------------------------------

function CreatePriorityButtons()
{
	btnAugUp    = CreateSpecialButton(357, 107, Texture'SecurityButtonPanUp_Normal',    Texture'SecurityButtonPanUp_Pressed');
	btnAugDown  = CreateSpecialButton(357, 127, Texture'SecurityButtonPanDown_Normal',  Texture'SecurityButtonPanDown_Pressed');
}

// ----------------------------------------------------------------------
// CreateSpecialButton()
// ----------------------------------------------------------------------

function MenuUISpecialButtonWindow CreateSpecialButton(int posX, int posY, Texture texNormal, Texture texPressed)
{
	local MenuUISpecialButtonWindow winButton;

	winButton = MenuUISpecialButtonWindow(winClient.NewChild(Class'MenuUISpecialButtonWindow'));
	winButton.SetPos(posX, posY);
	winButton.SetButtonTextures(texNormal, texPressed, texNormal, texPressed, texNormal, texPressed);

	return winButton;
}

// ----------------------------------------------------------------------
// ReadChosenAugs()
// ----------------------------------------------------------------------

function ReadChosenAugs()
{
   local int AugIndex;

   for (AugIndex = 0; AugIndex < ArrayCount(ChosenAugs); AugIndex++)
      ChosenAugs[AugIndex] = "";

   for (AugIndex = 0; ((AugIndex < ArrayCount(ChosenAugs)) && (AugIndex < ArrayCount(player.AugPrefs))); AugIndex++)
   {
      ChosenAugs[AugIndex] = string(player.AugPrefs[augIndex]);
      if (ChosenAugs[AugIndex] == "None")
         ChosenAugs[AugIndex] = "";
   }

   CompressChosenList();
}

// ----------------------------------------------------------------------
// CreateChosenList()
//
// Creates the listbox containing the augs (in order) that the user has
// selected for preferences.
// ----------------------------------------------------------------------

function CreateChosenList()
{
   ChosenScroll = CreateScrollAreaWindow(winClient);

	ChosenScroll.SetPos(390, 29);
	ChosenScroll.SetSize(134, 152);

	ChosenAugList = MenuUIListWindow(ChosenScroll.clipWindow.NewChild(Class'MenuUIListWindow'));
	ChosenAugList.EnableMultiSelect(False);
	ChosenAugList.EnableAutoExpandColumns(False);
	ChosenAugList.EnableHotKeys(False);

	ChosenAugList.SetNumColumns(1);

	ChosenAugList.SetColumnWidth(0, 140);
	ChosenAugList.SetColumnType(0, COLTYPE_String);

}

// ----------------------------------------------------------------------
// PopulateChosenList()
// ----------------------------------------------------------------------

function PopulateChosenList()
{
	local int AugIndex;

	// First erase the old list
	ChosenAugList.DeleteAllRows();

   for(AugIndex=0; AugIndex<arrayCount(ChosenAugs); AugIndex++ )
      if (ChosenAugs[AugIndex] != "")		
         ChosenAugList.AddRow(AugFamiliarName(ChosenAugs[AugIndex]));
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
   local int iButtonIndex;
   local int iChosenIndex;
   local bool bLeftChoice;

   //Turn off other buttons if no single other skill is selected.
	if ( (ChosenRowId == 0) || (!ChosenAugList.IsRowSelected(ChosenRowID)) || (ChosenAugList.IsMultiSelectEnabled()) || (ChosenAugs[ChosenAugList.RowIDToIndex(ChosenRowID)]=="") )
	{
      btnAugUp.SetSensitivity(False);
      btnAugDown.SetSensitivity(False);
	}
   else
   {
      btnAugUp.SetSensitivity(True);
      btnAugDown.SetSensitivity(True);
   }

   bLeftChoice = false;

   for (iButtonIndex=0; iButtonIndex<ArrayCount(btnAugChoice); iButtonIndex++)
   {
      SetPressedState(iButtonIndex,False);
   }

   for (iButtonIndex=0; iButtonIndex<ArrayCount(btnAugChoice); iButtonIndex++)
   {
      bLeftChoice = !bLeftChoice;
      for (iChosenIndex=0; iChosenIndex < ArrayCount(ChosenAugs); iChosenIndex++)
      {
         if ( (btnAugChoice[iButtonIndex] != None) && (ChoiceNames[iButtonIndex] == ChosenAugs[iChosenIndex]) )
         {
            SetPressedState(iButtonIndex,True);
            if (bLeftChoice)            
            {
               if (btnAugChoice[iButtonIndex+1] != None)               
                  SetPressedState(iButtonIndex+1,False);
            }
            else
            {
               if (btnAugChoice[iButtonIndex-1] != None)               
                  SetPressedState(iButtonIndex-1,False);
            }
         }
      }
   }
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
   local int iButtonIndex;

	bHandled = True;

	switch( buttonPressed )
	{
		case btnAugUp:
		   ShiftAugmentation(-1);
			break;

		case btnAugDown:
			ShiftAugmentation(1);
			break;

		default:
			bHandled = False;
			break;
	}

   for (iButtonIndex = 0; iButtonIndex<ArrayCount(btnAugChoice); iButtonIndex++)
   {
      if (buttonPressed == btnAugChoice[iButtonIndex])
      {
         HandleAugPress(iButtonIndex);
         bHandled = True;
      }
   }

	if ( !bHandled )
		bHandled = Super.ButtonActivated(buttonPressed);

	return bHandled;
}

// ----------------------------------------------------------------------
// ListSelectionChanged() 
//
// When the user clicks on an item in the list, update the screenshot
// and info box appropriately
// ----------------------------------------------------------------------

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
   if (list == ChosenAugList)
   {
      ChosenSelectionChanged(numSelections, focusRowId);
   }
	return False;
}

// ----------------------------------------------------------------------
// ChosenSelectionChanged()
// ----------------------------------------------------------------------

function ChosenSelectionChanged(int numSelections, int focusRowId)
{   
   chosenRowID = focusRowID;

   if (focusRowID == 0)
      return;

   if ((ChosenAugList.IsRowSelected(focusRowID)))
   {
      ChosenAugList.EnableMultiSelect(False);
   }

   EnableButtons();

   return;
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
// SetPressedState()
// ----------------------------------------------------------------------

function SetPressedState(int iButtonIndex, bool bPressed)
{
   local int iNewMainTexture;
   local int iNewSecondTexture;

   iNewMainTexture = 0;
   iNewSecondTexture = 1;

   if (bPressed)
   {
      iNewMainTexture = 1;
      iNewSecondTexture = 0;
   }

   if (BtnAugChoice[iButtonIndex] == None)
      return;

   btnAugChoice[iButtonIndex].Left_Textures[0].tex=btnAugChoice[iButtonIndex].default.Left_Textures[iNewMainTexture].tex;
   btnAugChoice[iButtonIndex].Left_Textures[1].tex=btnAugChoice[iButtonIndex].default.Left_Textures[iNewSecondTexture].tex;
   
   btnAugChoice[iButtonIndex].Right_Textures[0].tex=btnAugChoice[iButtonIndex].default.Right_Textures[iNewMainTexture].tex;
   btnAugChoice[iButtonIndex].Right_Textures[1].tex=btnAugChoice[iButtonIndex].default.Right_Textures[iNewSecondTexture].tex;

   btnAugChoice[iButtonIndex].Center_Textures[0].tex=btnAugChoice[iButtonIndex].default.Center_Textures[iNewMainTexture].tex;
   btnAugChoice[iButtonIndex].Center_Textures[1].tex=btnAugChoice[iButtonIndex].default.Center_Textures[iNewSecondTexture].tex;
}

// ----------------------------------------------------------------------
// IsPressed()
// ----------------------------------------------------------------------

function bool IsPressed(int iButtonIndex)
{
   return (btnAugChoice[iButtonIndex].Left_Textures[0].tex == btnAugChoice[iButtonIndex].default.Left_Textures[0].tex);
}


// ----------------------------------------------------------------------
// HandleAugPress()
// ----------------------------------------------------------------------

function HandleAugPress(int iButtonIndex)
{
   local int iChosenIndex;
   local int iUnChosenIndex;
   local int iOppositeIndex;

   iUnChosenIndex = -1;

   if ( 2 * (iButtonIndex / 2) == iButtonIndex )
      iOppositeIndex = iButtonIndex + 1;
   else
      iOppositeIndex = iButtonIndex - 1;

   iChosenIndex = FindAugInChosenList(ChoiceNames[iButtonIndex]);

   //If we just are adding aug, make sure the other side isn't pressed.
   if ((btnAugChoice[iOppositeIndex] != None) && (iChosenIndex == -1))
   {
      iUnChosenIndex = FindAugInChosenList(ChoiceNames[iOppositeIndex]);
      
      if (iUnChosenIndex != -1)
      {
         ChosenAugs[iUnChosenIndex] = "";
      }
   }

   if (iChosenIndex == -1)
   {
      if (iUnChosenIndex != -1)
         ChosenAugs[iUnChosenIndex] = ChoiceNames[iButtonIndex];
      else      
         ChosenAugs[ArrayCount(ChosenAugs) - 1] = ChoiceNames[iButtonIndex];
   }
   else
   {
      ChosenAugs[iChosenIndex] = "";
   }

   CompressChosenList();   
   PopulateChosenList();
   EnableButtons();
}

// ----------------------------------------------------------------------
// ShiftAugmentation()
// ----------------------------------------------------------------------

function ShiftAugmentation(int dir)
{
   local int AugIndex;
   local int AltAugIndex;
   local string SwapTemp;

   // Get the aug index for swapping
	AugIndex = ChosenAugList.RowIdToIndex(chosenRowID);

   AltAugIndex = AugIndex + dir;
   if (AltAugIndex < 0)
      AltAugIndex = 0;
   if (AltAugIndex >= ArrayCount(ChosenAugs))
      AltAugIndex = (ArrayCount(ChosenAugs) - 1);
   
   SwapTemp = ChosenAugs[AugIndex];
   ChosenAugs[AugIndex] = ChosenAugs[AltAugIndex];
   ChosenAugs[AltAugIndex] = SwapTemp;

   CompressChosenList();
   PopulateChosenList();
   SelectChosenAug(AltAugIndex);
}

// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------

function SaveSettings()
{
   local int AugIndex;
   local Augmentation CurAug;

   Super.SaveSettings();

   // Clear player augprefs, copy Chosen augs over
   for (AugIndex = 0; AugIndex < ArrayCount(player.AugPrefs); AugIndex++)
   {
      player.AugPrefs[AugIndex] = '';
   }

   for (AugIndex = 0; ((AugIndex < ArrayCount(ChosenAugs)) && (AugIndex < ArrayCount(player.AugPrefs))); AugIndex++)
   {
      CurAug = GetAugFromStringName(ChosenAugs[AugIndex]);
      if (CurAug != None)      
         player.AugPrefs[AugIndex] = CurAug.Class.Name;
   }

   player.SaveConfig();
}

// ----------------------------------------------------------------------
// ResetToDefaults()
// ----------------------------------------------------------------------

function ResetToDefaults()
{
   local int AugIndex;

   Super.ResetToDefaults();

   for (AugIndex = 0; AugIndex < ArrayCount(player.AugPrefs); AugIndex++)
      player.AugPrefs[AugIndex] = default.AugPrefs[AugIndex];

   player.SaveConfig();

   ReadChosenAugs();
   CompressChosenList();
   PopulateChosenList();
}

// ----------------------------------------------------------------------
// AugFamiliarName()
// ----------------------------------------------------------------------

function string AugFamiliarName(string AugStringName)
{
	local Augmentation anAug;

   if (AugStringName == "")
      return "";
   else   
   {
		anAug = GetAugFromStringName(AugStringName);
      if (anAug == None)
         return "";
      else
         return anAug.default.AugmentationName;
   }
}

// ----------------------------------------------------------------------
// GetAugFromStringName()
// ----------------------------------------------------------------------

function Augmentation GetAugFromStringName(string AugStringName)
{
   local Augmentation anAug;

   if (AugStringName == "")
      return None;

   anAug = player.AugmentationSystem.FirstAug;
   while (anAug != None)
   {
      if (AugStringName == string(anAug.Class.Name))
         break;
      anAug = anAug.next;
   }
   return anAug;
}

// ----------------------------------------------------------------------
// FindAugInChosenList()
// ----------------------------------------------------------------------
function int FindAugInChosenList(string AugName)
{
   local int AugIndex;
   local int FoundAug;

   FoundAug = -1;
   
   if (AugName == "")
      return FoundAug;

   for (AugIndex = 0; AugIndex < ArrayCount(ChosenAugs); AugIndex++)
   {
      if (AugName == ChosenAugs[AugIndex])
         FoundAug = AugIndex;
   }

   return FoundAug;
}

// ----------------------------------------------------------------------
// SelectChosenAug()
// ----------------------------------------------------------------------

function SelectChosenAug(int RealIndex)
{
   local int AugIndex;
   local int AugRowID;

   AugIndex = RealIndex;

   if (AugIndex < 0)
      AugIndex = 0;
   if (AugIndex >= ArrayCount(ChosenAugs))
      AugIndex = (ArrayCount(ChosenAugs) - 1);

   if ( ChosenAugList.GetNumRows() > 0 )
	{
		if ( AugIndex >= ChosenAugList.GetNumRows() )
			AugIndex = ChosenAugList.GetNumRows() - 1;
		
		AugRowID = ChosenAugList.IndexToRowId(AugIndex);

		ChosenAugList.SetRow(AugRowID,True);
	}      
   EnableButtons();
}

// ----------------------------------------------------------------------
// CompressChosenList()
// ----------------------------------------------------------------------

function CompressChosenList()
{
   local int TargetAugIndex;
   local int SourceAugIndex;
   local string SwapTemp;

   for (TargetAugIndex = 0; TargetAugIndex < ArrayCount(ChosenAugs); TargetAugIndex++)
   {
      if (ChosenAugs[TargetAugIndex] == "")
      {
         for (SourceAugIndex = ArrayCount(ChosenAugs) - 1; SourceAugIndex > TargetAugIndex; SourceAugIndex--)
         {
            if (ChosenAugs[SourceAugIndex] != "")
            {
               SwapTemp = ChosenAugs[TargetAugIndex];
               ChosenAugs[TargetAugIndex] = ChosenAugs[SourceAugIndex];
               ChosenAugs[SourceAugIndex] = SwapTemp;
            }            
         }
      }
   }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     filterString="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890[]()"
     HeaderAugChosenLabel="Augmentation Priorities"
     AugPrefs(0)=AugVision
     AugPrefs(1)=AugHealing
     AugPrefs(2)=AugSpeed
     AugPrefs(3)=AugDefense
     AugPrefs(4)=AugBallistic
     AugPrefs(5)=AugShield
     AugPrefs(6)=AugEMP
     AugPrefs(7)=AugStealth
     AugPrefs(8)=AugAqualung
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_Reset)
     actionButtons(2)=(Action=AB_OK)
     Title="Multiplayer Augmentation Setup"
     ClientWidth=537
     ClientHeight=311
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuAugsBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuAugsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuAugsBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuAugsBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.MenuAugsBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.MenuAugsBackground_6'
     helpPosY=251
}
