class AlignWindow extends Window;

var float   childSpacing;
var EVAlign childVAlign;

// ----------------------------------------------------------------------
// ComputeChildSizes()
// ----------------------------------------------------------------------

function ComputeChildSizes(bool bWidthSpecified, out float preferredWidth,
                           bool bHeightSpecified, out float preferredHeight)
{
	local float  totalWidth;
	local float  maxHeight;
	local Window child;
	local Window nextChild;

	totalWidth = 0;
	maxHeight  = 0;

	child = GetBottomChild();
	while (child != None)
	{
		nextChild = child.GetHigherSibling();

		child.holdX = totalWidth;
		child.holdY = 0;
		if (nextChild == None)  // last child
		{
			if (bWidthSpecified)
			{
				child.holdWidth  = preferredWidth - totalWidth;
				child.holdHeight = child.QueryPreferredHeight(child.holdWidth);
			}
			else
				child.QueryPreferredSize(child.holdWidth, child.holdHeight);
		}
		else
		{
			child.QueryPreferredSize(child.holdWidth, child.holdHeight);
			totalWidth += childSpacing;
		}

		totalWidth += child.holdWidth;
		if (maxHeight < child.holdHeight)
			maxHeight = child.holdHeight;

		child = nextChild;
	}

	if (bHeightSpecified)
		maxHeight = preferredHeight;

	child = GetBottomChild();
	while (child != None)
	{
		if      (childVAlign == VALIGN_Top)
			child.holdY = 0;
		else if (childVAlign == VALIGN_Center)
			child.holdY = (maxHeight - child.holdHeight)/2.0;
		else if (childVAlign == VALIGN_Bottom)
			child.holdY = maxHeight - child.holdHeight;
		else if (childVAlign == VALIGN_Full)
		{
			child.holdY      = 0;
			child.holdHeight = maxHeight;
		}

		child = child.GetHigherSibling();
	}

	if (!bWidthSpecified)
		preferredWidth  = totalWidth;
	if (!bHeightSpecified)
		preferredHeight = maxHeight;
}

// ----------------------------------------------------------------------
// ParentRequestedPreferredSize()
// ----------------------------------------------------------------------

event ParentRequestedPreferredSize(bool bWidthSpecified, out float preferredWidth,
                                   bool bHeightSpecified, out float preferredHeight)
{
	ComputeChildSizes(bWidthSpecified, preferredWidth, bHeightSpecified, preferredHeight);
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	local float  tempWidth, tempHeight;
	local Window child;

	// just for safety
	tempWidth  = width;
	tempHeight = height;
	ComputeChildSizes(true, tempWidth, true, tempHeight);

	child = GetBottomChild();
	while (child != None)
	{
		child.ConfigureChild(child.holdX, child.holdY, child.holdWidth, child.holdHeight);
		child = child.GetHigherSibling();
	}
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

event bool ChildRequestedReconfiguration(window childWin)
{
	return False;
}

// ----------------------------------------------------------------------
// SetChildSpacing()
// ----------------------------------------------------------------------

function SetChildSpacing(float newChildSpacing)
{
	if (childSpacing != newChildSpacing)
	{
		childSpacing = newChildSpacing;
		AskParentForReconfigure();
	}
}

// ----------------------------------------------------------------------
// SetChildVAlignment()
// ----------------------------------------------------------------------

function SetChildVAlignment(EVAlign newChildVAlign)
{
	if (childVAlign != newChildVAlign)
	{
		childVAlign = newChildVAlign;
		AskParentForReconfigure();
	}
}

defaultproperties
{
}
