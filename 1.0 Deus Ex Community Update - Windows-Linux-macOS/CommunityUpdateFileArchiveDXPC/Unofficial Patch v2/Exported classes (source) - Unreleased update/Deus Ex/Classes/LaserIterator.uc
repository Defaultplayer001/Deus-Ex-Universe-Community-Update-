//=============================================================================
// LaserIterator.
//=============================================================================
class LaserIterator extends RenderIterator
	native
	noexport;

struct sBeam
{
	var bool	bActive;
	var Vector	Location;
	var Rotator	Rotation;
	var float	Length;
	var int		numSegments;
};

var sBeam Beams[8];
var vector prevLoc, prevRand, savedLoc;
var rotator savedRot;
var int nextItem;
var Actor proxy;			// used by the C++
var bool bRandomBeam;		// used by the C++

function AddBeam(int num, Vector loc, Rotator rot, float len)
{
	if ((num >= 0) && (num < ArrayCount(Beams)))
	{
		// move the beam forward slightly to account for the drawing center
		loc += 8 * Vector(rot);
		Beams[num].bActive = True;
		Beams[num].Location = loc;
		Beams[num].Rotation = rot;
		Beams[num].Length = len;

		if (bRandomBeam)
			Beams[num].numSegments = (len / 15) + 1;
		else
			Beams[num].numSegments = (len / 16) + 1;
	}
}

function DeleteBeam(int num)
{
	if ((num >= 0) && (num < ArrayCount(Beams)))
		Beams[num].bActive = False;
}

function Init(PlayerPawn Camera)
{
	local LaserEmitter Owner;
	local int i;

	Owner = LaserEmitter(Outer);
	if (Owner != None)
	{
		MaxItems = 0;
		nextItem = 0;
		prevLoc = Owner.Location;
		prevRand = vect(0,0,0);
		savedLoc = Owner.Location;
		savedRot = Owner.Rotation;
		proxy = Owner.proxy;
		bRandomBeam = Owner.bRandomBeam;
		if (!Owner.bFrozen && !Owner.bHiddenBeam)
		{
			// set MaxItems based on length of beams
			for (i=0; i<ArrayCount(Beams); i++)
				if (Beams[i].bActive)
					MaxItems += Beams[i].numSegments;

			// make sure we render the last one
			if (MaxItems > 0)
				MaxItems++;
		}
	}
}

defaultproperties
{
}
