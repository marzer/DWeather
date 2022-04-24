//=============================================================================
//  DWRealRain
//  A Rain spawner - Real Rain!
//  By Mark 'MarZer' Gillard
//=============================================================================
class DWRealRain extends Actor
	placeable;

#exec OBJ LOAD FILE="..\StaticMeshes\DWeather-smesh.usx"		
#exec OBJ LOAD FILE="..\Textures\DWeather-Tex.utx"

struct SRange
{
	var() config float XMin, XMax, YMin, YMax;
};

struct SInterval
{
	var() config float Min, Max;
};


struct SNumber
{
	var() config int NMin, NMax;
};

var()	SNumber		NumberSpawned;
var()	SInterval	SpawnInterval;
var()	SRange		SpawnRange;
var   	float  		ActualInterval;
var   	int 		ActualNumberSpawned;
var() 	bool 		Enabled;

simulated function PostBeginPlay()
{
	if(Enabled)
	{
		ActualInterval = RandRange(SpawnInterval.Min, SpawnInterval.Max);
		SetTimer(ActualInterval, false);
	}
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
		ActualInterval = RandRange(SpawnInterval.Min, SpawnInterval.Max);
		SetTimer(ActualInterval, false);
		Enabled = true;
	}
}

simulated function Timer()
{
	SpawnRain();
	ActualInterval = RandRange(SpawnInterval.Min, SpawnInterval.Max);
	SetTimer(ActualInterval, false);
}

simulated function SpawnRain()
{
	local vector Start;
    local int i;
    local DWRainDrop NewDrop;
	
    ActualNumberSpawned = RandRange(NumberSpawned.NMin, NumberSpawned.NMax) + 1;

	if ( Role == ROLE_Authority )
	{
		for (i=0; i < ActualNumberSpawned; i++)
		{
			Start.X = Location.X + RandRange(SpawnRange.XMin, SpawnRange.XMax);
    		Start.Y = Location.Y + RandRange(SpawnRange.YMin, SpawnRange.YMax);
    		Start.Z = Location.Z;
			
			NewDrop = spawn( class 'DWRainDrop',, '', Start, Rotation);
		}
	}
}

defaultproperties
{
   	Texture=Texture'DWeather-Tex.Icons.hailicon'

    bDirectional=true
    bAlwaysRelevant=true
    bNoDelete=true
	bStatic=false
 	bMovable=false
	bNetTemporary=false
    bHidden=true
    Enabled=true
    
    RemoteRole=ROLE_SimulatedProxy
}