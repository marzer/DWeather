//=============================================================================
//  DWChargingLight: Fading Light Emitter
//  Fades light up or down on trigger
//  By Mark 'MarZer' Gillard
//=============================================================================
class DWChargingLight extends DWLightParent
	placeable;

//var() string Label;
var() float MaxBrightness;
var() float MinBrightness;
var float Increment;
var() float Time;
var() float CalculationInterval;
var() enum EInitialState {IS_Minimum,IS_Maximum,} FirstState;
var enum ECurrent {EC_None,EC_FadeUp,EC_FadeDown,} Current;

event PreBeginPlay()
{
	Increment = (CalculationInterval * (MaxBrightness - MinBrightness)) / Time;
	
	if(FirstState == IS_Minimum)
	{
		LightBrightness = MinBrightness;
	}
	else
	{
		LightBrightness = MaxBrightness;
	}
}

event Trigger(Actor Other, Pawn EventInstigator)
{
	SetTimer(CalculationInterval, true);
	
	if (Current == EC_FadeUp)
	{
		Current = EC_FadeDown;
		FirstState = IS_Maximum;
	}
	else if (Current == EC_FadeDown)
	{
		Current = EC_FadeUp;
		FirstState = IS_Minimum;
	}
}

simulated function Timer()
{
	if (FirstState == IS_Minimum)
	{
		if (LightBrightness < MaxBrightness)
		{
			Current = EC_FadeUp;
			LightBrightness = Charge(Increment, LightBrightness, true);
		}
		else
		{
			FirstState = IS_Maximum;
			Current = EC_None;
			SetTimer(0.0, false);
		}
	}
	else
	{
		if (LightBrightness > MinBrightness)
		{
			Current = EC_FadeDown;
			LightBrightness = Charge(Increment, LightBrightness, false);
		}
		else
		{
			FirstState = IS_Minimum;
			Current = EC_None;
			SetTimer(0.0, false);
		}
	}	
}

defaultproperties
{
     LightHue=21
     LightSaturation=127
     LightBrightness=120.000000
     LightRadius=100.000000
     bNoDelete=True
}
