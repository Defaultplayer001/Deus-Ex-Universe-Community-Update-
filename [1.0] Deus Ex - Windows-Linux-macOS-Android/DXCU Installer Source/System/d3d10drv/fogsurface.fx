/**
Shader for Rune fog surfaces
*/

#include "common.fxh"
#include "unrealpool.fxh"

struct VS_INPUT
{	
	float3 pos : POSITION;
	float4 color: COLOR0;
	uint flags: BLENDINDICES;
};


struct PS_INPUT
{	
	float4 pos : SV_POSITION;
	float4 color: COLOR0;
	uint flags: BLENDINDICES;
};

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS( VS_INPUT input )
{
	PS_INPUT output = (PS_INPUT)0;

	float4 projected=mul(float4(input.pos,1),projection);
	output.pos = projected;		
	output.color = unrealColor(input.color,input.flags);
	output.flags = input.flags;
	output.pos.y =  -output.pos.y;
	return output;
}



//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
PS_OUTPUT PS( PS_INPUT input)
{
	PS_OUTPUT output;
	
	output.color= input.color;
	return output;
}


//--------------------------------------------------------------------------------------
technique10 Render
{
	pass Standard
	{
		SetVertexShader( CompileShader( vs_4_0, VS() ) );
		SetGeometryShader( NULL );
		SetPixelShader( CompileShader( ps_4_0, PS() ) );
		
		SetRasterizerState(rstate_Default);             
	}
}