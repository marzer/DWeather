//=============================================================================
//  DWSunlight: Dynamic Fading Sunlight
//  Fades sunlight
//  By Mark 'MarZer' Gillard
//=============================================================================
class DWSunLight extends DWFadingLight
	placeable
	hidecategories(Emitter,Force,Karma);

defaultproperties
{
     LightEffect=LE_Sunlight
     Texture=Texture'Gameplay.SunIcon'
     bDirectional=True
}
