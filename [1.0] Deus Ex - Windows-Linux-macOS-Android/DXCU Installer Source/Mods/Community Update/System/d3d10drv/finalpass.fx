#include "common.fxh"
#include "postprocessing.fxh"

#if(CLASSIC_LIGHTING==1)
#define GAMMA_SCALE 1
#else
#define GAMMA_SCALE 0.8 //.8 so we do nothing at brightness 0.5.
#endif

cbuffer finalConstants
{
	float brightness;
}

PS_OUTPUT_SIMPLE PS_final(PS_INPUT_SIMPLE input)
{
	PS_OUTPUT_SIMPLE output = (PS_OUTPUT_SIMPLE)0;
				
	int3 coords = int3(input.pos.xy,0);		
	output.color=inputTexture.Load(coords);
	
	//Apply brightness
	float gamma = 2.5f*brightness*GAMMA_SCALE;
	output.color.rgb=pow(abs(output.color.rgb),1.0f/gamma);
	return output;
}

technique10 Render
{
	pass P0
	{
		SetVertexShader( CompileShader( vs_4_0, VS_identity() ) );	
		SetGeometryShader( 0 );
		SetPixelShader( CompileShader( ps_4_0, PS_final() ) );
		SetRasterizerState(rstate_NoMSAA);    	
	}
}