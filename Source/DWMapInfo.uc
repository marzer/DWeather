//=============================================================================
//  DWMapInfo: Controls global DWeather settings in a map.
//
//  By Mark 'MarZer' Gillard
//=============================================================================
class DWMapInfo extends DWParent
	placeable;

#exec OBJ LOAD FILE="..\StaticMeshes\DWeather-smesh.usx"
#exec OBJ LOAD FILE="..\Textures\DWeather-Tex.utx"

struct WindStuff
{
	var() 	range				Speed;
	var() 	range				ChangeYawAmount;
	var		vector				Wind;
	var()	range				UpdateInterval;
	var		float				RandomYawMod;
	var		rotator				WindDirection;	
};

var()		WindStuff			WindInfo;
var()		bool				bUseWind;

simulated function PreBeginPlay()
{
	local float RealInterval;
	
	if(bUseWind)
	{
		WindInfo.WindDirection = Rotation;
	
		RealInterval = RandRange(WindInfo.UpdateInterval.Min, WindInfo.UpdateInterval.Max);
		if (RealInterval > 0)
			SetTimer( RealInterval, true );
		else if (RealInterval < 0)
			SetTimer( (RealInterval * -1), true );
		else
			SetTimer(1,true);
	}
}

simulated function Timer()
{
	local vector Dir;
	local float RealSpeed;
	local float RealInterval;
	local DWParent DWActor;
	
	WindInfo.RandomYawMod = RandRange(WindInfo.ChangeYawAmount.Min, WindInfo.ChangeYawAmount.Max);
	WindInfo.WindDirection.Yaw += WindInfo.RandomYawMod;
	RealSpeed = RandRange(WindInfo.Speed.Min, WindInfo.Speed.Max);
	
	Dir = vector(WindInfo.WindDirection);
	WindInfo.Wind = Dir * RealSpeed;
	
	foreach DynamicActors (class'DWParent', DWActor)
	{
		if (DWActor.bIsEffectedByWind)
			DWActor.UpdateWind(WindInfo.Wind);
	}
	
	RealInterval = RandRange(WindInfo.UpdateInterval.Min, WindInfo.UpdateInterval.Max);
	
	if (RealInterval > 0)
		SetTimer( RealInterval, true );
	else if (RealInterval < 0)
		SetTimer( (RealInterval * -1), true );
	else
		SetTimer(1,true);
}

defaultproperties
{
	DrawType=DT_Sprite
	bStatic=false
	bShadowCast=false
	bCollideActors=false
	bBlockActors=false
	bBlockKarma=false
	bWorldGeometry=false
	bAcceptsProjectors=false
    bUseDynamicLights=false
	bNoDelete=true
	bAlwaysRelevant=true
	bHidden=true
	bDirectional=true
	bUseWind=true
	bIsEffectedByWind=false
    WindInfo=(Speed=(Min=50.000000,Max=200.000000),ChangeYawAmount=(Min=-8000.000000,Max=8000.000000),UpdateInterval=(Min=0.800000,Max=1.500000))
}