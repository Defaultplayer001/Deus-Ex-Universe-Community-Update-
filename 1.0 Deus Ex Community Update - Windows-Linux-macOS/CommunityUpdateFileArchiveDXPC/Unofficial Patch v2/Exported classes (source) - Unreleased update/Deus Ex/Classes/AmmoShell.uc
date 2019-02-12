//=============================================================================
// AmmoShell.
//=============================================================================
class AmmoShell extends DeusExAmmo;


//
// SimUseAmmo - Spawns shell casings client side
//
simulated function bool SimUseAmmo()
{
	local vector offset, tempvec, X, Y, Z;
	local ShellCasing2 shell;

	if ( AmmoAmount > 0 )
	{
		GetAxes(Pawn(Owner).ViewRotation, X, Y, Z);
		offset = Owner.CollisionRadius * X + 0.3 * Owner.CollisionRadius * Y;
		tempvec = 0.8 * Owner.CollisionHeight * Z;
		offset.Z += tempvec.Z;

		shell = spawn(class'ShellCasing2',,, Owner.Location + offset);
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
	local ShellCasing2 shell;

	if (Super.UseAmmo(AmountNeeded))
	{
		GetAxes(Pawn(Owner).ViewRotation, X, Y, Z);
		offset = Owner.CollisionRadius * X + 0.3 * Owner.CollisionRadius * Y;
		tempvec = 0.8 * Owner.CollisionHeight * Z;
		offset.Z += tempvec.Z;
      if ( DeusExMPGame(Level.Game) != None )
      {
			if ( Level.NetMode == NM_ListenServer )
			{
	         shell = spawn(class'ShellCasing2',,, Owner.Location + offset);
				shell.RemoteRole = ROLE_None;
			}
			else
	         shell = None;
      }
      else
      {
         shell = spawn(class'ShellCasing2',,, Owner.Location + offset);
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
     AmmoAmount=12
     MaxAmmo=96
     ItemName="12 Gauge Buckshot Shells"
     ItemArticle="some"
     PickupViewMesh=LodMesh'DeusExItems.AmmoShell'
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoShells'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoShells'
     largeIconWidth=34
     largeIconHeight=45
     Description="Standard 12 gauge shotgun shell; very effective for close-quarters combat against soft targets, but useless against body armor."
     beltDescription="BUCKSHOT"
     Mesh=LodMesh'DeusExItems.AmmoShell'
     CollisionRadius=9.300000
     CollisionHeight=10.210000
     bCollideActors=True
}
