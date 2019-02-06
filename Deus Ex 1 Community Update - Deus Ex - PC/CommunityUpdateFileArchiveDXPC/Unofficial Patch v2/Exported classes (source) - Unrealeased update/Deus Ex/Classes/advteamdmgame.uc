//=============================================================================
// TeamDeathMatch Advanced Version.  Few augs, no skills, kill bonuses.
//=============================================================================
class AdvTeamDMGame expands TeamDMGame;

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
      // DEUS_EX AMSD Values set by hand because otherwise it just loads the config settings.
      SkillsTotal = 2000;
      SkillsAvail = 2000;
      SkillsPerKill = 2000;
      InitialAugs = 2;
      AugsPerKill = 2;
      MPSkillStartLevel = 1;
      SaveConfig();
   }
}

defaultproperties
{
     bCustomizable=False
}
