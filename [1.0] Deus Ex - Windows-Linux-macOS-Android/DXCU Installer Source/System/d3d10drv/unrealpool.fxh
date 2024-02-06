/*
Definitions and constant buffers common to all geometry shaders
*/

#include "polyflags.fxh"



struct PS_OUTPUT
{
	float4 color: SV_Target0;
};

/*
	CONSTANT BUFFERS
*/
shared cbuffer PerScene
{
	matrix projection;
	float viewportHeight;
	float viewportWidth;
}


shared Texture2D texDiffuse;


float4 unrealColor(float4 color, uint flags)
{		
	if(flags&PF_Modulated) //Modulated not influenced by color
		return float4(1,1,1,1);
	
	float4 result = clamp(color,0,1); //Color is sometimes >1 for Rune which screws up runestone particles

	return result;
}

/**
Calculate fog color
*/
float4 unrealVertexFog(float4 fog, uint flags)
{
	//From OpenGL renderer; seems fog should not be combined with these other effects
	if((flags & (PF_RenderFog|PF_Translucent|PF_Modulated|PF_AlphaBlend))==PF_RenderFog)
		return fog;
	
	return float4(0,0,0,0);
}

/**
Increase dynamic range of a color for when HDR is enabled
*/
float3 increaseDynamicRange(float3 color,uint flags)
{
	float3 output=color;
	if(!(flags&PF_Modulated))
	{
		output.rgb=pow(abs(output.rgb)*1.5f,1.5);
	}
	return output;
}

/**
Nonlinearly darken colors to match darkened HDR environments
*/
float3 increaseDynamicRange_DarkenOnly(float3 color,uint flags)
{
	float3 output=color;
	if(!(flags&PF_Modulated))
	{
		output.rgb=pow(abs(output.rgb),1.5);
	}
	return output;
}

/**
Handle diffuse texturing/alpha test

*/
float4 diffuseTexture(float4 diffuse, float4 diffusePoint, uint flags)
{
	//Alpha test; point sample to get rid of seams
	if(flags&PF_Masked && !(flags&(PF_Translucent|PF_AlphaBlend))) //Need to check alphablend here because external textures can have alpha channel
	{
		#if(!ALPHA_TO_COVERAGE_ENABLED)
		clip(diffusePoint.a-0.5f);
		clip(diffuse.a-0.5f);
		#endif
	}
	
	if(flags&PF_NoSmooth)
	{
		diffuse = diffusePoint;
	}

	return diffuse;
}