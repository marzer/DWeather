//=============================================================================
// DWRainDrop.
//=============================================================================
class DWRainDrop extends Projectile;

#exec OBJ LOAD FILE="..\StaticMeshes\DWeather-smesh.usx"

var vector Dir;

simulated function Destroyed()
{
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	self.SetDrawScale(RandRange(0.0015, 0.0025));
    
	Dir = vector(Rotation);
	Velocity = speed * Dir;
    
    if (PhysicsVolume.bWaterVolume)
        Destroy();

    Super.PostBeginPlay();
}

simulated function Landed( Vector HitNormal )
{
   	spawn(class'DWRainDropSplash',,,Location,rotator(HitNormal));
   	Destroy();
}

simulated function HitWall( vector HitNormal, actor Wall )
{
   	spawn(class'DWRainDropSplash',,,Location,rotator(HitNormal));
   	Destroy();
}

simulated function PhysicsVolumeChange( PhysicsVolume Volume )
{
    if (Volume.bWaterVolume)
		Destroy();
}

defaultproperties
{
	Style=STY_Alpha
    ScaleGlow=1.0
    DrawType=DT_StaticMesh
	StaticMesh'DWeather-smesh.RealRain.Raindrop'
	DrawScale=0.004
    MyDamageType=class'DamTypeHailChunk'
	FluidSurfaceShootStrengthMod=1.f
    speed=4000.000000
    MaxSpeed=4000.000000
    Damage=0
    MomentumTransfer=3000
    Lifespan=10
    bFixedRotationDir=True    
    NetPriority=2.500000
    AmbientGlow=140
    CullDistance=1500.0
    Physics=PHYS_Falling
}


