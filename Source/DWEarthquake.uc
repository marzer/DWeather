//=============================================================================
//  DWEarthquake
//
//  Simulates Earthquakes by rumbling the player's view and throwing any 
//  vehicles or pawns that are on the ground into the are a little.
//  By Mark 'MarZer' Gillard
//=============================================================================
class DWEarthquake extends DWParent
	placeable;

#exec OBJ LOAD FILE="..\Textures\DWeather-Tex.utx"	
	
var() range EarthquakeInterval;
var() float EarthquakeRadius;
var() float EarthquakeLengthOfTime;
var() bool  Enabled;
var vector 	ShakeRotMag;           // how far to rot view
var vector 	ShakeRotRate;          // how fast to rot view
var vector 	ShakeOffsetMag;        // max view offset vertically
var vector 	ShakeOffsetRate;       // how fast to offset view vertically
var float  	ShakeOffsetTime;       // how much time to offset view
var float 	Current;
var float 	RealEarthquakeInterval;
var float	RumbleTime;
var float	RealViewShakeTime;
var bool 	bIsRumbling;

replication
{
    reliable if ( Role == ROLE_Authority )
    Rumble, KickMe;
}

simulated function PostBeginPlay()
{
	RealViewShakeTime = EarthquakeLengthOfTime * 3.5;
	ShakeOffsetTime = (5/3) * RealViewShakeTime;
	RealEarthquakeInterval = (RandRange(EarthquakeInterval.Min, EarthquakeInterval.Max));	
	
	if(Enabled)
		SetTimer(0.5,true);
}

simulated function Trigger( actor Other, pawn EventInstigator )
{
	if(Enabled)
	{	
		Enabled = false;
		SetTimer(0.0, false);
	}
	else
	{
		Enabled = true;
		SetTimer(0.5, true);
	}
}

simulated function Timer()		
{
	Current = Current + 0.5;
	if (Current >= RealEarthquakeInterval)
	{
		Rumble();
		RumbleTime = 0;
		bIsRumbling = true;
		RealEarthquakeInterval = (RandRange(EarthquakeInterval.Min, EarthquakeInterval.Max));
		Current = 0;
	}		
	
	if (bIsRumbling)
	{
		if (RumbleTime < EarthquakeLengthOfTime)
		{
			RumbleTime = RumbleTime + 0.5;
			KickMe();
		}
		else
		{
			bIsRumbling = false;
		}
	}
}

simulated function KickMe()
{
	local Pawn 				Me;
	local ONSWheeledCraft	Car;
	local ONSHoverTank		Tank;	
	local vector 			KickDirection;
	local float 			Dist, Scale;
	local vector			Kicker;
	local KarmaParams KP;
	
	Kicker.X = (RandRange(-0.8,0.8));
	Kicker.Y = (RandRange(-0.8,0.8));
	Kicker.Z = (RandRange(0.5,1));
	
	foreach CollidingActors(class'ONSWheeledCraft', Car, EarthquakeRadius, Location) 
	{
		if ((Car != None) && (Car.bVehicleOnGround))
		{
			Dist = VSize(Location - Car.Location);
			
			if (Dist < EarthquakeRadius)
				Scale = 1.0;
			else
				Scale = (EarthquakeRadius*2.5 - Dist) / (EarthquakeRadius);
				
			KickDirection = Kicker * (90000 * Scale);
			Car.KAddImpulse(KickDirection, Car.Location);
		}
	}
	
	foreach CollidingActors(class'ONSHoverTank', Tank, EarthquakeRadius, Location) 
	{
		if (Tank != None) 
		{
			KP = KarmaParams(Tank.KParams);
			
			if	(KP.kMaxSpeed == Tank.MaxGroundSpeed)
			{
				Dist = VSize(Location - Tank.Location);
			
				if (Dist < EarthquakeRadius)
					Scale = 1.0;
				else
					Scale = (EarthquakeRadius*2.5 - Dist) / (EarthquakeRadius);
				
				KickDirection = Kicker * (250000 * Scale);
				Tank.KAddImpulse(KickDirection, Tank.Location);
			}
		}
	}
		
	foreach CollidingActors(class'Pawn', Me, EarthquakeRadius, Location) 
	{
		if (Me.Physics == PHYS_Walking)
		{
			Dist = VSize(Location - Me.Location);
			
			if (Dist < EarthquakeRadius)
					Scale = 1.0;
			else
				Scale = (EarthquakeRadius*2.5 - Dist) / (EarthquakeRadius);
				
			KickDirection = Kicker * (200 * Scale);
			Me.AddVelocity(KickDirection);
       	}		
	}
}
	
simulated event Rumble()
{
	local PlayerController PC;
	local float Dist, Scale;

	//viewshake
	if (Level.NetMode != NM_DedicatedServer)
	{
		PC = Level.GetLocalPlayerController();
		if (PC != None)
		{
			Dist = VSize(Location - PC.Location);
			if (Dist < EarthquakeRadius * 2.5)
			{
				if (Dist < EarthquakeRadius)
					Scale = 1.0;
				else
					Scale = (EarthquakeRadius*2.5 - Dist) / (EarthquakeRadius);
				PC.ShakeView(ShakeRotMag*Scale, ShakeRotRate, RealViewShakeTime, ShakeOffsetMag*Scale, ShakeOffsetRate, ShakeOffsetTime);
			}
		}
	}
}
	

defaultproperties
{
     EarthquakeInterval=(Min=15.000000,Max=30.000000)
     EarthquakeRadius=5000.000000
     EarthquakeLengthOfTime=6.000000
     ShakeRotMag=(Z=500.000000)
     ShakeRotRate=(Z=5000.000000)
     ShakeOffsetMag=(Z=20.000000)
     ShakeOffsetRate=(Z=400.000000)
     bNoDelete=True
     Texture=Texture'DWeather-tex.Icons.earthquakeicon'
     bMovable=False
     bCollideActors=True
}
