//=============================================================================
//  DWLightning: Lightning Emitter
//  A lightning emitter
//  By Mark 'MarZer' Gillard
//=============================================================================
class DWLightning extends DWEmitter
	placeable;
	
#exec OBJ LOAD FILE=DWeather-Tex.utx

var() float StrikeDelay;
var() float RandomDelayRange;
var() float RoamingSpeed;

var float StrikePS;
var float RandomDPSR;
var float ActualStrikeInterval;

var() bool RandomDelay;
var() bool Roaming;
var() bool RandomReflectionAngle;
var() bool TargetIsAttached;
var() bool DrawTarget;

var vector RotVec;

var rotator newRot;

var() name TargetTag;

var DWLightningTarget LockOnToMeh;
var DynamicProjector OuterRing, InnerRing;

replication
{
    reliable if ( Role == ROLE_Authority )
        StrikeDelay, RandomDelayRange, RoamingSpeed, StrikePS, RandomDPSR, ActualStrikeInterval,
        RandomDelay, Roaming, RandomReflectionAngle, TargetIsAttached, DrawTarget, RotVec, newRot, TargetTag,
        ChangeRotation, TraceMe, TracePawn, RandomTimerAndAttach;
}
	
simulated function PostBeginPlay()
{
	local DWLightningTarget Target;
	local vector ProjLoc;
	local rotator ProjRot;

	foreach DynamicActors( class'DWLightningTarget', Target )
	{
		if (Target.Tag == TargetTag)
			LockOnToMeh = Target;
			
		if (TargetIsAttached)
			Target.AttachTag = Tag;
	}
	
	if(Roaming)
	{
		RotVec = normal(vector(Rotation)) * RoamingSpeed;
		RotVec.Z = 0;
		Velocity = RotVec;
	}
	
	if (DrawTarget)
	{	
		ProjRot.Pitch = -16384;
		
		ProjLoc = LockOnToMeh.Location;
		ProjLoc.Z = ProjLoc.Z + 1000;
		
		OuterRing = Spawn(class'DWeatherLightningTargetProjectorOuterRing', Self,, ProjLoc, ProjRot);
		InnerRing = Spawn(class'DWeatherLightningTargetProjectorInnerRing', Self,, ProjLoc, ProjRot);
		OuterRing.SetBase(LockOnToMeh);
		InnerRing.SetBase(LockOnToMeh);		
	}
	
	StrikePS = (1 / StrikeDelay);
	
	if ((RandomDelay) && ((RandomDelayRange / 2) > StrikeDelay))
	{
		RandomDelayRange = StrikeDelay / (RandomDelayRange / 2);
	}
	
	if(!RandomDelay)
	{
		Emitters[0].ParticlesPerSecond = StrikePS;
        Emitters[0].InitialParticlesPerSecond = StrikePS;
        Emitters[1].ParticlesPerSecond = StrikePS;
        Emitters[1].InitialParticlesPerSecond = StrikePS;
        Emitters[3].ParticlesPerSecond = StrikePS;
        Emitters[3].InitialParticlesPerSecond = StrikePS;
    }

	RandomDPSR = (1 / RandomDelayRange);
}

simulated function ChangeRotation(bool Random)
{
	newRot = Rotation;
	
    if (Random)
    {
		newRot.Yaw = (newRot.Yaw + 32768) * RandRange(0.55, 1.45);
	}
	else
	{
		newRot.Yaw = newRot.Yaw + 32768;
	}		
    
	SetRotation(newRot);
	Velocity = normal(vector(newRot)) * RoamingSpeed;
}

simulated function HitWall( vector HitNormal, actor Wall )
{
	ChangeRotation(RandomReflectionAngle);
}

simulated function TraceMe()
{
	local vector HitLocation, HitNormal, End, NewLoc;
	local Actor HitActor;
	
	End.X = Location.X;
	End.Y = Location.Y;
	End.Z = Location.Z - 100000;
	
	HitActor = Trace(HitLocation, HitNormal, End, Location);
	if ((HitActor == Level) || (Vehicle(HitActor) != None) || (Pawn(HitActor) != None))
	{
		NewLoc.X = HitLocation.X;
		NewLoc.Y = HitLocation.Y;
		NewLoc.Z = HitLocation.Z + 5;
	}
	
	LockOnToMeh.SetLocation(NewLoc);
}

