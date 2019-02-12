//=============================================================================
// DataVaultImage
//=============================================================================
class DataVaultImage extends Inventory
	abstract;

var Texture         imageTextures[4];
var Int				sizeX;
var Int				sizeY;
var localized String			imageDescription;
var localized String			floorDescription;
var Int				sortKey;

var travel DataVaultImageNote	firstNote;
var travel DataVaultImage		prevImage;
var travel DataVaultImage		nextImage;
var travel Bool					bPlayerViewedImage;

var Color			colNoteTextNormal;
var Color			colNoteTextFocus;
var Color			colNoteBackground;

// ----------------------------------------------------------------------
// UnloadTextures()
//
// Unload texture memory used by the image
// ----------------------------------------------------------------------

function UnloadTextures(DeusExPlayer player)
{
	local int texIndex;

	for(texIndex=0; texIndex<arrayCount(imageTextures); texIndex++)
		player.UnloadTexture(imageTextures[texIndex]);
}

// ----------------------------------------------------------------------
// SpawnCopy()
// ----------------------------------------------------------------------

function inventory SpawnCopy( Pawn Other )
{
	local Inventory Copy;

	Copy = Super.SpawnCopy(Other);

	return Copy;
}

// ----------------------------------------------------------------------
// AddNote()
//
// Adds a note to the list of notes
// ----------------------------------------------------------------------

function AddNote(DataVaultImageNote newNote)
{
	// Insert this note at the beginning

	newNote.nextNote = firstNote;
	firstNote        = newNote;
}

// ----------------------------------------------------------------------
// DeleteNote()
//
// Deletes the note passed in and removes it from the chain
// ----------------------------------------------------------------------

function DeleteNote(DataVaultImageNote deleteNote)
{
	local DataVaultImageNote note;
	local DataVaultImageNote prevNote;

	note = firstNote;

	while( note != None )
	{
		if ( note == deleteNote )
		{
			// Update the links and then delete the offending note
			if (firstNote == deleteNote)
				firstNote = deleteNote.nextNote;

			if ( prevNote != None )
				prevNote.nextNote = note.nextNote;

			CriticalDelete(deleteNote);
			deleteNote = None;
			break;
		}
		prevNote = note;
		note = note.nextNote;
	}
}

// ----------------------------------------------------------------------
// Frob()
// ----------------------------------------------------------------------

auto state Pickup
{
	function Frob(Actor Other, Inventory frobWith)
	{
		if ( DeusExPlayer(Other) != None )
		{
			bHidden = True;
			DeusExPlayer(Other).AddImage(Self);
		}
		Super.Frob(Other, frobWith);
	}

}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     SizeX=400
     SizeY=400
     colNoteTextNormal=(R=200,G=200)
     colNoteTextFocus=(R=255,G=255)
     bDisplayableInv=False
     bRotatingPickup=False
     PickupMessage="Image added to DataVault"
     PlayerViewMesh=LodMesh'DeusExItems.TestBox'
     PickupViewMesh=LodMesh'DeusExItems.TestBox'
     ThirdPersonMesh=LodMesh'DeusExItems.TestBox'
     Icon=Texture'DeusExUI.Icons.BeltIconDataImage'
     beltDescription="IMAGE"
     Mesh=LodMesh'DeusExItems.TestBox'
     CollisionRadius=15.000000
     CollisionHeight=1.420000
     bCollideActors=False
     Mass=10.000000
     Buoyancy=11.000000
}
