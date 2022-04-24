//=============================================================================
//  DWLightParent: Parent Class of Dynamic Weather Lights
//
//  By Mark 'MarZer' Gillard
//=============================================================================
class DWLightParent extends DWParent
		abstract;

defaultproperties
{
     LightType=LT_Steady
     LightRadius=150.000000
     LightPeriod=32
     LightCone=128
     bDynamicLight=True
     Texture=Texture'DWeather-tex.Icons.DWLight'
}
