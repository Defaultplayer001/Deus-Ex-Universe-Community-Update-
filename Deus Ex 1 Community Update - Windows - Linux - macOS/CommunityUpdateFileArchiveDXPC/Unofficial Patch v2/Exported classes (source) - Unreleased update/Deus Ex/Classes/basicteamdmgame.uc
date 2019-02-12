//=============================================================================
// TeamDeathMatch Basic Version.  All augs, all skills.
//=============================================================================
class BasicTeamDMGame expands TeamDMGame;

// ---------------------------------------------------------------------
// PreBeginPlay()
// ---------------------------------------------------------------------

function PreBeginPlay()
{
   Super.PreBeginPlay();
   ResetNonCustomizableOptions();
}

// ---------------------------------------------------------------------
// ResetNonCustomizableOptions()
// Stub for sub gametypes to keep people from changing things in the configs.
// ---------------------------------------------------------------------

function ResetNonCustomizableOptions()
{
   Super.ResetNonCustomizableOptions();

   if (!bCustomizable)
   {      
      SkillsTotal = 0;
      SkillsAvail = 0;
      SkillsPerKill = 0;
      InitialAugs = 9;
      AugsPerKill = 0;
      MPSkillStartLevel = 3;
      SaveConfig();
   }
}

defaultproperties
{
     bCustomizable=False
}
