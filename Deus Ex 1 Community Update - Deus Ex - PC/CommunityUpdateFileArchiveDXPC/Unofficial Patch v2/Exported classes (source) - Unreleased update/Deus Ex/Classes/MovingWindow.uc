//=============================================================================
// MovingWindow
//=============================================================================

class MovingWindow extends Window;

var Window winToShow;
var Int startPosX;
var Int startPosY;
var Int endPosX;							// Final position
var Int endPosY;	
var Int curPosX;
var Int curPosY;					
var Float lastMoveX;
var Float lastMoveY;
var Int moveRate;							// Pixel move rate / sec.

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetBackgroundStyle(DSTY_Masked);

	Hide();
}


// ----------------------------------------------------------------------
// Tick()
// ---------------------------------------------------------------------

function Tick(float deltaTime)
{
/*
	log("Tick()-----------------------------------------------");
	log("  lastMoveX = " $ lastMoveX);
	log("  lastMoveY = " $ lastMoveY);
	log("  curPosX   = " $ curPosX);
	log("  curPosY   = " $ curPosY);
	log("  startPosX = " $ startPosX);
	log("  startPosY = " $ startPosY);
	log("  endPosX   = " $ endPosX);
	log("  endPosY   = " $ endPosY);
	log("  deltaTime = " $ deltaTime);
*/
	lastMoveX += deltaTime;
	lastMoveY += deltaTime;

	// Look at the current location, end location and
	// move rate and calculate what the new position should be.

	CalculateMovement(curPosX, lastMoveX, startPosX, endPosX);
	CalculateMovement(curPosY, lastMoveY, startPosY, endPosY);

	SetPos(curPosX, curPosY);
/*
	log(" ---");
	log("  lastMoveX = " $ lastMoveX);
	log("  lastMoveY = " $ lastMoveY);
	log("  curPosX   = " $ curPosX);
	log("  curPosY   = " $ curPosY);
*/
	// If we're at the final resting place, end this.
	if ((curPosX == endPosX) && (curPosY == endPosY))
		MoveFinished();

}

// ----------------------------------------------------------------------
// CalculateMovement()
// ----------------------------------------------------------------------

function CalculateMovement(out Int curPos, out Float lastMoveTime, Int StartPos, Int endPos)
{
	local Float pixelsToMove;

	pixelsToMove = moveRate * lastMoveTime;

	if (pixelsToMove > 1)
	{
		if (endPos < startPos)
			curPos = Max(curPos - Int(pixelsToMove), endPos);
		else
			curPos = Min(curPos + Int(pixelsToMove), endPos);

//		lastMoveTime = (pixelsToMove - Int(PixelsToMove)) * moveRate;
		lastMoveTime = 0;
	}
}

// ----------------------------------------------------------------------
// MoveFinished()
// ----------------------------------------------------------------------

function MoveFinished()
{
	if (winToShow != None)
		winToShow.Show();

	Destroy();
}

// ----------------------------------------------------------------------
// SetCoordinates()
// ----------------------------------------------------------------------

function SetCoordinates(
	int newStartPosX, 
	int newStartPosY, 
	int newEndPosX, 
	int newEndPosY)
{
	startPosX	= newStartPosX;
	startPosY	= newStartPosY;
	endPosX		= newEndPosX;
	endPosY		= newEndPosY;	
}

// ----------------------------------------------------------------------
// SetImage()
// ----------------------------------------------------------------------

function SetImage(Texture anImage, int imageSizeX, int imageSizeY)
{
	SetBackground(anImage);
	SetSize(imageSizeX, imageSizeY);
}

// ----------------------------------------------------------------------
// StartMove()
// ----------------------------------------------------------------------

function StartMove()
{
	bTickEnabled = True;

	curPosX = startPosX;
	curPosY = startPosY;

	SetPos(curPosX, curPosY);

	Show();
}

// ----------------------------------------------------------------------
// SetWindowToShow()
// ----------------------------------------------------------------------

function SetWindowToShow(window aNewWindowToShow)
{
	winToShow = aNewWindowToShow;

	if (winToShow != None)
		winToShow.Hide();
}

// ----------------------------------------------------------------------
// SetMoveRate()
// ----------------------------------------------------------------------

function SetMoveRate(Int newMoveRate)
{
	moveRate = newMoveRate;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     moveRate=1000
}
