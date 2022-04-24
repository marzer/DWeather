//=============================================================================
//  DWTwister: Twister
//  A Twister that moves around and swallows things.
//
//  By Mark 'MarZer' Gillard, BIG props to JB and the Chaos team!
//=============================================================================
class DWTwister extends DWParent
	placeable;

//=============================================================================
// Declarations
//=============================================================================	
var() range RoamingSpeed;

var float TornadoStrength;
var float TornadoRange;
var float ActualRoamingSpeed;

var rotator newRot;

var vector WindVector;

var DWTwisterChild TopChild, MiddleChild;
var class<DWTwisterChild> TwisterChildClass;

var Emitter TwisterEffect;
var class<Emitter> TwisterEffectClass;

//=============================================================================
// Post begin play.
//=============================================================================
simulated function PostBeginPlay()
{
	local vector Top, Mid;
	
	Top = Location;
	Mid = Location;
	Top.Z = Location.Z + 1300;
	Mid.Z = Location.Z + 600;
	
	ActualRoamingSpeed = RandRange(RoamingSpeed.Min, RoamingSpeed.Max);
	
	TwisterEffect = spawn(TwisterEffectClass, self);
	if (TwisterEffect != None)
		TwisterEffect.SetBase(self);

	TopChild = spawn(TwisterChildClass, self,,Top);
	if (TopChild != None)
		TopChild.SetBase(self);		
		
	MiddleChild = spawn(TwisterChildClass, self,,Mid);
	if (MiddleChild != None)
		MiddleChild.SetBase(self);
		
}

//=============================================================================
// Tick
//=============================================================================
simulated function Tick(float DeltaTime)
{
	TraceMe();
	SuckInActors(TornadoStrength, TornadoRange, DeltaTime);
	
	newRot = Rotation;
	newRot.Yaw = newRot.Yaw * RandRange(0.995, 1.005);
    SetRotation(newRot);
    
   	ActualRoamingSpeed = RandRange(RoamingSpeed.Min, RoamingSpeed.Max);
	Velocity = normal(vector(newRot)) * ActualRoamingSpeed;
	Velocity.X += WindVector.X;
	Velocity.Y += WindVector.Y;
}

//=============================================================================
// TraceMe
//
// Always makes sure the twister remains on the ground. If it is higher than 
// the ground, it floats downward. If the ground gets too close (Z < 5), 
// the Twister will move upward to compensate (allows for traversing inclines).
//=============================================================================
simulated function TraceMe()
{
	local vector HitLocation, HitNormal, End, NewLoc, Start;
	local Actor HitActor;
	
	End.X = Location.X;
	End.Y = Location.Y;
	End.Z = Location.Z - 4000;
	
	Start.X = Location.X;
	Start.Y = Location.Y;
	Start.Z = Location.Z + 4000;
	
	HitActor = Trace(HitLocation, HitNormal, End, Location);
	if ((HitActor == Level) && ((Abs(Location.Z - HitLocation.Z)) > 5))  // Z = 5 Height buffer zone
	{
		if(HitLocation.Z < Location.Z)
		{
			NewLoc.X = Location.X;
			NewLoc.Y = Location.Y;
			NewLoc.Z = Location.Z - 50;
		}
		else
		{
			NewLoc.X = Location.X;
			NewLoc.Y = Location.Y;
			NewLoc.Z = Location.Z + 50;	
		}
		self.SetLocation(NewLoc);
	}
}

//=============================================================================
// Get moved around by the wind.
//=============================================================================
simulated function UpdateWind(vector Wind)
{
	WindVector = Wind * 1.25;
}

//=============================================================================
// Change rotation
//=============================================================================
simulated function ChangeRotation()
{
	newRot = Rotation;
	newRot.Yaw = newRot.Yaw + 32768;
    SetRotation(newRot);
	
   	ActualRoamingSpeed = RandRange(RoamingSpeed.Min, RoamingSpeed.Max);
	Velocity = normal(vector(newRot)) * ActualRoamingSpeed;
	Velocity.X += WindVector.X;
	Velocity.Y += WindVector.Y;
}

//=============================================================================
// Contact with world geometry.
//=============================================================================
simulated function HitWall( vector HitNormal, actor Wall )
{
	ChangeRotation();
}

//=============================================================================
// Properties
//=============================================================================

defaultproperties
{
	RoamingSpeed=(Min=1000.000000,Max=1500.000000)
	TornadoStrength=2200.000000
	TornadoRange=1300.000000
	TwisterChildClass=Class'DWeather.DWTwisterChild'
	TwisterEffectClass=Class'DWeather.DWTwisterEmitter'
	KickUpSpeed=80.000000
	DamageRadius=250.000000
	Damage=5.000000
	MyDamageType=Class'DWeather.DamTypeTwister'
	bUpdateSimulatedPosition=True
	Physics=PHYS_Projectile
	AmbientSound=Sound'OutdoorAmbience.BThunder.Wind2'
	Texture=Texture'DWeather-tex.Icons.twistericon'
	bFullVolume=True
	SoundVolume=255
	CollisionRadius=1.000000
	CollisionHeight=1.000000
	bCollideActors=false
	bBlockActors=false
	bBlockKarma=false
	bWorldGeometry=false
	bCollideWorld=true
	bBlockZeroExtentTraces=False
	bBlockNonZeroExtentTraces=False
	bUseCylinderCollision=True
	bDirectional=True
	bIsEffectedByWind=true     
}
