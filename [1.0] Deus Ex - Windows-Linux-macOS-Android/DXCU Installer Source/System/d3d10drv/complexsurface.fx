/**
Shader for world geometry
*/

#include "common.fxh"
#include "unrealpool.fxh"
#include "unreal_pom.fx"

#define DETAIL_MAX 3 //detail texture passes
#define NEAR_Z 380.0f //from other renderers, range in which to start detail texturing
#define COMPENSATE_FF_MODULATE 2 //compensate for the fact that fixed function modulation will do source*dest+dest*source=2*s*d
#define NUM_TEXTURE_PASSES 7

#define NUM_TEXTURE_COORDS 5

#define PASS_LIGHT 0
#define PASS_DETAIL 1
#define PASS_FOG 2
#define PASS_MACRO 3
#define PASS_BUMP 4
#define PASS_HEIGHT 5

struct VS_INPUT
{	
	float3 pos : POSITION;
	float2 tex[NUM_TEXTURE_COORDS]: TEXCOORD0;	
	uint flags: BLENDINDICES;
};

struct GS_INPUT
{
	float4 pos : SV_POSITION;
	float2 tex[NUM_TEXTURE_COORDS]: TEXCOORD0;	
	uint flags: BLENDINDICES;
	float4 origPos: POSITION;
};

struct PS_INPUT
{	
	float4 pos : SV_POSITION;
	float2 tex[NUM_TEXTURE_COORDS]: TEXCOORD0;
	uint flags: BLENDINDICES;
	centroid float4 origPos: POSITION; //For detail texture gliches with MSAA
	centroid float2 texCentroid: TEXCOORD14; //For MSAA on masked textures
	#if(POM_ENABLED==1)
	float3 normal: NORMAL0;
	float3 viewTS: TEXCOORD15; //Tangent space view vector
	float2 vParallaxOffsetTS: TEXCOORD16; //Tangent space parallax offset vector
	#endif
};


struct PS_OUTPUT2
{
	float4 color: SV_Target0;
	float4 color1: SV_Target1;
};

cbuffer TexturePasses
{
	bool useTexturePass[NUM_TEXTURE_PASSES-1]; //In-shader toggles whether various passes should be used	
}

Texture2D textures[NUM_TEXTURE_PASSES-1];

BlendState bstate_Translucent_ComplexSurface //To be able to simulate multi-pass light modulation
{
	BlendEnable[0] = TRUE;
	SrcBlend = ONE;
	DestBlend = SRC1_COLOR ;
	BlendOp = ADD;
};



//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
GS_INPUT VS( VS_INPUT input )
{
	GS_INPUT output = (GS_INPUT)0;


	float4 projected=mul(float4(input.pos,1),projection);
	output.origPos = float4(input.pos,1);
	output.pos = projected;			
	
	for(int i=0;i<NUM_TEXTURE_COORDS;i++)
	{
		output.tex[i] = input.tex[i];
	}
	output.flags = input.flags;
	
	//d3d vs unreal coords
	output.pos.y =  -output.pos.y;
	output.origPos.y = -output.origPos.y;
	
	return output;
}

