/**
Shader for sprites. Expands point sprites to a quad.
*/

#include "common.fxh"
#include "unrealpool.fxh"

struct VS_INPUT
{	
	float4 XYWH : POSITION0; //In pixels: X, Y, width, height
	float4 UVWH: POSITION1; //Texture U, V, width, height
	float4 color: COLOR0;
	float z: PSIZE0;
	uint flags: BLENDINDICES;
};

struct GS_INPUT
{	
	float4 XYWH: POSITION0;
	float4 UVWH: POSITION1;
	float4 color: COLOR0;
	float z: PSIZE0;
	uint flags: BLENDINDICES;
};


struct PS_INPUT
{	
	float4 pos : SV_POSITION;
	float4 color: COLOR0;
	float2 tex: TEXCOORD0;
	uint flags: BLENDINDICES;
};

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
GS_INPUT VS( VS_INPUT input )
{
	GS_INPUT output = (GS_INPUT)input;

	//Scale screen coords to -1,1 ranges
	output.XYWH.xz/=0.5*viewportWidth;
	output.XYWH.yw/=-0.5*viewportHeight;


	output.color = unrealColor(input.color,input.flags);

	//Perform perspective projection on Z
	float4 projected=mul(float4(1,1,output.z,1),projection);
	output.z = projected.z/ projected.w;
	output.z=clamp(output.z,0,99999999); //ATI fix

	return output;
}

//--------------------------------------------------------------------------------------
// Geometry Shader
//--------------------------------------------------------------------------------------
[maxvertexcount(4)]
void GS( point GS_INPUT input[1], inout TriangleStream <PS_INPUT> triStream )
{
	PS_INPUT output = (PS_INPUT)0;
	
	output.pos.z = input[0].z;
	output.pos.w = 1;
	output.color = input[0].color;
	output.flags = input[0].flags;

	

	//Left right top bottom
	float4 pos;
	pos.x = -1+input[0].XYWH.x;
	pos.y = pos.x +input[0].XYWH.z;
	pos.z =  1+input[0].XYWH.y;
	pos.w =  pos.z + input[0].XYWH.w;

	//Left right top bottom
	float4 tex;
	tex.x = input[0].UVWH.x;
	tex.y = tex.x + input[0].UVWH.z;	
	tex.z = input[0].UVWH.y;
	tex.w = tex.z + input[0].UVWH.w;
	
	//Left top
	output.pos.xy = pos.xz;
	output.tex.xy = tex.xz;
	triStream.Append(output);
	
	//Left bottom
	output.pos.xy = pos.xw;
	output.tex.xy = tex.xw;
	triStream.Append(output);

	//Right top
	output.pos.xy = pos.yz;
	output.tex.xy = tex.yz;
	output.pos.z = input[0].z;
	triStream.Append(output);
	
	//Right bottom
	output.pos.xy = pos.yw;
	output.tex.xy = tex.yw;
	output.pos.z = input[0].z;
	triStream.Append(output);
	
	triStream.RestartStrip();
}



//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
PS_OUTPUT PS( PS_INPUT input)
{
	PS_OUTPUT output;
	 
	output.color= input.color;	
	float4 diffuse = texDiffuse.SampleBias(sam,input.tex,LODBIAS);
	float4 diffusePoint = texDiffuse.SampleBias(samPoint,input.tex,LODBIAS);
		
	output.color*=diffuseTexture(diffuse,diffusePoint,input.flags);

	return output;
}



//--------------------------------------------------------------------------------------
technique10 Render
{
	pass Standard
	{
		SetVertexShader( CompileShader( vs_4_0, VS() ) );
		SetGeometryShader( CompileShader( gs_4_0, GS()) );
		SetPixelShader( CompileShader( ps_4_0, PS() ) );
	
		SetRasterizerState(rstate_NoMSAA);             
	}
}