class DWeatherLightningTargetProjectorOuterRing extends DynamicProjector;

#exec OBJ LOAD FILE=DWeather-tex.utx

defaultproperties
{
     FrameBufferBlendingOp=PB_Add
     ProjTexture=Texture'DWeather-tex.Lightning.Ring1'
     FOV=30
     MaxTraceDistance=2048
     bProjectActor=False
     bClipBSP=True
     bClipStaticMesh=True
     bProjectOnUnlit=True
     bProjectOnAlpha=True
     bProjectOnParallelBSP=True
     bNoProjectOnOwner=True
     CullDistance=10000.000000
     bLightChanged=True
     DrawScale=1.300000
     bHardAttach=True
}
