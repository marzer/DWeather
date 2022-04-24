//=============================================================================
// DWHailChunk.
//=============================================================================
class DWHailChunk extends Projectile;

#exec OBJ LOAD FILE="..\StaticMeshes\DWeather-smesh.usx"

var byte Bounces;
var float DamageAtten;
var sound ImpactSounds[6];
var float DrawScaleMod;
var vector Dir;
//var vector Wind;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        Bounces;
}

simulated function Destroyed()
{
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
    local float r;

    self.SetDrawScale(RandRange(0.15, 0.35));
	DrawScaleMod = self.DrawScale;
    
	Dir = vector(Rotation);
	Velocity = speed * Dir;
    
    if (PhysicsVolume.bWaterVolume)
        Velocity *= 0.65;

    r = FRand();
    if (r > 0.5)
        Bounces = 2;
    else
        Bounces = 1;

    Super.PostBeginPlay();
    SetRotation(RotRand());
	RandSpin(100000);
}

simulated function UpdateWind(vector Wind) //only gets called once
{
	Velocity += Wind; //updates the speed to reflect the wind
}

simulated function Tick (float DeltaTime)
{
	if (PhysicsVolume.bWaterVolume)
	{
		DrawScaleMod *= 0.95;
		self.SetDrawScale(DrawScaleMod);
	}
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    if ( (DWHailChunk(Other) == None) && ((Physics == PHYS_Falling) || (Other != Instigator)) )
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
    local vector RandomVector;
	
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
		if ( !Level.bDropDetail && (FRand() < 0.2) )
			Playsound(ImpactSounds[Rand(6)]);
		
		RandomVector.X = RandRange(0,1.5);
		RandomVector.Y = RandRange(0,1.5);
		RandomVector.Z = RandRange(0.01,0.1);
		
        Velocity = RandomVector * (Velocity - 2.0*HitNormal*(Velocity dot HitNormal));
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
    }
}

defaultproperties
{
     Bounces=2
     DamageAtten=3.000000
     ImpactSounds(0)=Sound'XEffects.Impact4Snd'
     ImpactSounds(1)=Sound'XEffects.Impact6Snd'
     ImpactSounds(2)=Sound'XEffects.Impact7Snd'
     ImpactSounds(3)=Sound'XEffects.Impact3'
     ImpactSounds(4)=Sound'XEffects.Impact1'
     ImpactSounds(5)=Sound'XEffects.Impact2'
     Speed=3000.000000
     MaxSpeed=3000.000000
     Damage=10.000000
     MomentumTransfer=3000.000000
     MyDamageType=Class'DWeather.DamTypeHailChunk'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DWeather-smesh.Hail.hail-mesh'
     CullDistance=4500.000000
     Physics=PHYS_Falling
     LifeSpan=10.000000
     DrawScale=0.1250000
     AmbientGlow=140
     Style=STY_Alpha
     bBounce=True
     bFixedRotationDir=True
     RotationRate=(Pitch=800,Yaw=1600,Roll=1000)
     DesiredRotation=(Pitch=400,Yaw=1200,Roll=600)
}
