//=============================================================================
//  DWFire: Dynamic Lit Fire Emitter
//  A fire emitter that gives off a flickering light, can be triggered to go
//  'out' or 'light up'.
//
//  By Mark 'MarZer' Gillard
//=============================================================================
class DWFire extends DWParent
	placeable;

#exec OBJ LOAD FILE="..\StaticMeshes\DWeather-smesh.usx"
#exec OBJ LOAD FILE="..\Textures\DWeather-Tex.utx"

struct FireStuff
{
	var() float				PawnPainRadius;
	var() float				VehiclePainRadius;
};

struct Stuff
{
	var() float 			Variance;
	var() float 			RadialFluctuation;
	var() enum 				EMode {FM_Burning,FM_Dead,} FireMode;
	var() range 			BrightnessRange;
	var() colourrange 		LightColourRange;
//	var() class<Emitter> 	FireEffectClass;
	var() FireStuff			FireDamage;
};

var() Stuff				Settings;	
var   float				CalculationInterval, Mod, DiffMod, InitRad, InitBright, Increment, SoundIncrement;
var   color 			CurrentColour;
var   bool 				bInitiallyBurning;
var   enum 				ECurrent {FadingUp,Burning,FadingDown,Dead} Current;
var   float 			CurrentTime;
var   DWFireFearSpot 	PhearMeh;
var   byte 				CurHue;
var   byte 				CurSat;
var   byte 				CurLum;


var DWFireEmitter FireEffect;

replication
{
    reliable if ( Role == ROLE_Authority )
        Settings, FireSwitch, HurtMe, TriggeredFireSwitch, FireEffect;
}

simulated event PreBeginPlay()
{
	DiffMod = Settings.Variance * (Settings.BrightnessRange.Max - Settings.BrightnessRange.Min);
	InitRad = LightRadius;
	InitBright = (Settings.BrightnessRange.Max : Settings.BrightnessRange.Min);
	Increment = (CalculationInterval * (Settings.BrightnessRange.Max - Settings.BrightnessRange.Min)) / 0.2;
	SoundIncrement = (CalculationInterval * 200) / 0.2;
	
	if (Settings.FireMode == FM_Burning)
	{
		bInitiallyBurning = true;
		SetTimer(CalculationInterval, true);
		Current = Burning;
		SoundVolume = 200;
		
		FireEffect = spawn(class'DWeather.DWFireEmitter',self,,Location);
		FireEffect.SetBase(self);
		PhearMeh = spawn(class'DWFireFearSpot',,,Location);	
			PhearMeh.SetBase(self);
	}
	else
	{
		Current = Dead;
		bInitiallyBurning = false;
		LightBrightness = 0.0;
		SoundVolume = 0;
	}
}

simulated function HurtMe(int PainScale)
{	
	local Pawn Other;
	local SVehicle Car;
	
	foreach VisibleCollidingActors(class'Pawn', Other, Settings.FireDamage.PawnPainRadius, Location, true) 
	{
		if (Other != None)
		{
			Other.TakeDamage((1 * PainScale), None, Other.Location, vect(0,0,0), class'DamTypeFire');
		}
	}
	
	foreach VisibleCollidingActors(class'SVehicle', Car, Settings.FireDamage.VehiclePainRadius, Location, true)
	{
		if (Car != None)
		{
			Car.TakeDamage((5 * PainScale), None, Car.Location, vect(0,0,0), class'DamTypeFireCAR');
		}
	}	
}

simulated function UpdateWind(vector Wind)
{
	if(FireEffect != None)
		FireEffect.UpdateWind(Wind);
}

