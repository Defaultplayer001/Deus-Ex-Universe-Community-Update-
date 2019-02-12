//=============================================================================
// FadeTextWindow
//=============================================================================
class FadeTextWindow extends TextWindow;

var float moveRateX;
var float moveRateY;
var float fadeSpeed;
var float fadeTimer;
var float textColor;
var float textLum;
var Color colText;
var float r, g, b;
var int   newX, newY;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetFont(Font'FontLocation');
	EnableTranslucentText(True);

	fadeSpeed = FRand() / 20;
	fadeTimer = fadeSpeed;
	textColor = FRand();
	textLum   = FRand();
	bTickEnabled = True;
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	// First move the guy
	moveRateX -= deltaTime;
	if (moveRateX < 0.0)
	{
		newX = x + Rand(4) - 2;
		moveRateX = FRand();
	}

	moveRateY -= deltaTime;
	if (moveRateY < 0.0)
	{
		newY = y + Rand(4) - 2;
		moveRateY = FRand();
	}
	SetPos(newX, newY);

	// Update the color		
	fadeTimer -= deltaTime;

	if (fadeTimer < 0.0)
	{
		fadeTimer = fadeSpeed;
		textLum -= 0.01;

		if (textLum <= 0.0)
			Destroy();

//		HSLToRGB(textColor, 0.7, textLum, r, g, b);
		HSLToRGB(textColor, FRand(), textLum, r, g, b);

		colText.r = Int(r * 256) - 1;
		colText.g = Int(g * 256) - 1;
		colText.b = Int(b * 256) - 1;

		SetTextColor(colText);
	}
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
}
