//=============================================================================
// SpinningLogoWindow
//=============================================================================
class SpinningLogoWindow extends Window;

var Font  logoFont;
var Int   dxLogoFrame;
var Float dxLogoTimer;
var Int   dxLogoMaxFrames;
var Float colorTimer;
var Int   colorValue;

var float gravity;
var float verticalDir;
var float horizontalDir;
var Color colLogo;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(32, 32);

	colorValue = Rand(256);

	bTickEnabled = True;
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

function DrawWindow(GC gc)
{
	gc.SetFont(logoFont);
	gc.SetTextColor(colLogo);
	gc.DrawText(0, 0, 32, 32, Chr(Asc("0") + dxLogoFrame));
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	local float newX, newY;
	local float loss;
	local float r, g, b;
	local float fColorValue;

	dxLogoTimer	-= deltaTime;

	if (dxLogoTimer < 0.0)
	{	
		dxLogoTimer = Default.dxLogoTimer;
		dxLogoFrame = ((dxLogoFrame + 1) % dxLogoMaxFrames);
	}

	colorTimer -= deltaTime;

	if (colorTimer < 0.0)
	{
		colorTimer = Default.colorTimer;
		colorValue = ((colorValue + 1) % 256);
		fColorValue = (Float(colorValue) / 256.0);

		HSLToRGB(fColorValue, 0.7, 0.7, r, g, b);

		colLogo.r = Int(r * 256) - 1;
		colLogo.g = Int(g * 256) - 1;
		colLogo.b = Int(b * 256) - 1;
	}

	// Now update the location
	// (1.0=perfectly elastic, <1.0=lossy, >1.0=*increases* energy w/each bounce)

	loss = 1.0;  
	
	newX = x + horizontalDir * deltaTime;

	if (newX > winParent.width-width)
	{
		newX = 2*(winParent.width-width) - newX;
		horizontalDir = -horizontalDir;
	}
	else if (newX < 0)
	{
		newX = -newX;
		horizontalDir = -horizontalDir;
	}

	newY = y + verticalDir * deltaTime;

	if (newY > winParent.height-height)
	{
		newY = 2*(winParent.height-height) - newY;
		verticalDir = -(verticalDir*loss);
	}
	else if (newY < 0)
	{
		newY = -newY;
		verticalDir = -(verticalDir*loss);
	}

	verticalDir += gravity * deltaTime;

	SetPos(newX, newY);
}

// ----------------------------------------------------------------------
// HSLToRGB()
// ----------------------------------------------------------------------

function HSLToRGB(
	float h, float sl, float l,
	out float r, out float g, out float b)
{
	local float v;
	local float m;
	local float sv;
	local int sextant;
	local float fract, vsf, mid1, mid2;

	if (l <= 0.5)
		v = (l * (1.0 + sl));
	else
		v = (l + sl - l * sl);

	if (v <= 0)
	{
		r = 0.0;
		g = 0.0;
		b = 0.0;
	}
	else
	{
		m = l + l - v;
		sv = (v - m) / v;
		h *= 6.0;
		sextant = h;
		fract = h - sextant;
		vsf = v * sv * fract;
		mid1 = m + vsf;
		mid2 = v - vsf;

		switch(sextant)
		{
			case 0: r = v; g = mid1; b = m; break;
			case 1: r = mid2; g = v; b = m; break;
			case 2: r = m; g = v; b = mid1; break;
			case 3: r = m; g = mid2; b = v; break;
			case 4: r = mid1; g = m; b = v; break;
			case 5: r = v; g = m; b = mid2; break;
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     logoFont=Font'DeusExUI.FontSpinningDX'
     dxLogoTimer=0.100000
     dxLogoMaxFrames=48
     colorTimer=0.100000
     gravity=120.000000
     horizontalDir=160.000000
     colLogo=(R=255,G=255,B=255)
}
