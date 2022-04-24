//=============================================================================
//  DWPawn: Pawn Class for Dynamic Weather
//  Used to set up pawn shadows.
//=============================================================================

class DWPawn extends xPawn;

var Effect_ShadowController RealtimeShadow;
var bool bRealtimeShadows;

simulated function PostBeginPlay()
{
    Super(UnrealPawn).PostBeginPlay();
    AssignInitialPose();

    if (bActorShadows && bPlayerShadows && (Level.NetMode != NM_DedicatedServer))
    {
        // decide which type of shadow to spawn
        if (!bRealtimeShadows)
        {
            PlayerShadow = Spawn(class'ShadowProjector',Self,'',Location);
            PlayerShadow.ShadowActor = self;
            PlayerShadow.bBlobShadow = bBlobShadow;
            PlayerShadow.LightDirection = Normal(vect(1,1,3));
            PlayerShadow.LightDistance = 320;
            PlayerShadow.MaxTraceDistance = 350;
            PlayerShadow.InitShadow();
        }
        else
        {
            RealtimeShadow = Spawn(class'Effect_ShadowController',self,'',Location);
            RealtimeShadow.Instigator = self;
            RealtimeShadow.Initialize();
        }
    }
}

defaultproperties
{
    bRealtimeShadows=true
}