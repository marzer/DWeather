//=============================================================================
//  DWLightningTarget: Target for DWLightning
//  Lightning has to strike somewhere, right?
//  By Mark 'MarZer' Gillard
//=============================================================================
class DWLightningTarget extends DWParent
		hidecategories(Collision,Display,Force,Karma,Advanced,Global,Object)
		placeable;

#exec OBJ LOAD FILE=DWeather-Tex.utx		
		
var float Current;
var float CalculationInterval;
var rotator Initial;
var DWLightningFearSpot PhearMeh;

replication
{
    reliable if ( Role == ROLE_Authority )
        Current, CalculationInterval, PhearMeh, StartFlash, StopFlash;
}

simulated function PostBeginPlay()
{
	Initial.Pitch = -16384;
	Initial.Yaw = 0;
	Initial.Roll = 0;
	
	LightHue = 0;
	LightSaturation = 255;
	LightRadius = 175;
	LightBrightness = 0;

	PhearMeh = spawn(class'DWLightningFearSpot',,,Location);
	PhearMeh.SetBase(self);
}

simulated function StartFlash()
{
	SetTimer(CalculationInterval, true);
	Spawn(class'DWLightingBANG',,,Location,Initial);
	LightBrightness = 150;
}
	
simulated function Trigger( actor Other, pawn EventInstigator )
{
	if (Other.IsA('DWLightning'))
		StartFlash();
}

simulated function StopFlash()
{
	Current = Current + CalculationInterval;
	
	if (Current > 0.2)
	{
    	LightBrightness = 0;
		SetTimer(0.0, false);
    	Current = 0.0;
	}
}

simulated function Timer()
{
	StopFlash();
}	

defaultproperties
{
     CalculationInterval=0.050000
     LightType=LT_Steady
     LightSaturation=255
     LightRadius=175.000000
     bNoDelete=True
     bDynamicLight=True
     bUpdateSimulatedPosition=True
     Texture=Texture'DWeather-tex.Icons.lightningtargeticon'
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
}
