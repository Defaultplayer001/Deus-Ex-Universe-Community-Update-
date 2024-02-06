#include "common.fxh"
#include "postprocessing.fxh"


/** read MSAA pixel */
float4 directCopy(float2 coords, Texture2DMS<float4,SAMPLES> tex)
{
		float4 color=(float4)0;
		[unroll] for(int i=0;i<SAMPLES;i++)
		{
			color += tex.Load(coords,i);		
		}
		color/=SAMPLES;
		return color;
}

Texture2DMS<float4,SAMPLES> inputTextureMSAA;

cbuffer firstConstants
{
	float3 flash;
}

PS_OUTPUT_SIMPLE PS_first(PS_INPUT_SIMPLE input)
{
	PS_OUTPUT_SIMPLE output = (PS_OUTPUT_SIMPLE)0;
				
	float2 coords = input.pos.xy;		
	output.color=directCopy(coords,inputTextureMSAA);
	
	//Flash
	output.color.rgb+=flash.rgb;
	return output;
}


technique10 Render
{
	pass P0
	{
		SetVertexShader( CompileShader( vs_4_0, VS_identity() ) );	
		SetGeometryShader( 0 );
		SetPixelShader( CompileShader( ps_4_0, PS_first() ) );
		
	}
}