simulated function FireSwitch()
{
	CurrentTime = CurrentTime + CalculationInterval;
	
		if (Current == Burning)
		{
			Mod = RandRange(-1, 1) * DiffMod;
			LightRadius = InitRad + (RandRange(-1, 1) * Settings.RadialFluctuation);
			CurrentColour = RandomColour(Settings.LightColourRange.Min, Settings.LightColourRange.Max);
			LightBrightness = InitBright + Mod;
			SoundVolume = 200;
			RGBToHLS(CurrentColour, CurHue, CurLum, CurSat);
			LightHue = CurHue;
			
			if (CurrentTime > 0.2)
			{
				HurtMe(2);
				CurrentTime=0.0;
			}
		}
		else if (Current == FadingUp)
		{
			if (LightBrightness < InitBright)
			{
				LightBrightness = Charge(Increment, LightBrightness, true) * (RandRange(0.9, 1.1));
				SoundVolume = Charge(SoundIncrement, SoundVolume, true) * (RandRange(0.9, 1.1));
				CurrentColour = RandomColour(Settings.LightColourRange.Min, Settings.LightColourRange.Max);				
				RGBToHLS(CurrentColour, CurHue, CurLum, CurSat);
				LightHue = CurHue;
				
				if (CurrentTime > 0.2)
				{
					HurtMe(1);
		    		CurrentTime=0.0;
				}
			}
			else
			{
				Current = Burning;
			}
		}
		else if (Current == FadingDown)
		{
			if (LightBrightness > 0)
			{
				LightBrightness = Charge(Increment, LightBrightness, false) * (RandRange(0.9, 1.1));
				SoundVolume = Charge(SoundIncrement, SoundVolume, false) * (RandRange(0.9, 1.1));
				CurrentColour = RandomColour(Settings.LightColourRange.Min, Settings.LightColourRange.Max);				
				RGBToHLS(CurrentColour, CurHue, CurLum, CurSat);
				LightHue = CurHue;
			
				if (CurrentTime > 0.2)
				{
					HurtMe(1);
					CurrentTime=0.0;
				}
			}
			else
			{
			Current = Dead;
			HurtMe(0);
			SetTimer(0.0, false);
			}
		}
}	

simulated function Timer() 
{
	FireSwitch();
}	

simulated function TriggeredFireSwitch()
{
	if (Settings.FireMode == FM_Burning)
     	{         
	     	Current = FadingDown;
	     	Settings.FireMode = FM_Dead;

			if ( FireEffect != None )
				FireEffect.Kill();
			
			if (PhearMeh != None)
				PhearMeh.Destroy();
		}
    else
     	{         
			SetTimer(CalculationInterval, true);
			Settings.FireMode = FM_Burning;
	     	Current = FadingUp;

			if (!bInitiallyBurning)
			{
				FireEffect = spawn(class'DWeather.DWFireEmitter',self,,Location);
				FireEffect.SetBase(self);
				bInitiallyBurning = true;	
			}
			
			if (FireEffect == None)
				FireEffect = spawn(class'DWeather.DWFireEmitter',self,,Location);
					FireEffect.SetBase(self);
							
			if (PhearMeh == None)
				PhearMeh = spawn(class'DWFireFearSpot',,,Location);	
					PhearMeh.SetBase(self);
		}
}	

simulated function Trigger( actor Other, pawn EventInstigator )
{
	 TriggeredFireSwitch();    
} 
	

defaultproperties
{
    Settings=(Variance=1.200000,RadialFluctuation=1.000000,BrightnessRange=(Min=80.000000,Max=90.000000),LightColourRange=(Max=(G=75,R=151),Min=(B=159,G=214,R=253)),FireDamage=(PawnPainRadius=100.000000,VehiclePainRadius=255.000000))
    CalculationInterval=0.050000
    LightType=LT_Steady
    LightHue=21
    LightSaturation=127
    LightBrightness=85.000000
    LightRadius=8.000000
    LightPeriod=32
    LightCone=128
    bDynamicLight=true
    bUpdateSimulatedPosition=true
    AmbientSound=Sound'GeneralAmbience.firefx3'
    Texture=Texture'DWeather-tex.Icons.fireicon'
    SoundVolume=200
    SoundPitch=50
    SoundRadius=200.000000
    bCollideActors=true
	bIsEffectedByWind=true
}

//FireEffectClass=Class'DWeather.DWFireEmitter'