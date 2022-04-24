//=============================================================================
//  DWMeteor
//  A Meteor spawner
//  By Mark 'MarZer' Gillard
//=============================================================================
class DWMeteor extends DWParent
	placeable;
	
#exec OBJ LOAD FILE="..\StaticMeshes\DWeather-smesh.usx"
#exec OBJ LOAD FILE="..\Textures\DWeather-Tex.utx"

//=============================================================================
// Declarations.
//=============================================================================	
struct ChunkInfo
{
	var()  bool 				bUseDefaultChunks;
	var()  bool					bSpawnChunks;
	var()  class<Projectile>	ChunkClass;
	var()  IntRange				ChunkAmount;
};

struct DeathStuff
{
	var()  class<DamageType>	DamageType;
    var()  bool					bUseDefaultSettings;
};

struct Trails
{
	var()  class<Emitter> 	 	Emitter;	
};

struct MeteorProp
{
	var()  StaticMesh 			Mesh;
	var()  Sound 				FlightSound;
	var()  float 				MeshDrawScale;
	var()  float				RandomSpinAmount;
	var()  float				Speed;
	var()  class<Emitter>		ExplosionEmitter;
	var()  Sound				ExplosionSound;
	var()  ChunkInfo			ExplosionChunks;
	var()  float				Damage;
	var()  float				DamageRadius;
	var()  DeathStuff			DeathSettings;
	var()  array<Trails>		TrailEmitters;
	var()  float				LifeSpan;
	var()  bool					bMakeDefaultMeteor;
};

struct Stuff
{
	var()  bool 				Roaming, RandomReflectionAngle, Enabled;
	var()  float 				RoamingSpeed;
	var()  range	 			SpawnInterval;
	var()  array<MeteorProp> 	MeteorProperties;
	var()  bool 				bUseCustomMeteors;	
};

var() 	Stuff 					Settings;
var 	float 					ActualSpawnInterval;
var 	vector 					RotVec;
var 	rotator 				newRot;
var 	rotator 				Initial;
var() 	enum					EOnTrigger {OT_SpawnMeteor,OT_ToggleEnabled,} OnTrigger;

//=============================================================================
// Replication.
//=============================================================================
replication
{
    reliable if ( Role == ROLE_Authority )
    Settings, ChangeHeading, SpawnMeteor;
}

//=============================================================================
// Post begin play.
//=============================================================================
simulated function PostBeginPlay()
{
	if(Settings.Roaming)
	{
		Initial.Pitch = 0;
		Initial.Yaw = Rotation.Yaw;
		Initial.Roll = 0;
		SetRotation(Initial);
		
		RotVec = normal(vector(Rotation)) * Settings.RoamingSpeed;
		RotVec.Z = 0;
		Velocity = RotVec;
	}
	
	ActualSpawnInterval = RandRange(Settings.SpawnInterval.Min, Settings.SpawnInterval.Max);
	
	if(Settings.Enabled)
		SetTimer(ActualSpawnInterval, false);
}

//=============================================================================
// ChangeHeading()
//
// Changes the direction in which the DWMeteor actor is facing and
// proceeds in that new direction.
//=============================================================================
simulated function ChangeHeading(bool Random)
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
	Velocity = normal(vector(newRot)) * Settings.RoamingSpeed;
}

