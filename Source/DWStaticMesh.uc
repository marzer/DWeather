//=============================================================================
//  DWStaticMesh: DWStaticMesh for Dynamic Weather
//  Used to set up realtime static mesh shadows.
//=============================================================================

class DWStaticMesh extends StaticMeshActor;

/*
var Effect_ShadowController RealtimeShadow;
var bool bRealtimeShadows;
var ShadowProjector ActorShadow;

simulated function PostBeginPlay()
{
    Super(StaticMeshActor).PostBeginPlay();

    if (bActorShadows && (Level.NetMode != NM_DedicatedServer))
    {
        // decide which type of shadow to spawn
        if (!bRealtimeShadows)
        {
            ActorShadow = Spawn(class'ShadowProjector',Self,'',Location);
            ActorShadow.ShadowActor = self;
            ActorShadow.bBlobShadow = bBlobShadow;
            ActorShadow.LightDirection = Normal(vect(1,1,3));
            ActorShadow.LightDistance = 320;
            ActorShadow.MaxTraceDistance = 350;
            ActorShadow.InitShadow();
        }
        else
        {
            RealtimeShadow = Spawn(class'Effect_ShadowController',self,'',Location);
            RealtimeShadow.Instigator = self;
            RealtimeShadow.Initialize();
        }
    }
}
*/

defaultproperties
{
     bStaticLighting=False
}
