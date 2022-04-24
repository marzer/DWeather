//=============================================================================
//  DWTriggerLight: Dynamic Weather Emitter
//  Toggles between userdefined Night and Day lights 
//=============================================================================
class DWTriggerLight extends DWLightParent
	placeable;

var(Weather_Day) int DayLightBrightness;           
var(Weather_Night) int NightLightBrightness;       
var(Weather_Day) int DayLightHue;
var(Weather_Day) float DayLightRadius;              
var(Weather_Day) int DayLightSaturation;           
var(Weather_Night) int NightLightHue;
var(Weather_Night) float NightLightRadius;         
var(Weather_Night) int NightLightSaturation;       
var(Weather_Info) enum EInitialPhase       // Beginning phase of the Emitter  
{
	DWL_Day,
	DWL_Night,
} Phase;

event PreBeginPlay() 
{
	 if (Phase == DWL_Day)
     	{
	     	Phase = DWL_Day;
	     	LightBrightness = DayLightBrightness;
         	LightHue = DayLightHue;
         	LightSaturation = DayLightSaturation;
         	LightRadius = DayLightRadius;
     	}     
              
     else
		{
     		Phase = DWL_Night;
			LightBrightness = NightLightBrightness;
         	LightHue = NightLightHue;
         	LightSaturation = NightLightSaturation;
         	LightRadius = NightLightRadius;
     	}
}

simulated function Trigger( actor Other, pawn EventInstigator )
{
	 if (Phase == DWL_Day)
     	{         
	 		
     		Phase = DWL_Night;
			LightBrightness = NightLightBrightness;
         	LightHue = NightLightHue;
         	LightSaturation = NightLightSaturation;
         	LightRadius = NightLightRadius;
     	}     
              
     else
		{
	     	Phase = DWL_Day;
	     	LightBrightness = DayLightBrightness;
         	LightHue = DayLightHue;
         	LightSaturation = DayLightSaturation;
         	LightRadius = DayLightRadius;
        }
}

defaultproperties
{
     DayLightBrightness=80
     NightLightBrightness=80
     DayLightHue=21
     DayLightRadius=300.000000
     DayLightSaturation=193
     NightLightHue=152
     NightLightRadius=300.000000
     NightLightSaturation=32
     LightSaturation=255
     LightBrightness=80.000000
     bNoDelete=True
}
