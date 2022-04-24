//=============================================================================
//  DWTwisterChild: Twister
//  BABIES!!!
//
//  By Mark 'MarZer' Gillard, BIG props to JB and the CUT2 team!
//=============================================================================
class DWTwisterChild extends Actor
	notplaceable;

//=============================================================================
// Declarations
//=============================================================================	
var float TornadoStrength;
var float TornadoRange;
var float KickUpSpeed;
var float DamageRadius;
var float Damage;
var class<DamageType>	 MyDamageType;

//=============================================================================
// Tick
//=============================================================================
simulated function Tick(float DeltaTime)
{
	SuckInActors(TornadoStrength, TornadoRange, DeltaTime);
}

//=============================================================================
// Is Movable?
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

//=============================================================================
// IsVisible
//=============================================================================
simulated function bool IsVisible(Actor Other)
{
	return !Other.bHidden && (Other.DrawType == DT_Mesh || Other.DrawType == DT_StaticMesh
			|| Other.DrawType == DT_Sprite || Other.DrawType == DT_SpriteAnimOnce
			|| Other.DrawType == DT_RopeSprite || Other.DrawType == DT_VerticalSprite);
}

//=============================================================================
// Damage the subject.
//=============================================================================
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

//=============================================================================
// HasRespawnProtection
//=============================================================================
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

//=============================================================================
// Pull in the actors.
//=============================================================================
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

//=============================================================================
// Properties
//=============================================================================

defaultproperties
{
     TornadoStrength=1000.000000
     TornadoRange=1000.000000
     KickUpSpeed=80.000000
     DamageRadius=250.000000
     Damage=5.000000
     bAlwaysRelevant=True
     bUpdateSimulatedPosition=True
     Physics=PHYS_Projectile
     RemoteRole=ROLE_SimulatedProxy
     AmbientSound=Sound'OutdoorAmbience.BThunder.Wind2'
     Texture=Texture'DWeather-tex.Icons.twistericon'
     bFullVolume=True
     SoundVolume=255
     bCollideActors=True
}
