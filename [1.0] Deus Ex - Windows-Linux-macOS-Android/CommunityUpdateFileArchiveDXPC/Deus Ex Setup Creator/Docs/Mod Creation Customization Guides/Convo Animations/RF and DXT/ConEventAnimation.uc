//=============================================================================
// ConEventAnimation
//=============================================================================
class ConEventAnimation extends ConEvent
	native
	noexport;

var Actor eventOwner;				// Pawn who owns this event
var String eventOwnerName;			// NPC who owns event
var Name sequence;					// Animation Sequence
var byte playMode;  // Erkki: 1 = no looping, 0 = looping
var int playLength;  // Erkki: play time of animation in seconds
var Bool bFinishAnim;				// Wait until animation finishes
var bool bLoopAnim;					// Loop Animation

defaultproperties
{
}
