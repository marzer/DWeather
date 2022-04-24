//=============================================================================
//  DWParent: Parent Class of Dynamic Weather Actor
//  Contains all the necessary functions for the children... bless 'em
//  By Mark 'MarZer' Gillard, 
//
//  Props to DJPaul, Wormbo, Joe Birney and the CUT2 team, Shambler
//  for assisting me with my coding-n00bness!
//=============================================================================
class DWParent extends Actor
		abstract;
		
//=============================================================================
//  Declarations
//=============================================================================
struct IntRange
{
	var()  int					Min; 
	var()  int					Max;
};

struct SRange
{
	var()  float 				XMin;
	var()  float				XMax;
	var()  float				YMin;
	var()  float				YMax;
};
		
struct	ColourRange
{
	var()  color				Max;
	var()  color				Min;
};

var float 						KickUpSpeed;
var float 						DamageRadius;
var float 						Damage;
var class<DamageType>	 		MyDamageType;
var	bool						bIsEffectedByWind;

//=============================================================================
//  Replication
//=============================================================================
replication
{
    reliable if ( Role == ROLE_Authority )
		CosWave, Charge, ColourMap, RGBToHLS, ReturnFadeColour, RandomColour;
}		
		
//=============================================================================
//  Operators
//=============================================================================
static final operator(18) int : (int A, int B)
{
  return (A + B) / 2;
}

static final operator(16) color / ( color A, float B )
{
  local Color Result;
  Result.R = A.R / B;
  Result.G = A.G / B;
  Result.B = A.B / B;
  return Result;
}

static final operator(22) color Mix ( color A, color B )
{
  local color Result;
  Result.R = A.R : B.R;
  Result.G = A.G : B.G;
  Result.B = A.B : B.B;
  return Result;
}

//=============================================================================
//  Maths-Time Functions
//=============================================================================
simulated function float CosWave (float M, float N, float X, float T, bool Inverse) 
{
	local float Y;
	if (!Inverse)
	{
		Y = (((M - N) * Cos(2 * Pi * (1 / (2 * T)) * X)) / 2) + (M : N);
	}
	else
	{
		Y = (((M - N) * -Cos(2 * Pi * (1 / (2 * T)) * X)) / 2) + (M : N);
	}
	return Y;
}

simulated function float Charge (float I, float C, bool ChargingUp)
{
	local float Y;
	if (ChargingUp)
	{
		Y = C + I;
	}
	else
	{
		Y = C - I;
	}
	return Y;
}

simulated function UpdateWind(vector Wind) {}

//=============================================================================
//  Colour Functions
//=============================================================================
simulated function vector ColourMap ( vector rgb)
 {
  local float min;
  local float max;
  local vector hls;
  local float r,g,b,h,l,s;

  rgb.x= Fclamp(rgb.x,0,1);
  rgb.y= Fclamp(rgb.y,0,1);
  rgb.z= Fclamp(rgb.z,0,1);

  r=rgb.x;
  g=rgb.y;
  b=rgb.z;
 
  max = Fmax(fmax(r,g),b);
  min = Fmin(Fmin(r,g),b);

  l = (max+min)/2;

  if (max==min)
   {
     s = 0;
     h = 0;
   }
  else
   {
    if (l < 0.5)  s =(max-min)/(max+min);
    If (l >=0.5)  s =(max-min)/(2.0-max-min);
   }
  
  If (R == max)  h  = (G-B)/(max-min);
  If (G == max) h = 2.0 + (B-R)/(max-min);
  If (B == max)    h = 4.0 + (R-G)/(max-min);

  hls.x=(h/6)*255;
  hls.y=(l*255);
  hls.z=(s*127);

  return( hls);
}

simulated function RGBToHLS(color InRGB, out byte Hue, out byte Luminance, out byte Saturation)
{
    local vector RGB, HLS;
    
    RGB.X = InRGB.R / 255.0;
    RGB.Y = InRGB.G / 255.0;
    RGB.Z = InRGB.B / 255.0;
    HLS = colourmap(RGB);
    Hue = HLS.X;
    Luminance = HLS.Y;
    Saturation = HLS.Z;
}
		
simulated function color ReturnFadeColour(color MinColour, color MaxColour, float X, float T, bool Inverse)
{
	local color ReturnCol;
	local float Y;
	
	if(Inverse == false)
	{
		Y = ((Cos(2 * Pi * (1 / (2 * T)) * X)) / 2) + 0.5;
	}
	else
	{
		Y = ((-Cos(2 * Pi * (1 / (2 * T)) * X)) / 2) + 0.5;
	}
	
	ReturnCol.R = float(MaxColour.R - MinColour.R) * Y;
	ReturnCol.G = float(MaxColour.G - MinColour.G) * Y;
	ReturnCol.B = float(MaxColour.B - MinColour.B) * Y;
	Return MinColour + ReturnCol;
}

simulated function color RandomColour(color MinColour, color MaxColour)
{
	local color ReturnCol;
	local float Y;
	Y = RandRange(0, 1);
	ReturnCol.R = float(MaxColour.R - MinColour.R) * Y;
	ReturnCol.G = float(MaxColour.G - MinColour.G) * Y;
	ReturnCol.B = float(MaxColour.B - MinColour.B) * Y;
	Return MinColour + ReturnCol;
}

