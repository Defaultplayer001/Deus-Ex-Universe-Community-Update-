
/*
	MISC
*/


//Unreal poly flags
#define		PF_Invisible		0x00000001	/**< Poly is invisible. */
#define 	PF_Masked			0x00000002	/**< Poly should be drawn masked. */
#define 	PF_Translucent	 	0x00000004	/**< Poly is transparent. */
#define		PF_NotSolid			 0x00000008	/**< Poly is not solid doesn't block. */
#define		PF_Environment   	 0x00000010	/**< Poly should be drawn environment mapped. */
#define		PF_ForceViewZone	 0x00000010	/**< Force current iViewZone in OccludeBSP (reuse Environment flag) */
#define		PF_Semisolid	  	 0x00000020	/**< Poly is semi-solid  collision solid Csg nonsolid. */
#define 	PF_Modulated 		 0x00000040	/**< Modulation transparency. */
#define 	PF_FakeBackdrop		 0x00000080	/**< Poly looks exactly like backdrop. */
#define 	PF_TwoSided			 0x00000100	/**< Poly is visible from both sides. */
#define 	PF_AutoUPan		 	 0x00000200	/**< Automatically pans in U direction. */
#define 	PF_AutoVPan 		 0x00000400	/**< Automatically pans in V direction. */
#define 	PF_NoSmooth			 0x00000800	/**< Don't smooth textures. */
#define 	PF_BigWavy 			 0x00001000	/**< Poly has a big wavy pattern in it. */
#define 	PF_SpecialPoly		 0x00001000	/**< Game-specific poly-level render control (reuse BigWavy flag) */
#define		PF_AlphaBlend		 0x00001000	/**< RUNE:  This poly should be alpha blended */
#define 	PF_SmallWavy		 0x00002000	/**< Small wavy pattern (for water/enviro reflection). */
#define 	PF_Flat				 0x00004000	/**< Flat surface. */
#define 	PF_LowShadowDetail	 0x00008000	/**< Low detaul shadows. */
#define 	PF_NoMerge			 0x00010000	/**< Don't merge poly's nodes before lighting when rendering. */
#define 	PF_CloudWavy		 0x00020000	/**< Polygon appears wavy like clouds. */
#define 	PF_DirtyShadows		 0x00040000	/**< Dirty shadows. */
#define 	PF_BrightCorners	 0x00080000	/**< Brighten convex corners. */
#define 	PF_SpecialLit		 0x00100000	/**< Only speciallit lights apply to this poly. */
#define 	PF_Gouraud			 0x00200000	/**< Gouraud shaded. */
#define 	PF_NoBoundRejection  0x00200000	/**< Disable bound rejection in OccludeBSP (reuse Gouraud flag) */
#define 	PF_Unlit			 0x00400000	/**< Unlit. */
#define 	PF_HighShadowDetail	 0x00800000	/**< High detail shadows. */
#define 	PF_Portal			 0x04000000	/**< Portal between iZones. */
#define 	PF_Mirrored			 0x08000000	/**< Reflective surface. */

// Editor flags.
#define 	PF_Memorized     	 0x01000000	/**< Editor: Poly is remembered. */
#define 	PF_Selected      	 0x02000000	/**< Editor: Poly is selected. */
#define 	PF_Highlighted       0x10000000	/**< Editor: Poly is highlighted. */ 
#define 	PF_FlatShaded		 0x40000000	/**< FPoly has been split by SplitPolyWithPlane. */   

// Internal.
#define 	PF_EdProcessed 		 0x40000000	/**< FPoly was already processed in editorBuildFPolys. */
#define 	PF_EdCut       		 0x80000000	/**< FPoly has been split by SplitPolyWithPlane. */
#define 	PF_RenderFog		 0x40000000	/**< Render with fogmapping. */
#define 	PF_Occlude			 0x80000000	/**< Occludes even if PF_NoOcclude. */
#define 	PF_RenderHint        0x01000000   /**< Rendering optimization hint. */

// Combinations of flags.
#define 	PF_NoOcclude		 PF_Masked | PF_Translucent | PF_Invisible | PF_Modulated
#define 	PF_NoEdit			 PF_Memorized | PF_Selected | PF_EdProcessed | PF_NoMerge | PF_EdCut
#define 	PF_NoImport			 PF_NoEdit | PF_NoMerge | PF_Memorized | PF_Selected | PF_EdProcessed | PF_EdCut
#define 	PF_AddLast			 PF_Semisolid | PF_NotSolid
#define 	PF_NoAddToBSP		 PF_EdCut | PF_EdProcessed | PF_Selected | PF_Memorized
#define 	PF_NoShadows		 PF_Unlit | PF_Invisible | PF_Environment | PF_FakeBackdrop
#define 	PF_Transient		 PF_Highlighted