class DWLightningEmitter extends Emitter
	notplaceable;

#exec OBJ LOAD FILE="..\Textures\DWeather-Tex.utx"

defaultproperties
{
     Emitters(0)=BeamEmitter'DWeather.DWLightning.BeamEmitter3'

     Emitters(1)=BeamEmitter'DWeather.DWLightning.BeamEmitter4'

     Emitters(2)=BeamEmitter'DWeather.DWLightning.BeamEmitter5'

     Emitters(3)=SpriteEmitter'DWeather.DWLightning.SpriteEmitter1'

     AutoDestroy=True
     bNoDelete=False
     LifeSpan=2.000000
}
