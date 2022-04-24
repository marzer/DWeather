//=============================================================================
//  DWFadingLight: Dynamic Fading Weather Emitter
//  Fades light dynamically (HA TAKE THAT EPIC! :P)
//  By Mark 'MarZer' Gillard
//=============================================================================
class DWFadingLight extends DWLightParent
	placeable
	hidecategories(Emitter,Force,Karma);

	
//var() string Label;
var() float MaxBrightness;
var() float MinBrightness;
var() color MaxColour;
var() color MinColour;
var byte CurHue;
var byte CurSat;
var byte CurLum;
var float CurrentTime;
var float Frequency;
var() float FadeTime;
var() enum EFadePhase {FF_NegativeCosine,FF_Cosine,} FadePhase;
var() enum EMode {LM_Normal,LM_Flicker,} LightMode;
var color CurrentColour;

simulated function Tick(float DeltaTime)
{
	CurrentTime = CurrentTime + DeltaTime;
	
	if (FadePhase == FF_Cosine)
   	{	
		LightBrightness = CosWave(MaxBrightness, MinBrightness, CurrentTime, FadeTime, false);
		CurrentColour = ReturnFadeColour(MinColour, MaxColour, CurrentTime, FadeTime, false);
	}
	else
	{
		LightBrightness = CosWave(MaxBrightness, MinBrightness, CurrentTime, FadeTime, true);
		CurrentColour = ReturnFadeColour(MinColour, MaxColour, CurrentTime, FadeTime, true);
	}
		
	RGBToHLS(CurrentColour, CurHue, CurLum, CurSat);
	LightHue = CurHue;
	
}

defaultproperties
{
     MaxBrightness=120.000000
     MinBrightness=50.000000
     MaxColour=(G=128,R=255)
     MinColour=(B=255)
     FadeTime=5.000000
     FadePhase=FF_Cosine
     LightHue=21
     LightSaturation=127
     LightBrightness=120.000000
     LightRadius=32.000000
     bNoDelete=True
}
