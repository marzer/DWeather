//=============================================================================
//  DWHail
//  A Hail spawner
//  By Mark 'MarZer' Gillard
//=============================================================================
class DWHail extends DWParent
	placeable;
	
#exec OBJ LOAD FILE="..\StaticMeshes\DWeather-smesh.usx"
#exec OBJ LOAD FILE="..\Textures\DWeather-Tex.utx"

var()	IntRange	NumberSpawned;
var()	range		SpawnInterval;
var()	SRange		SpawnRange;
var   	float  		ActualInterval;
var   	int 		ActualNumberSpawned;
var() 	bool 		Enabled;
var		vector		Windy; //the wind

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
	SpawnHail();
	ActualInterval = RandRange(SpawnInterval.Min, SpawnInterval.Max);
	SetTimer(ActualInterval, false);
}

simulated function SpawnHail()
{
	local vector Start;
    local int i;
    local DWHailChunk NewChunk;
	
    ActualNumberSpawned = RandRange(NumberSpawned.Min, NumberSpawned.Max) + 1;

	if ( Role == ROLE_Authority )
	{
		for (i=0; i < ActualNumberSpawned; i++)
		{
			Start.X = Location.X + RandRange(SpawnRange.XMin, SpawnRange.XMax);
    		Start.Y = Location.Y + RandRange(SpawnRange.YMin, SpawnRange.YMax);
    		Start.Z = Location.Z;
			
			NewChunk = spawn( class 'DWHailChunk',, '', Start, Rotation);
			NewChunk.UpdateWind(Windy); //only gets called once per chunk
		}
	}
}

simulated function UpdateWind(vector Wind)
{
	Windy = Wind * 2; //keep track of the wind for the chunks, and give em a boost
}

defaultproperties
{
	NumberSpawned=(Min=12,Max=24)
	SpawnInterval=(Min=0.080000,Max=0.160000)
	Enabled=True
	bNoDelete=True
	Texture=Texture'DWeather-tex.Icons.hailicon'
	bMovable=False
	bDirectional=True
	bIsEffectedByWind=true 
}
