//=============================================================================
// DWAmbientSound - Ambient sound played during day using DynamicWeather
// Toggles between userdefined Night and Day sounds 
//=============================================================================

class DWAmbientSound extends AmbientSound;

var(Weather_Sound) sound DaySound;
var(Weather_Sound) sound NightSound;
var(Weather_Sound) int DaySoundVolume;
var(Weather_Sound) int DaySoundRadius;
var(Weather_Sound) int NightSoundVolume;
var(Weather_Sound) int NightSoundRadius;
var(Weather_Sound) enum EInitialPhase
{
	DWS_Day,
	DWS_Night,
} Phase;	

event PostBeginPlay() 
{
	 if (Phase == DWS_Day)
	 {
              Phase = DWS_Day;
		 	  AmbientSound = DaySound;
              SoundVolume = DaySoundVolume;
		      SoundRadius = DaySoundRadius;                     
     }
     else
	 {
              Phase = DWS_Night;
		 	  AmbientSound = NightSound;
              SoundVolume = NightSoundVolume;
		      SoundRadius = NightSoundRadius;              
     }         
}
simulated function Trigger( actor Other, pawn EventInstigator )
{
	 if (Phase == DWS_Day)
	 		{
              Phase = DWS_Night;
		 	  AmbientSound = NightSound;
              SoundVolume = NightSoundVolume;
		      SoundRadius = NightSoundRadius;  
	 		}
     	else
     		{
              Phase = DWS_Day;
	          AmbientSound = DaySound;
              SoundVolume = DaySoundVolume;
		      SoundRadius = DaySoundRadius;  
     		}
}

defaultproperties
{
     DaySoundVolume=80
     NightSoundVolume=55
     RemoteRole=ROLE_SimulatedProxy
     bGameRelevant=True
}