//=============================================================================
// SpawnMeteor()
//
// The whole reason we are here, right? WE WANT METEORS!
// Spawns them with default properties or can attribute them new properties
// from elements of a randomly chosen array.
//=============================================================================
simulated function SpawnMeteor()
{
	local rotator PitchRotator;
	local DWMeteorProjectile Meteor;
	local int i;
	local int n;
	local int p;
	
	if(Settings.Roaming)
	{
		PitchRotator.Pitch = -16384 * RandRange(0.6, 1.4);
		PitchRotator.Yaw = RandRange(-32768, 32768);
	}
	else
	{
		PitchRotator = Rotation;
	}
	
	if (!Settings.bUseCustomMeteors)
		spawn(class'DWMeteorProjectile',,,Location,PitchRotator);
	else
	{
		i = Rand(Settings.MeteorProperties.Length);
		n = Settings.MeteorProperties[i].TrailEmitters.Length;
		
		if(Settings.MeteorProperties[i].bMakeDefaultMeteor)
			spawn(class'DWMeteorProjectile',,,Location,PitchRotator);
		else
		{
			Meteor = spawn(class'DWMeteorProjectile',,,Location,PitchRotator);
		
			Meteor.LifeSpan = Settings.MeteorProperties[i].LifeSpan;
		
			if (!Settings.MeteorProperties[i].DeathSettings.bUseDefaultSettings)
				Meteor.MyDamageType = Settings.MeteorProperties[i].DeathSettings.DamageType;
		
			Meteor.SetStaticMesh(Settings.MeteorProperties[i].Mesh);
			Meteor.SetDrawScale(Settings.MeteorProperties[i].MeshDrawScale);

			Meteor.AmbientSound = Settings.MeteorProperties[i].FlightSound;
		
			if(n > 0)
			{
				Meteor.FlyingEffect.Destroy();
		
				for (p=0; p<n; p++)
				{
					Meteor.FlyingEffect = spawn(Settings.MeteorProperties[i].TrailEmitters[p].Emitter, self);
					Meteor.FlyingEffect.SetBase(Meteor);
					Meteor.FlyingEffect.LifeSpan = Settings.MeteorProperties[i].LifeSpan;
				}

			}
		
			Meteor.Velocity = Settings.MeteorProperties[i].Speed * vector(Meteor.Rotation);	
		
			Meteor.ExplosionClass = Settings.MeteorProperties[i].ExplosionEmitter;
			Meteor.ExplosionSound = Settings.MeteorProperties[i].ExplosionSound;
			Meteor.Damage = Settings.MeteorProperties[i].Damage;
			Meteor.DamageRadius = Settings.MeteorProperties[i].DamageRadius;
		
			if(Settings.MeteorProperties[i].ExplosionChunks.bSpawnChunks)
			{
				if(!Settings.MeteorProperties[i].ExplosionChunks.bUseDefaultChunks)
				{
					Meteor.ChunkNumber = RandRange(Settings.MeteorProperties[i].ExplosionChunks.ChunkAmount.Min, Settings.MeteorProperties[i].ExplosionChunks.ChunkAmount.Max) + 1;
					Meteor.ChunkClass = Settings.MeteorProperties[i].ExplosionChunks.ChunkClass;
				}
			}
			else
				Meteor.ChunkNumber = 0;
			
			Meteor.RandSpin(Settings.MeteorProperties[i].RandomSpinAmount);
		}
	}
}

//=============================================================================
// HitWall()
//
// What happens when the DWMeteor hits world geometry.
//=============================================================================
simulated function HitWall( vector HitNormal, actor Wall )
{
	ChangeHeading(Settings.RandomReflectionAngle);
}

//=============================================================================
// Trigger()
//=============================================================================
simulated function Timer()
{
	SpawnMeteor();

	ActualSpawnInterval = RandRange(Settings.SpawnInterval.Min, Settings.SpawnInterval.Max);
	SetTimer(ActualSpawnInterval, false);
}
	
//=============================================================================
// Trigger()
//=============================================================================
simulated function Trigger( actor Other, Pawn EventInstigator )
{
	if(OnTrigger == OT_SpawnMeteor)
		SpawnMeteor();
	else
	{
		if(Settings.Enabled)
		{	
			Settings.Enabled = false;
			SetTimer(0.0, false);
		}
		else
		{
			Settings.Enabled = true;
			SetTimer(ActualSpawnInterval, false);
		}
	}
}

//=============================================================================
// Properties.
//=============================================================================

defaultproperties
{
	Settings=(Roaming=True,RandomReflectionAngle=True,Enabled=True,RoamingSpeed=1500.000000,SpawnInterval=(Min=4.000000,Max=10.000000))
	OnTrigger=OT_ToggleEnabled
	bNoDelete=True
	bUpdateSimulatedPosition=True
	Physics=PHYS_Projectile
	Texture=Texture'DWeather-tex.Icons.meteoricon'
	CollisionRadius=3.000000
	CollisionHeight=3.000000
	bCollideActors=True
	bCollideWorld=True
	bUseCylinderCollision=True
	bDirectional=True
	bIsEffectedByWind=true      
}