simulated function TracePawn()
{
	local Actor Other;
	local vector NewLoc;
	
	foreach VisibleCollidingActors(class'Actor', Other, 7000, Location, true) 
	{
		if (Pawn(Other) != None)
		{
			NewLoc = Other.Location;
			NewLoc.Z = NewLoc.Z + 5;
			LockOnToMeh.SetLocation(NewLoc);
		}
		else
			TraceMe();
	}
}

		
simulated function Tick (float DeltaTime)
{
	RandomTimerAndAttach();
}

simulated function RandomTimerAndAttach()
{
	if (TargetIsAttached)
		TracePawn();
	
	if(RandomDelay)
	{
		ActualStrikeInterval = RandRange((StrikePS - RandomDPSR), (StrikePS + RandomDPSR));
		
		Emitters[0].ParticlesPerSecond = ActualStrikeInterval;
        Emitters[0].InitialParticlesPerSecond = ActualStrikeInterval;
        Emitters[1].ParticlesPerSecond = ActualStrikeInterval;
        Emitters[1].InitialParticlesPerSecond = ActualStrikeInterval;
        Emitters[3].ParticlesPerSecond = ActualStrikeInterval;
        Emitters[3].InitialParticlesPerSecond = ActualStrikeInterval;
	}
}

simulated function Trigger( actor Other, pawn EventInstigator )
{
	ChangeRotation(RandomReflectionAngle);
}
	

