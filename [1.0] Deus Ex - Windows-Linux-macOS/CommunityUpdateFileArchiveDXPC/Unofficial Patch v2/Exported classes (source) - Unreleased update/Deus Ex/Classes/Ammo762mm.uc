//=============================================================================
// Ammo762mm.
//=============================================================================
class Ammo762mm extends DeusExAmmo;


//
// SimUseAmmo - Spawns shell casings client side
//
simulated function bool SimUseAmmo()
{
	local vector offset, tempvec, X, Y, Z;
	local ShellCasing shell;
	local DeusExWeapon W;

	if ( AmmoAmount > 0 )
	{
		GetAxes(Pawn(Owner).ViewRotation, X, Y, Z);
		offset = Owner.CollisionRadius * X + 0.3 * Owner.CollisionRadius * Y;
		tempvec = 0.8 * Owner.CollisionHeight * Z;
		offset.Z += tempvec.Z;

		W = DeusExWeapon(Pawn(Owner).Weapon);

      if ((W != None) && ((W.NoiseLevel < 0.1) || W.bHasSilencer))
         shell = spawn(class'ShellCasingSilent',,, Owner.Location + offset);
      else
         shell = spawn(class'ShellCasing',,, Owner.Location + offset);

		shell.RemoteRole = ROLE_None;

		if (shell != None)
		{
			shell.Velocity = (FRand()*20+90) * Y + (10-FRand()*20) * X;
			shell.Velocity.Z = 0;
		}
		return True;
	}
	return False;
}

function bool UseAmmo(int AmountNeeded)
{
	local vector offset, tempvec, X, Y, Z;
	local ShellCasing shell;
	local DeusExWeapon W;

	if (Super.UseAmmo(AmountNeeded))
	{
		GetAxes(Pawn(Owner).ViewRotation, X, Y, Z);
		offset = Owner.CollisionRadius * X + 0.3 * Owner.CollisionRadius * Y;
		tempvec = 0.8 * Owner.CollisionHeight * Z;
		offset.Z += tempvec.Z;

		// use silent shells if the weapon has been silenced
		W = DeusExWeapon(Pawn(Owner).Weapon);
      if ( DeusExMPGame(Level.Game) != None )
      {
			if ( Level.NetMode == NM_ListenServer )
			{
				if ((W != None) && ((W.NoiseLevel < 0.1) || W.bHasSilencer))
					shell = spawn(class'ShellCasingSilent',,, Owner.Location + offset);
				else
					shell = spawn(class'ShellCasing',,, Owner.Location + offset);

				shell.RemoteRole = ROLE_None;
			}
			else
	         shell = None;
      }
      else
      {
         if ((W != None) && ((W.NoiseLevel < 0.1) || W.bHasSilencer))
            shell = spawn(class'ShellCasingSilent',,, Owner.Location + offset);
         else
            shell = spawn(class'ShellCasing',,, Owner.Location + offset);
      }

		if (shell != None)
		{
			shell.Velocity = (FRand()*20+90) * Y + (10-FRand()*20) * X;
			shell.Velocity.Z = 0;
		}
		return True;
	}

	return False;
}

defaultproperties
{
     bShowInfo=True
     AmmoAmount=30
     MaxAmmo=300
     ItemName="7.62x51mm Ammo"
     ItemArticle="some"
     PickupViewMesh=LodMesh'DeusExItems.Ammo762mm'
     LandSound=Sound'DeusExSounds.Generic.MetalHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconAmmo762'
     largeIconWidth=46
     largeIconHeight=34
     Description="The 7.62x51mm (NATO) round was chiefly used by anti-terrorist units equipped with assault rifles for close-quarters combat until its widespread adoption among national security forces requiring enhanced combat responsiveness made it ubiquitous."
     beltDescription="7.62 AMMO"
     Mesh=LodMesh'DeusExItems.Ammo762mm'
     CollisionRadius=6.000000
     CollisionHeight=0.750000
     bCollideActors=True
}
