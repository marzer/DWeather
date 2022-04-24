//=============================================================================
//  DWFireEmitter
//  The actual fire component of the DWFire.

//  By Mark 'MarZer' Gillard
//=============================================================================
class DWFireEmitter extends NetworkEmitter
	notplaceable;

var		float		OrigXVelocityMin[3]; //
var		float		OrigXVelocityMax[3]; //Original X

var		float		OrigYVelocityMin[3]; //
var		float		OrigYVelocityMax[3]; //Original Y

var		float		OrigZVelocityMin[3]; //
var		float		OrigZVelocityMax[3]; //Original Z

function PreBeginPlay()
{
	local int i;
	
	for (i=0; i<3; i++)
	{
		OrigXVelocityMin[i] = Emitters[i].StartVelocityRange.X.Min; 
		OrigXVelocityMax[i] = Emitters[i].StartVelocityRange.X.Max; 
		
		OrigYVelocityMin[i] = Emitters[i].StartVelocityRange.Y.Min; 
		OrigYVelocityMax[i] = Emitters[i].StartVelocityRange.Y.Max; 
		
		OrigZVelocityMin[i] = Emitters[i].StartVelocityRange.Z.Min; 
		OrigZVelocityMax[i] = Emitters[i].StartVelocityRange.Z.Max;
	}
}

simulated function UpdateWind(vector Wind)
{
	local int i;
	
	for (i=0; i<3; i++)
	{
		Emitters[i].StartVelocityRange.X.Min = OrigXVelocityMin[i] + Wind.X;
		Emitters[i].StartVelocityRange.X.Max = OrigXVelocityMax[i] + Wind.X;
		
		Emitters[i].StartVelocityRange.Y.Min = OrigYVelocityMin[i] + Wind.Y;
		Emitters[i].StartVelocityRange.Y.Max = OrigYVelocityMax[i] + Wind.Y;
		
		Emitters[i].StartVelocityRange.Z.Min = OrigZVelocityMin[i] + Wind.Z;
		Emitters[i].StartVelocityRange.Z.Max = OrigZVelocityMax[i] + Wind.Z;
	}
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         TriggerDisabled=False
         Acceleration=(X=5.000000,Y=5.000000,Z=40.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=0.400000,Color=(G=128,R=255))
         ColorScale(2)=(RelativeTime=0.800000,Color=(G=75,R=151))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=5
         StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000))
         SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000))
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=0.200000,RelativeSize=0.700000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=70.000000,Max=70.000000))
         SpawningSound=PTSC_Random
         Texture=Texture'EpicParticles.Smoke.StellarFog1aw'
         LifetimeRange=(Min=1.200000,Max=1.200000)
         StartVelocityRange=(X=(Max=25.000000),Y=(Max=25.000000),Z=(Min=150.000000,Max=150.000000))
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(0)=SpriteEmitter'DWeather.DWFireEmitter.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         TriggerDisabled=False
         UseVelocityScale=True
         FadeOutStartTime=3.000000
         FadeInEndTime=3.000000
         MaxParticles=5
         DetailMode=DM_SuperHigh
         StartLocationOffset=(Z=200.000000)
         SpinCCWorCW=(X=1.000000)
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         SizeScale(0)=(RelativeSize=6.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=8.000000)
         SizeScale(2)=(RelativeTime=0.750000,RelativeSize=12.000000)
         SizeScale(3)=(RelativeTime=1.000000,RelativeSize=16.000000)
         StartSizeRange=(X=(Min=35.000000,Max=40.000000))
         DrawStyle=PTDS_Darken
         Texture=Texture'EpicParticles.Smoke.StellarFog1aw'
         LifetimeRange=(Min=8.000000,Max=8.000000)
         StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=50.000000,Max=50.000000))
         VelocityScale(0)=(RelativeVelocity=(X=0.100000,Y=0.100000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.500000,RelativeVelocity=(X=1.000000,Y=1.000000,Z=2.000000))
         VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(X=3.000000,Y=3.000000,Z=1.000000))
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(1)=SpriteEmitter'DWeather.DWFireEmitter.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         RespawnDeadParticles=False
         Disabled=True
         Backup_Disabled=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(X=15.000000,Y=15.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=0.300000,Color=(G=128,R=255))
         ColorScale(2)=(RelativeTime=0.800000,Color=(G=128,R=255))
         ColorScale(3)=(RelativeTime=1.000000)
         AutoResetTimeRange=(Min=2.000000,Max=2.000000)
         SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000))
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=0.200000,RelativeSize=2.000000)
         SizeScale(2)=(RelativeTime=0.500000,RelativeSize=3.000000)
         SizeScale(3)=(RelativeTime=1.000000,RelativeSize=2.500000)
         InitialParticlesPerSecond=3.000000
         Texture=Texture'EpicParticles.Smoke.StellarFog1aw'
         StartVelocityRange=(Z=(Min=400.000000,Max=400.000000))
     End Object
     Emitters(2)=SpriteEmitter'DWeather.DWFireEmitter.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseColorScale=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         TriggerDisabled=False
         ColorScale(0)=(Color=(G=255,R=255))
         ColorScale(1)=(RelativeTime=0.500000,Color=(G=192,R=255))
         ColorScale(2)=(RelativeTime=1.000000,Color=(G=255,R=255))
         Opacity=0.500000
         MaxParticles=1
         DetailMode=DM_SuperHigh
         StartLocationOffset=(Z=15.000000)
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.250000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=60.000000,Max=60.000000))
         Texture=Texture'EpicParticles.Flares.FlashFlare1'
         LifetimeRange=(Min=0.300000,Max=0.750000)
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(3)=SpriteEmitter'DWeather.DWFireEmitter.SpriteEmitter3'

     bNoDelete=False
}