//--------------------------------------------------------------------------------------
// Geometry Shader
//--------------------------------------------------------------------------------------
[maxvertexcount(3)]
void GS( triangle GS_INPUT input[3], inout TriangleStream <PS_INPUT> triStream )
{
	PS_INPUT output = (PS_INPUT)0;
	
	float3 positions[3];
	float2 coords[3];
	
	int i;
	
	#if(POM_ENABLED==1)
	//Compute tangent space vectors for the triangle
	float3x3 tangentSpace;
	if(useTexturePass[PASS_DETAIL] || useTexturePass[PASS_HEIGHT])
	{
		for(i =0; i<3; i++)
		{
			positions[i]=input[i].origPos.xyz;
			coords[i]=input[i].tex[0];
		}
		tangentSpace = computeTangentSpaceMatrix(positions,coords);
	}
	#endif
	
	for(i=0; i<3; i++ )
	{
		//Compute normals
		#if(POM_ENABLED==1)
		if(useTexturePass[PASS_DETAIL] || useTexturePass[PASS_HEIGHT])
		{
			output.viewTS = mul(tangentSpace,-input[i].origPos.xyz);
			float g_fHeightMapScale;
			if (useTexturePass[5])
				g_fHeightMapScale = 0.03;
			else
				g_fHeightMapScale = 0.1;
			output.vParallaxOffsetTS = calcPOMVector(output.viewTS,g_fHeightMapScale);
			output.normal = tangentSpace[2];
		}
		#endif
		
		//Standard propagation
		output.pos = input[i].pos;
		for(int j=0;j<NUM_TEXTURE_COORDS;j++)
		{
			output.tex[j] = input[i].tex[j];
		}
		output.texCentroid=input[i].tex[0];
		output.flags = input[i].flags;
		output.origPos = input[i].origPos;
		
		triStream.Append(output);
	
	}
	triStream.RestartStrip();
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
PS_OUTPUT2 PS( PS_INPUT input)
{
	PS_OUTPUT2 output;
	output.color=float4(1,1,1,1);
	output.color1=float4(1,1,1,1);

	//Near enough for detail / POM?
	float NearZ=NEAR_Z;			
	bool isNear = input.origPos.z < NearZ;
	
	

	//Perform parallax occlusion mapping
	#if(POM_ENABLED==1)
	if(isNear)
	{
		if(useTexturePass[PASS_HEIGHT]) //Height map
		{	
			float2 texPom = POM(input.origPos,input.viewTS,input.normal,input.tex[0],input.vParallaxOffsetTS,textures[PASS_HEIGHT]);	
			input.tex[0] = lerp(texPom,input.tex[0],input.origPos.z/NearZ);
		}
		else if(useTexturePass[PASS_DETAIL]) //If no height map, POM coursest detail tex level
		{
			input.tex[2] = POM(input.origPos,input.viewTS,input.normal,input.tex[2],input.vParallaxOffsetTS,textures[PASS_DETAIL]);									
		}
	}
	#endif
		
	//Handle texture passes
	//Diffuse
	float4 diffuse = texDiffuse.SampleBias(sam,input.tex[0],LODBIAS);
	float4 diffusePoint = texDiffuse.SampleBias(samPoint,input.texCentroid,LODBIAS); //Centroid sampling for better behaviour with AA
	output.color*=diffuseTexture(diffuse,diffusePoint,input.flags);
	#if(CLASSIC_LIGHTING!=1)
	//Brighten fullbright objects
	if(input.flags&PF_Unlit)
		output.color.rgb=increaseDynamicRange(output.color.rgb,input.flags);
	#endif


	float3 light=float3(1,1,1);
	if(useTexturePass[PASS_LIGHT]) //Light
	{
		 light= textures[PASS_LIGHT].SampleLevel(sam,input.tex[1],0).rgb;

		light= light.bgr*2; //Convert BGRA 7 bit to RGBA 8 bit		

		#if(CLASSIC_LIGHTING!=1)
		light=increaseDynamicRange(light,input.flags);
		#endif

		output.color.rgb *=light;
	}
	
	if(useTexturePass[PASS_DETAIL]) //Detail
	{
		//This code largely comes from original renderers
		float3 detail=float3(1,1,1);				
					
		int DetailMax = DETAIL_MAX;

		float DetailScale=1.0f; 
		
		while( isNear && DetailMax-- > 0 )			
		{															
			float3 tex =  textures[PASS_DETAIL].SampleLevel(sam,input.tex[2]*DetailScale,0).rgb;
			float detailAlpha    =  1-input.origPos.z/NearZ;			
			detail *=  (1-detailAlpha) + detailAlpha*tex*COMPENSATE_FF_MODULATE;
			
			DetailScale *= 4.223f;
			NearZ /= 4.223f;	
			isNear = input.origPos.z < NearZ;				
		}
		
		output.color.rgb *= detail;
	}
	
	float3 fogMap=float3(0,0,0);
	if(useTexturePass[PASS_FOG]) //Fog texture
	{		
		fogMap = textures[PASS_FOG].SampleLevel(sam,input.tex[3],0).rgb;				
		fogMap.rgb = fogMap.bgr*2; //Convert BGRA 7 bit to RGBA 8 bit
		
	}
	if(useTexturePass[PASS_MACRO]) //Macro
	{		
		output.color *= textures[PASS_MACRO].Sample(sam,input.tex[4])*COMPENSATE_FF_MODULATE;
	}
	#if(BUMPMAPPING_ENABLED==1)
		if(useTexturePass[PASS_BUMP]) //Bumpmap
		{		
			float3 bumpMap=textures[PASS_BUMP].Sample(sam,input.tex[0]).xyz;
			bumpMap=normalize(bumpMap*2-1);
			
			float3 lightVec = float3(1,1,1); //Normally this would be an actual light position...
			output.color *= saturate(dot(lightVec,bumpMap));
			
		}
	#endif
	
	output.color.rgb+=fogMap;

	//To simulate 3DFX (i.e. multi-pass) behavior, go from blend equation (light*diffuse)+(1-light*diffuse)*dest to (light*diffuse)+((1-diffuse)*light*dest by using dual source blending with src1 = (1-diffuse)*light
	output.color1.rgb = (1-output.color.rgb/max(light.rgb,0.00001))*light.rgb; //max() to prevent divide by zero
	
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
		
		SetRasterizerState(rstate_Default);             
	}
}