//=============================================================================
// Actor-specific functions
//
// SuckInActors (and the smaller required functions it requires: IsMovable, 
// IsVisible, DamageObject and HasRespawnProtection) come thanks to the 
// Chaos team. Cheers guys!
//=============================================================================
simulated function bool IsMovable(Actor Other)
{
	if ( Other.bStatic || Other.bNoDelete )
		return false;

	if ( Other.IsA('GameObject') && (Other.Physics == PHYS_None || Other.Physics == PHYS_Rotating) )
		return Other.IsInState('Dropped') || Other.IsInState('Home');

	if ( Other.IsA('UnrealPawn') && (Other.Physics == PHYS_Walking
			|| Other.Physics == PHYS_Falling || Other.Physics == PHYS_Swimming
			|| Other.Physics == PHYS_Flying || Other.Physics == PHYS_Spider
			|| Other.Physics == PHYS_Ladder || Other.Physics == PHYS_KarmaRagDoll) )
		return true;

	if ( Other.IsA('Pickup') && Pickup(Other).bDropped )
		return true;

	return Other.Physics == PHYS_Projectile || Other.Physics == PHYS_Falling || Other.Physics == PHYS_Karma;
}

simulated function bool IsVisible(Actor Other)
{
	return !Other.bHidden && (Other.DrawType == DT_Mesh || Other.DrawType == DT_StaticMesh
			|| Other.DrawType == DT_Sprite || Other.DrawType == DT_SpriteAnimOnce
			|| Other.DrawType == DT_RopeSprite || Other.DrawType == DT_VerticalSprite);
}

simulated function DamageObject(Actor Other, float DistToCenter)
{
	if ( Other == None || Other.IsA('Pawn') && Other.Role < ROLE_Authority )
		return;

	if ( !Other.IsA('Pawn')
			|| Pawn(Other).Health > 0 && !Pawn(Other).InGodMode() && !HasRespawnProtection(Pawn(Other)) )
	{
		Other.TakeDamage(Damage * (1 - DistToCenter / DamageRadius), Instigator,
				Other.Location, vect(0,0,0), MyDamageType);
	}
}

simulated function bool HasRespawnProtection(Pawn Other)
{
	// only works in DeathMatch games
	if ( DeathMatch(Level.Game) == None )
		return false;

	// check for Epic's respawn protection
	if ( Level.TimeSeconds - Other.SpawnTime < DeathMatch(Level.Game).SpawnProtectionTime )
		return true;

	return false;

}

simulated function SuckInActors(float Gravity, float Range, float DeltaTime)
{
	local Actor AffectedActor;
	local Pawn AffectedPawn;
	local vector dir, ActorLocation;
	local float dist, strength, ActorSize;

	ForEach CollidingActors(class'Actor', AffectedActor, Range, Location)
    {
		if ( AffectedActor.IsA('DWTwister') || !IsMovable(AffectedActor) || !IsVisible(AffectedActor)	|| !FastTrace(AffectedActor.Location, Location) )
			continue;
			
		AffectedPawn = Pawn(AffectedActor);

		if ( AffectedActor.Physics == PHYS_Karma )
        {
			AffectedActor.KGetCOMPosition(ActorLocation);
			ActorSize = AffectedActor.GetRenderBoundingSphere().W * AffectedActor.DrawScale;
		}
		else 
		{
			ActorLocation = AffectedActor.Location;
			ActorSize = 0;
		}

		dir = Normal(Location - ActorLocation);
		dist = VSize(Location - ActorLocation);
		strength = Gravity * DeltaTime * (2.1 - 2 * Square(dist / Range));

		if ( AffectedActor.Physics == PHYS_Karma || AffectedActor.Physics == PHYS_KarmaRagdoll )
        {
		    if (AffectedPawn.IsA('SVehicle'))
                  	strength = strength/SVehicle(AffectedActor).VehicleMass;

            if ( !AffectedActor.KIsAwake() )
				AffectedActor.KWake();
			
			AffectedActor.KAddImpulse(dir * strength * AffectedActor.Mass * AffectedActor.KGetMass(), ActorLocation, 'bip01 Spine');
		}
		else if ( AffectedPawn != None )
        {
			if ( AffectedPawn.Physics == PHYS_Walking && dir.Z < 0 )
				dir.Z = KickUpSpeed / strength;
				
			AffectedPawn.AddVelocity(dir * strength);
		}
		else {
			if ( AffectedActor.Physics == PHYS_None || AffectedActor.Physics == PHYS_Rotating ) {
				if ( AffectedActor.IsA('GameObject') && AffectedActor.IsInState('Home') )
					AffectedActor.GotoState('Dropped');
				AffectedActor.SetPhysics(PHYS_Falling);
				AffectedActor.Velocity = vect(0,0,1) * KickUpSpeed;
			}

			if ( AffectedActor.Physics == PHYS_Projectile )
				AffectedActor.SetRotation(AffectedActor.Rotation - rotator(AffectedActor.Velocity));
			AffectedActor.Velocity += dir * strength;
			if ( AffectedActor.Physics == PHYS_Projectile )
				AffectedActor.SetRotation(AffectedActor.Rotation + rotator(AffectedActor.Velocity));
		}

		if ( dist < DamageRadius)
			DamageObject(AffectedActor, dist);
	}
}

defaultproperties
{
     MyDamageType=Class'DWeather.DamTypeNature'
     bHidden=true
     bAlwaysRelevant=true
     RemoteRole=ROLE_SimulatedProxy
     bIsEffectedByWind=false
     bStatic=false
}
