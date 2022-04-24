//=============================================================================
// DWMeteorFlyingRock.
//=============================================================================
class DWMeteorFlyingRock extends Projectile;

#exec OBJ LOAD FILE="..\StaticMeshes\DWeather-smesh.usx"

var Emitter FlyingEffect;
var class<Emitter> FlyingEffectClass;

var byte Bounces;
var float DamageAtten;
var sound ImpactSounds[6];
var vector Dir;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        Bounces;
}

simulated function Destroyed()
{
	if ( FlyingEffect != None )
		FlyingEffect.Kill();
	
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
    local float r;
    local float DSM;

    DSM = RandRange(0.8, 1.2);
    self.SetDrawScale(DSM);
    
    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( !PhysicsVolume.bWaterVolume )
        {
   			FlyingEffect = spawn(FlyingEffectClass, self);
	
			if (FlyingEffect != None)
			{
				FlyingEffect.SetBase(self); 
				FlyingEffect.SetDrawScale(DSM);
			}
        }
            
    }

	Dir = vector(Rotation);
	Velocity = speed * Dir;
    
    if (PhysicsVolume.bWaterVolume)
        Velocity *= 0.65;

    r = FRand();
    if (r > 0.75)
        Bounces = 2;
    else if (r > 0.25)
        Bounces = 1;
    else
        Bounces = 0;

    SetRotation(RotRand());
	RandSpin(100000);
    
    Super.PostBeginPlay();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    if ( (DWMeteorFlyingRock(Other) == None) && ((Physics == PHYS_Falling) || (Other != Instigator)) )
    {
        speed = VSize(Velocity);
        if ( speed > 200 )
        {
            if ( Role == ROLE_Authority )
			{
				if ( Instigator == None || Instigator.Controller == None )
					Other.SetDelayedDamageInstigatorController( InstigatorController );

                Other.TakeDamage( Max(5, Damage - DamageAtten*FMax(0,(default.LifeSpan - LifeSpan - 1))), Instigator, HitLocation,
                    (MomentumTransfer * Velocity/speed), MyDamageType );
			}
        }
        Destroy();
    }
}

simulated function Landed( Vector HitNormal )
{
    SetPhysics(PHYS_None);
    LifeSpan = 1.0;
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    if ( !Wall.bStatic && !Wall.bWorldGeometry 
		&& ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
    {
        if ( Level.NetMode != NM_Client )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController( InstigatorController );
            Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
        Destroy();
        return;
    }

    SetPhysics(PHYS_Falling);
	if (Bounces > 0)
    {
		if ( !Level.bDropDetail && (FRand() < 0.4) )
			Playsound(ImpactSounds[Rand(6)]);

        Velocity = 0.65 * (Velocity - 2.0*HitNormal*(Velocity dot HitNormal));
        Bounces = Bounces - 1;
        return;
    }
	bBounce = false;
}

simulated function PhysicsVolumeChange( PhysicsVolume Volume )
{
    if (Volume.bWaterVolume)
    {
        Velocity *= 0.65;
        FlyingEffect.Kill();        
    }
}

defaultproperties
{
     FlyingEffectClass=Class'DWeather.DWMeteorFlyingRockTrail'
     Bounces=2
     DamageAtten=3.000000
     ImpactSounds(0)=Sound'XEffects.Impact4Snd'
     ImpactSounds(1)=Sound'XEffects.Impact6Snd'
     ImpactSounds(2)=Sound'XEffects.Impact7Snd'
     ImpactSounds(3)=Sound'XEffects.Impact3'
     ImpactSounds(4)=Sound'XEffects.Impact1'
     ImpactSounds(5)=Sound'XEffects.Impact2'
     Speed=2000.000000
     Damage=50.000000
     MomentumTransfer=3000.000000
     MyDamageType=Class'DWeather.DamTypeMeteorFlyingRock'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DWeather-smesh.Meteor.rock-chunk'
     CullDistance=3000.000000
     Physics=PHYS_Falling
     LifeSpan=10.000000
     AmbientGlow=254
     Style=STY_Alpha
     bBounce=True
     bFixedRotationDir=True
     RotationRate=(Pitch=800,Yaw=1600,Roll=1000)
     DesiredRotation=(Pitch=400,Yaw=1200,Roll=600)
}
