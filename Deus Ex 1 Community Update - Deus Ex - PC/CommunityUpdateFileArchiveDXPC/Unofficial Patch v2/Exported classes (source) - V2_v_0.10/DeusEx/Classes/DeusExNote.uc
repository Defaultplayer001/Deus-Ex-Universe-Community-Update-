//=============================================================================
// DeusExNote
//=============================================================================
class DeusExNote extends Object;

var travel String text;				// Note text stored here.

var travel Bool bUserNote;			// True if this is a user-entered note
var travel DeusExNote next;			// Next note

// Text tag, used for DataCube notes to prevent 
// the same note fromgetting added more than once
var travel Name textTag;			

// ----------------------------------------------------------------------
// SetUserNote()
// ----------------------------------------------------------------------

function SetUserNote( Bool bNewUserNote )
{
	bUserNote = bNewUserNote;
}

// ----------------------------------------------------------------------
// SetTextTag()
// ----------------------------------------------------------------------

function SetTextTag( Name newTextTag )
{
	textTag = newTextTag;
}

defaultproperties
{
}
