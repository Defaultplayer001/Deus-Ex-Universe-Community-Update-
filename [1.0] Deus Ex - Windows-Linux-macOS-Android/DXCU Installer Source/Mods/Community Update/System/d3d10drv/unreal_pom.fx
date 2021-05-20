/**
\file pom.fx

Parallax occlusion mapping, based on D3D9 example code. Unreal only gives us view-space information (not world space), but this works fine as we can just use 0,0,0 as the eye position.
*/


int      g_nMinSamples = 10;
int      g_nMaxSamples = 75;
int      g_nLODThreshold;   

/**
Geometry shader code to calculate tangent space matrix
http://wiki.gamedev.net/index.php/D3DBook:(Lighting)_Per-Pixel_Lighting#Moving_From_Per-Vertex_To_Per-Pixel
*/
float3x3 computeTangentSpaceMatrix(in float3 pos[3], in float2 tc[3])
{
	float3 A = pos[1] - pos[0];
	float3 B = pos[2] - pos[0];
 
	float2 P = tc[1] - tc[0];
	float2 Q = tc[2] - tc[0];
 
	float fraction = 1.0f / ( P.x * Q.y - Q.x * P.y );
 
	float3 normal = normalize( cross( A, B ) );
 
	float3 tangent = float3
	(
		(Q.y * A.x - P.y * B.x) * fraction,
		(Q.y * A.y - P.y * B.y) * fraction,
		(Q.y * A.z - P.y * B.z) * fraction
	);
 
	float3 bitangent = float3
	(
		(P.x * B.x - Q.x * A.x) * fraction,
		(P.x * B.y - Q.x * A.y) * fraction,
		(P.x * B.z - Q.x * A.z) * fraction
	);
	
	// Some simple aliases
	float NdotT = dot( normal, tangent );
	float NdotB = dot( normal, bitangent );
	float TdotB = dot( tangent, bitangent );
 
	// Apply Gram-Schmidt orthogonalization
	tangent    = tangent - NdotT * normal;
	//bitangent  = bitangent - NdotB * normal - TdotB * tangent;
	
//KENTIE: using cross product instead of Gram-Schmidt for binormal prevents seams/glitches
	bool rightHanded = (dot(cross(tangent, bitangent), normal) >= 0);
	bitangent = cross(normal,tangent);
	if(!rightHanded)
		bitangent*=-1;
//END KENTIE
	
 
	// Pack the vectors into the matrix output
	float3x3 tsMatrix;
 
	tsMatrix[0] = normalize(tangent);
	tsMatrix[1] = normalize(bitangent);
	tsMatrix[2] = normalize(normal);
 
	return tsMatrix;
}

/**
Ray direction calculation, normally in vertex shader but now in geometry shader as the required information is only available there
*/
float2 calcPOMVector(float3 vViewTS,float g_fHeightMapScale)
{
	// Compute the ray direction for intersecting the height field profile with 
	// current view ray. See the above paper for derivation of this computation.
	float2 vParallaxOffsetTS;
	// Compute initial parallax displacement direction:
	float2 vParallaxDirection = normalize(  vViewTS.xy );

	// The length of this vector determines the furthest amount of displacement:
	float fLength         = length( vViewTS );
	float fParallaxLength = sqrt( fLength * fLength - vViewTS.z * vViewTS.z ) /vViewTS.z; 

	// Compute the actual reverse parallax displacement vector:
	vParallaxOffsetTS = vParallaxDirection * fParallaxLength;

	// Need to scale the amount of displacement to account for different height ranges
	// in height maps. This is controlled by an artist-editable parameter:
	vParallaxOffsetTS *= g_fHeightMapScale;
	return vParallaxOffsetTS;
}

/**
Simplified POM shader
*/
float2 POM(float4 pos, float3 viewTS, float3 normal, float2 texCoord, float2 vParallaxOffsetTS, Texture2D tex)
{ 

   //  Normalize the interpolated vectors:
   float3 vViewTS   = normalize( viewTS  );
   float3 vViewWS   = normalize( -pos.xyz );
   float3 vNormalWS = normalize( normal );
	 
   float4 cResultColor = float4( 0, 0, 0, 1 );

 
   float2 texSample = texCoord;
   
  
   
	  int nNumSteps = (int) lerp( g_nMaxSamples, g_nMinSamples, dot( vViewWS, vNormalWS ) );
		
	  float fCurrHeight = 0.0;
	  float fStepSize   = 1.0 / (float) nNumSteps;
	  float fPrevHeight = 1.0;
	  float fNextHeight = 0.0;

	  int    nStepIndex = 0;
	  bool   bCondition = true;

	  float2 vTexOffsetPerStep = fStepSize * vParallaxOffsetTS;
	  float2 vTexCurrentOffset = texCoord;
	  float  fCurrentBound     = 1.0;
	  float  fParallaxAmount   = 0.0;

	  float2 pt1 = 0;
	  float2 pt2 = 0;
	   
	  float2 texOffset2 = 0;

	  while ( nStepIndex < nNumSteps ) 
	  {
		 vTexCurrentOffset -= vTexOffsetPerStep;

		 // Sample height map which in this case is stored in the alpha channel of the normal map:
		fCurrHeight = tex.SampleLevel(samLinear,vTexCurrentOffset, 0).r;
		

		 fCurrentBound -= fStepSize;

		 if ( fCurrHeight > fCurrentBound ) 
		 {   
			pt1 = float2( fCurrentBound, fCurrHeight );
			pt2 = float2( fCurrentBound + fStepSize, fPrevHeight );

			texOffset2 = vTexCurrentOffset - vTexOffsetPerStep;

			nStepIndex = nNumSteps + 1;
			fPrevHeight = fCurrHeight;
		 }
		 else
		 {
			nStepIndex++;
			fPrevHeight = fCurrHeight;
		 }
	  }   

	  float fDelta2 = pt2.x - pt2.y;
	  float fDelta1 = pt1.x - pt1.y;
	  
	  float fDenominator = fDelta2 - fDelta1;
	  
	  // SM 3.0 requires a check for divide by zero, since that operation will generate
	  // an 'Inf' number instead of 0, as previous models (conveniently) did:
	  if ( fDenominator == 0.0f )
	  {
		 fParallaxAmount = 0.0f;
	  }
	  else
	  {
		 fParallaxAmount = (pt1.x * fDelta2 - pt2.x * fDelta1 ) / fDenominator;
	  }
	  
	  float2 vParallaxOffset = vParallaxOffsetTS * (1 - fParallaxAmount );

	  // The computed texture offset for the displaced point on the pseudo-extruded surface:
	  float2 texSampleBase = texCoord - vParallaxOffset;
	  texSample = texSampleBase;

	return texSample;
}

