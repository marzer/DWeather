//=============================================================================
//  DWZoneInfo
//  Allows a mapper to fade the colour and start/end points up and down
//  between definable points. Used in conjunction with other DWeather actors
//  to enhance the atmosphere in a map.
//  By Mark 'MarZer' Gillard
//=============================================================================
class DWZoneInfo extends ZoneInfo
	placeable;

//var() string Label;
var() float CalculationInterval;
var() float MaxFogStart;
var() float MinFogStart;
var() float MaxFogEnd;
var() float MinFogEnd;
var() color MaxColour;
var() color MinColour;
var float CurrentTime;
var() float FadeTime;
var() enum EFadePhase {FF_NegativeCosine,FF_Cosine,} FadePhase;

replication
{
	reliable if (Role == ROLE_Authority)
	CalculationInterval, MaxFogStart, MinFogStart, MaxFogEnd, MinFogEnd, MaxColour, MinColour,
	CurrentTime, FadeTime, FadePhase, ReturnFadeColour, CosWave, FogTricks;
}
	
simulated function color ReturnFadeColour(color Colour1, color Colour2, float X, float T, bool Inverse)
{
	local color ReturnCol;
	local float Y;
	
	if(Inverse == false)
	{
		Y = ((Cos(2 * Pi * (1 / (2 * T)) * X)) / 2) + 0.5;
	}
	else
	{
		Y = ((-Cos(2 * Pi * (1 / (2 * T)) * X)) / 2) + 0.5;
	}
	
	ReturnCol.R = float(Colour2.R - Colour1.R) * Y;
	ReturnCol.G = float(Colour2.G - Colour1.G) * Y;
	ReturnCol.B = float(Colour2.B - Colour1.B) * Y;
	Return Colour1 + ReturnCol;
}

final operator(18) int : ( int A, int B )
{
  return (A + B) / 2;
}

simulated function float CosWave (float M, float N, float X, float T, bool Inverse) 
{
	local float Y;
	if (Inverse == false)
	{
		Y = (((M - N) * Cos(2 * Pi * (1 / (2 * T)) * X)) / 2) + (M : N);
	}
	else
	{
		Y = (((M - N) * -Cos(2 * Pi * (1 / (2 * T)) * X)) / 2) + (M : N);
	}
	return Y;
}

simulated function PostBeginPlay()
{
	SetTimer(CalculationInterval, true);
}

simulated function FogTricks()
{
	CurrentTime = CurrentTime + CalculationInterval;

	if (FadePhase == FF_Cosine)
   	{	
	DistanceFogStart = CosWave(MaxFogStart, MinFogStart, CurrentTime, FadeTime, false);
	DistanceFogEnd = CosWave(MaxFogEnd, MinFogEnd, CurrentTime, FadeTime, false);
	DistanceFogColor = ReturnFadeColour(MinColour, MaxColour, CurrentTime, FadeTime, false);
	}
	else
	{
	DistanceFogStart = CosWave(MaxFogStart, MinFogStart, CurrentTime, FadeTime, true);
	DistanceFogEnd = CosWave(MaxFogEnd, MinFogEnd, CurrentTime, FadeTime, true);
	DistanceFogColor = ReturnFadeColour(MinColour, MaxColour, CurrentTime, FadeTime, true);
	}
}

simulated function Timer() 
{
	FogTricks();
}

defaultproperties
{
     bDistanceFog=True
     bStatic=False
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
}
