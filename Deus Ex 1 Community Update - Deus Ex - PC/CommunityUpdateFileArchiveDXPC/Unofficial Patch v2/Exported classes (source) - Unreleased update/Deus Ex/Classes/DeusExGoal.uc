//=============================================================================
// DeusExGoal
//
// An individual goal the player can accomplish throughout the game. 
// Goals fall into two categories, "Primary" and "Secondary".  Primary 
// goals must be accomplished, the game cannot be finished otherwise.
// Secondary goals are optional and not critical to successful completion
// of the game. 
// 
// TODO: "goalName" should probably be eliminated and we should just use the 
// base object's name as the Goal name!  This makes it easier to track the 
// goal down and cuts down on another variable in this class.
//
//=============================================================================

class DeusExGoal expands Object;

var travel Name goalName;			// Goal name, "GOAL_somestring"
var travel String text;				// Actual goal text
var travel Bool bPrimaryGoal;		// True if Primary Goal
var travel Bool bCompleted;			// True if Completed
var travel DeusExGoal next;			// Next goal


// ----------------------------------------------------------------------
// SetName()
// ----------------------------------------------------------------------

function SetName( Name newGoalName )
{
	goalName = newGoalName;
}

// ----------------------------------------------------------------------
// SetText()
// ----------------------------------------------------------------------

function SetText( String newText )
{
	text = newText;
}

// ----------------------------------------------------------------------
// SetPrimaryGoal()
// ----------------------------------------------------------------------

function SetPrimaryGoal( Bool bNewPrimaryGoal )
{
	bPrimaryGoal = bNewPrimaryGoal;
}

// ----------------------------------------------------------------------
// IsPrimaryGoal()
// ----------------------------------------------------------------------

function bool IsPrimaryGoal()
{
	return bPrimaryGoal;
}

// ----------------------------------------------------------------------
// SetCompleted()
// 
// Marks a goal as completed.
// ----------------------------------------------------------------------

function SetCompleted()
{
	bCompleted = True;
}

// ----------------------------------------------------------------------
// IsCompleted()
//
// Returns whether or not a goal has already been marked as completed.
// ----------------------------------------------------------------------

function bool IsCompleted()
{
	return bCompleted;
}

defaultproperties
{
}
