//=============================================================================
//  DWLight: Dynamic Weather Light
//  Does tricks with light dynamically (HA TAKE THAT EPIC! :P)
//  By Mark 'MarZer' Gillard
//=============================================================================
class DWLight extends DWLightParent
	placeable
	hidecategories(Emitter,Force,Karma);

#exec OBJ LOAD FILE=DWeather-Tex.utx
		
//var() string Label;
var() float CalculationInterval;
var() float MaxBrightness;
var() float MinBrightness;
var() color MaxColour;
var() color MinColour;
var byte CurHue;
var byte CurSat;
var byte CurLum;
var() enum EMode {LM_Normal,LM_FireFlicker,} LightMode;
var color CurrentColour;
var float Mod;
var float DiffMod;
var() float Variance;
var float InitRad;
var float InitBright;
var() float RadialFluctuation;
var() bool InitiallyOn;

event PreBeginPlay()
{
	DiffMod = Variance * (MaxBrightness - MinBrightness);
	InitRad = LightRadius;
	InitBright = (MaxBrightness : MinBrightness);
	
	if (InitiallyOn)
	{
		SetTimer(CalculationInterval, true);
		LightBrightness = InitBright;
	}
	else
	{
		SetTimer(0.0, false);
		LightBrightness = 0.0;			
	}
}

simulated function Timer() 
{
	if (LightMode == LM_FireFlicker)
	{
		Mod = RandRange(-1, 1) * DiffMod;
		LightRadius = InitRad + (RandRange(-1, 1) * RadialFluctuation);
		CurrentColour = RandomColour(MinColour, MaxColour);
		LightBrightness = InitBright + Mod;
	}
		
	RGBToHLS(CurrentColour, CurHue, CurLum, CurSat);
	LightHue = CurHue;
}

simulated function Trigger( actor Other, pawn EventInstigator )
{
	if (LightBrightness > 0.0)
     	{         
			SetTimer(0.0, false);
	     	LightBrightness = 0.0;
     	}
    else if (LightBrightness == 0.0)
     	{         
			SetTimer(CalculationInterval, true);
			LightBrightness = InitBright;
     	}     
}

defaultproperties
{
     CalculationInterval=0.050000
     MaxBrightness=120.000000
     MinBrightness=50.000000
     MaxColour=(G=128,R=255)
     MinColour=(B=255)
     Variance=1.200000
     LightHue=21
     LightSaturation=127
     LightBrightness=120.000000
     LightRadius=32.000000
     bNoDelete=True
}
