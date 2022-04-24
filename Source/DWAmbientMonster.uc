//=============================================================================
// DWAmbientMonster.
// Created by Mark 'MarZer' Gillard
//=============================================================================
class DWAmbientMonster extends DWParent
	  placeable;

#exec OBJ LOAD FILE=DWeather-Tex.utx	  

struct MonAllow
{
	var () bool SkaarjPupae;
	var () bool Razorfly;
	var () bool Manta;
};
	
var()	MonAllow				AllowedMonsters;
var 	array<class<Monster> >	LoadMonsterClass;
var 	array<class<Monster> >	MonsterClass;
var() 	float 					RespawnTime;
var 	byte 					NumMonsters;
var() 	byte 					MaxMonsters;
var 	array<PathNode> 		PathNodes;
var		byte 					ClassCount;
var() 	name 					MonsterTag;
var 	Pawn 					ChildMonster;
var()   bool 					Enabled;
var() 	enum					EOnTrigger {OT_SpawnMonster,OT_ToggleEnabled,} OnTrigger;

simulated event PreBeginPlay()
{
    super.PreBeginPlay();
    
    if(Enabled)
		SetTimer(RespawnTime,true);
		
    ClassCount=0;
    if( AllowedMonsters.SkaarjPupae){MonsterClass[ClassCount]=LoadMonsterClass[0];ClassCount++;}
    if( AllowedMonsters.Razorfly){MonsterClass[ClassCount]=LoadMonsterClass[1];ClassCount++;}
    if( AllowedMonsters.Manta){MonsterClass[ClassCount]=LoadMonsterClass[2];ClassCount++;}
}

simulated function PostBeginPlay()
{
	local NavigationPoint N;
	super.PostBeginPlay();
    SetGameRules();
    
    if (RespawnTime > 0 && MaxMonsters > 0 && MonsterClass.length > 0)
	{
		for (N = Level.NavigationPointList; N != None; N = N.NextNavigationPoint)
			if (PathNode(N) != None && !N.IsA('FlyingPathNode'))
				PathNodes[PathNodes.length] = PathNode(N);
	}
	else
		Destroy();
}

simulated function SetGameRules()
{
    local DWAmbientMonsterRULESSpawner MGR;
    ForEach DynamicActors ( class'DWAmbientMonsterRULESSpawner', MGR)
    {
        if (MGR != none)
        {
           break;
        }
    }
    if (MGR != none)
    {
        return;
    }
    MGR=spawn(class'DWAmbientMonsterRULESSpawner',,,Location);
}
 
simulated function Timer()
{
	AddMonster();
}

simulated function AddMonster()
{
	local Pawn NewMonster;
	local class<Monster> NewMonsterClass;
    local Monster CountClass;
        NumMonsters=0;
        foreach AllActors( class 'Monster' , CountClass )
        {
         NumMonsters++;
        }
	if(NumMonsters<MaxMonsters+1)
	{
		NewMonsterClass = MonsterClass[Rand(ClassCount)];
		NewMonster = spawn(NewMonsterClass,,, PathNodes[Rand(PathNodes.length)].Location);
	
		ChildMonster = NewMonster;
    	MonsterSpawned();
	}
}

simulated function TriggerAddMonster()
{
	local Pawn NewMonster;
	local class<Monster> NewMonsterClass;
    local Monster CountClass;
        
    NumMonsters=0;
        
    foreach AllActors( class 'Monster' , CountClass )
    {
       	NumMonsters++;
    }
        
	NewMonsterClass = MonsterClass[Rand(ClassCount)];
	NewMonster = spawn(NewMonsterClass,,, PathNodes[Rand(PathNodes.length)].Location);
	
	ChildMonster = NewMonster;
    MonsterSpawned();
}

simulated function MonsterSpawned()
{
	if ( MonsterTag != '' )
		ChildMonster.Tag = MonsterTag;
}

simulated function Trigger( actor Other, Pawn EventInstigator )
{
	if(OnTrigger == OT_SpawnMonster)
		TriggerAddMonster();
	else
	{
		if(Enabled)
		{	
			Enabled = false;
			SetTimer(0.0, false);
		}
		else
		{
			Enabled = true;
			SetTimer(RespawnTime, true);
		}
	}
}

defaultproperties
{
     AllowedMonsters=(SkaarjPupae=True,Razorfly=True,Manta=True)
     LoadMonsterClass(0)=Class'DWeather.AmbientSkaarjPupae'
     LoadMonsterClass(1)=Class'DWeather.AmbientRazorfly'
     LoadMonsterClass(2)=Class'DWeather.AmbientManta'
     RespawnTime=10.000000
     MaxMonsters=6
     Enabled=True
     bNoDelete=True
     Texture=Texture'DWeather-tex.Icons.monstericon'
}
