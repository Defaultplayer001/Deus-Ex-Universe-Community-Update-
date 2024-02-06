
/*
	STATES
*/
DepthStencilState dstate_Enable
{
	DepthEnable = TRUE;
	DepthWriteMask = ALL;
	DepthFunc = GREATER_EQUAL;
	
};

DepthStencilState dstate_Disable
{
	DepthEnable = TRUE;
	DepthWriteMask = ZERO;
	DepthFunc = GREATER_EQUAL;
};



BlendState bstate_NoBlend
{
	BlendEnable[0] = FALSE;
};

BlendState bstate_Masked
{
	BlendEnable[0] = FALSE;
	#if(ALPHA_TO_COVERAGE_ENABLED)
	AlphaToCoverageEnable = TRUE;
	#endif
};

BlendState bstate_Modulate
{
	BlendEnable[0] = TRUE;
	SrcBlend = DEST_COLOR;
	DestBlend = SRC_COLOR;
	BlendOp = ADD ;
};

BlendState bstate_Translucent
{
	BlendEnable[0] = TRUE;
	SrcBlend = ONE;
	DestBlend =INV_SRC_COLOR ;
	BlendOp = ADD;
};

BlendState bstate_Alpha
{
	BlendEnable[0] = TRUE;
	SrcBlend = SRC_ALPHA;
	DestBlend = INV_SRC_ALPHA;
	BlendOp = ADD;
};

BlendState bstate_Invis
{
	BlendEnable[0] = TRUE;
	SrcBlend = ZERO;
	DestBlend = ONE;
	BlendOp = ADD;
};