defaultproperties
{
     StrikeDelay=20.000000
     RandomDelayRange=10.000000
     RoamingSpeed=500.000000
     RandomReflectionAngle=True
     Begin Object Class=BeamEmitter Name=BeamEmitter3
         BeamEndPoints(0)=(ActorTag="DWLightningTarget")
         DetermineEndPointBy=PTEP_Actor
         TriggerEndpoint=True
         LowFrequencyNoiseRange=(X=(Min=-400.000000,Max=400.000000),Y=(Min=-400.000000,Max=400.000000))
         LowFrequencyPoints=5
         HighFrequencyNoiseRange=(X=(Min=-250.000000,Max=250.000000),Y=(Min=-250.000000,Max=250.000000))
         HighFrequencyPoints=15
         UseBranching=True
         BranchProbability=(Max=1.000000)
         BranchEmitter=2
         BranchSpawnAmountRange=(Min=1.000000,Max=2.000000)
         LinkupLifetime=True
         UseColorScale=True
         RespawnDeadParticles=False
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
         ColorScaleRepeats=3.000000
         MaxParticles=2
         Sounds(0)=(Sound=Sound'OutdoorAmbience.lightning1',Radius=(Min=3000.000000,Max=3000.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=2.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(1)=(Sound=Sound'OutdoorAmbience.BThunder.lightning2',Radius=(Min=3000.000000,Max=3000.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=2.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(2)=(Sound=Sound'OutdoorAmbience.BThunder.lightning3',Radius=(Min=3000.000000,Max=3000.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=2.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(3)=(Sound=Sound'OutdoorAmbience.BThunder.lightning4',Radius=(Min=3000.000000,Max=3000.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=2.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(4)=(Sound=Sound'OutdoorAmbience.BThunder.lightning5',Radius=(Min=3000.000000,Max=3000.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=2.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundIndex=(Max=4.000000)
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         ParticlesPerSecond=0.500000
         InitialParticlesPerSecond=0.500000
         DrawStyle=PTDS_Brighten
         Texture=Texture'DWeather-tex.Lightning.Lightning-straight-thin'
         LifetimeRange=(Min=0.000000,Max=0.500000)
         StartVelocityRange=(Z=(Min=-1.000000,Max=-1.000000))
     End Object
     Emitters(0)=BeamEmitter'DWeather.DWLightning.BeamEmitter3'

     Begin Object Class=BeamEmitter Name=BeamEmitter4
         BeamEndPoints(0)=(ActorTag="DWLightningTarget")
         DetermineEndPointBy=PTEP_Actor
         LowFrequencyNoiseRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000))
         LowFrequencyPoints=10
         HighFrequencyNoiseRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000))
         HighFrequencyPoints=20
         UseBranching=True
         BranchProbability=(Min=0.100000,Max=1.000000)
         BranchEmitter=2
         BranchSpawnAmountRange=(Min=1.000000,Max=1.000000)
         LinkupLifetime=True
         UseColorScale=True
         RespawnDeadParticles=False
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
         ColorScaleRepeats=3.000000
         MaxParticles=2
         Sounds(0)=(Sound=Sound'OutdoorAmbience.lightning1',Radius=(Min=3000.000000,Max=3000.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=2.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(1)=(Sound=Sound'OutdoorAmbience.BThunder.lightning2',Radius=(Min=3000.000000,Max=3000.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=2.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(2)=(Sound=Sound'OutdoorAmbience.BThunder.lightning3',Radius=(Min=3000.000000,Max=3000.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=2.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(3)=(Sound=Sound'OutdoorAmbience.BThunder.lightning4',Radius=(Min=3000.000000,Max=3000.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=2.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(4)=(Sound=Sound'OutdoorAmbience.BThunder.lightning5',Radius=(Min=3000.000000,Max=3000.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=2.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundIndex=(Max=4.000000)
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         ParticlesPerSecond=0.500000
         InitialParticlesPerSecond=0.500000
         DrawStyle=PTDS_Brighten
         Texture=Texture'DWeather-tex.Lightning.Lightning-straight'
         LifetimeRange=(Min=0.000000,Max=0.500000)
         StartVelocityRange=(Z=(Min=-1.000000,Max=-1.000000))
     End Object
     Emitters(1)=BeamEmitter'DWeather.DWLightning.BeamEmitter4'

     Begin Object Class=BeamEmitter Name=BeamEmitter5
         BeamDistanceRange=(Min=1000.000000,Max=1500.000000)
         DetermineEndPointBy=PTEP_Distance
         LowFrequencyNoiseRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000))
         LowFrequencyPoints=10
         HighFrequencyNoiseRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000))
         HighFrequencyPoints=20
         UseBranching=True
         BranchProbability=(Max=1.000000)
         BranchSpawnAmountRange=(Min=1.000000,Max=2.000000)
         LinkupLifetime=True
         UseColorScale=True
         RespawnDeadParticles=False
         ResetOnTrigger=True
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
         Opacity=3.000000
         MaxParticles=50
         DrawStyle=PTDS_Brighten
         Texture=Texture'DWeather-tex.Lightning.Lightning-straight-thinner'
         StartVelocityRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-1.000000))
     End Object
     Emitters(2)=BeamEmitter'DWeather.DWLightning.BeamEmitter5'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseDirectionAs=PTDU_Normal
         UseColorScale=True
         RespawnDeadParticles=False
         UniformSize=True
         UseRandomSubdivision=True
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
         ColorScaleRepeats=6.000000
         MaxParticles=1
         StartSizeRange=(X=(Min=1500.000000,Max=1500.000000),Y=(Min=1500.000000,Max=1500.000000))
         Sounds(0)=(Sound=Sound'OutdoorAmbience.BThunder.lightning2',Radius=(Min=3000.000000,Max=3000.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=2.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(1)=(Sound=Sound'OutdoorAmbience.BThunder.lightning5',Radius=(Min=3000.000000,Max=3000.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=2.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundIndex=(Max=2.000000)
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         ParticlesPerSecond=0.500000
         InitialParticlesPerSecond=0.500000
         DrawStyle=PTDS_Brighten
         Texture=Texture'DWeather-tex.Lightning.Lightning-subivisions'
         TextureUSubdivisions=3
         TextureVSubdivisions=3
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(3)=SpriteEmitter'DWeather.DWLightning.SpriteEmitter1'

     AutoDestroy=True
     bAlwaysRelevant=True
     bUpdateSimulatedPosition=True
     Physics=PHYS_Projectile
     RemoteRole=ROLE_SimulatedProxy
     Texture=Texture'DWeather-tex.Icons.lightningicon'
     CollisionRadius=3.000000
     CollisionHeight=3.000000
     bCollideActors=True
     bCollideWorld=True
     bUseCylinderCollision=True
     bDirectional=True
}
