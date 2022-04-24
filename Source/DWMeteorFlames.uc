class DWMeteorFlames extends Emitter
	notplaceable;

#exec OBJ LOAD FILE=AW-2004Explosions.utx

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         FadeIn=True
         ResetAfterChange=True
         AutoReset=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         FadeOutStartTime=1.300000
         FadeInEndTime=1.000000
         MaxParticles=90
         SizeScale(0)=(RelativeTime=3.000000,RelativeSize=8.000000)
         StartSizeRange=(X=(Min=250.000000,Max=250.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'VMParticleTextures.VehicleExplosions.smokeCloudTEX'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         StartVelocityRange=(Z=(Min=10.000000,Max=10.000000))
     End Object
     Emitters(0)=SpriteEmitter'DWeather.DWMeteorFlames.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         FadeIn=True
         AutoReset=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         BlendBetweenSubdivisions=True
         UseRandomSubdivision=True
         Acceleration=(Z=15.000000)
         FadeOutStartTime=0.200000
         FadeInEndTime=0.200000
         MaxParticles=70
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Max=150.000000))
         Texture=Texture'AW-2004Explosions.Fire.Fireball4'
         LifetimeRange=(Min=0.700000,Max=0.700000)
     End Object
     Emitters(1)=SpriteEmitter'DWeather.DWMeteorFlames.SpriteEmitter1'

     bNoDelete=False
}
