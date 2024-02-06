struct VS_INPUT_SIMPLE
{	
	float3 pos : POSITION;
	//float2 texCoords: TEXCOORD0;
};

struct PS_INPUT_SIMPLE
{
	float4 pos: SV_POSITION;
	//float2 texCoords: TEXCOORD0;
};

struct PS_OUTPUT_SIMPLE
{
	float4 color: SV_Target;
};

struct PS_OUTPUT_SIMPLE_R32
{
	float color: SV_Target;
};

PS_INPUT_SIMPLE VS_identity( VS_INPUT_SIMPLE input )
{
	PS_INPUT_SIMPLE output = (PS_INPUT_SIMPLE)0;
	output.pos = float4(input.pos,1);
	//output.texCoords = input.texCoords;
	return output;
}

shared cbuffer ppcbuffer
{
	uint2 viewPort;
	float elapsedTime; /**<Time since last frame*/
	uint2 inputTextureOffset; /**< Offset (left, top) to apply to input texture to take into account game viewport setting */
}

shared Texture2D inputTexture;


