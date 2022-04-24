class DWTwisterEmitter extends Emitter
	placeable;
	
#exec OBJ LOAD FILE=..\Textures\AW-2004Particles.utx

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseDirectionAs=PTDU_Right
         UseColorScale=True
         UseRevolution=True
         UseRevolutionScale=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         DetermineVelocityByLocationDifference=True
         ScaleSizeXByVelocity=True
         UseVelocityScale=True
         Acceleration=(Z=2000.000000)
         ColorScale(0)=(RelativeTime=1.000000,Color=(B=192,G=192,R=192))
         ColorScale(1)=(Color=(B=128,G=128,R=128))
         Opacity=0.800000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2000
         StartLocationShape=PTLS_Polar
         StartLocationPolarRange=(X=(Max=65536.000000),Y=(Min=16384.000000,Max=16384.000000),Z=(Min=64.000000,Max=96.000000))
         RevolutionsPerSecondRange=(Z=(Max=3.000000))
         RevolutionScale(0)=(RelativeRevolution=(Z=3.000000))
         RevolutionScale(1)=(RelativeTime=0.700000,RelativeRevolution=(Z=0.600000))
         RevolutionScale(2)=(RelativeTime=1.000000,RelativeRevolution=(Z=1.000000))
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=0.200000,RelativeSize=0.400000)
         SizeScale(2)=(RelativeTime=0.400000,RelativeSize=0.800000)
         SizeScale(3)=(RelativeTime=0.600000,RelativeSize=1.200000)
         SizeScale(4)=(RelativeTime=0.800000,RelativeSize=1.600000)
         SizeScale(5)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=2.000000,Max=4.000000))
         ScaleSizeByVelocityMultiplier=(X=0.010000)
         Texture=Texture'EpicParticles.Flares.FlashFlare1'
         LifetimeRange=(Min=1.800000,Max=1.900000)
         StartVelocityRange=(X=(Min=-4000.000000,Max=4000.000000),Y=(Min=-4000.000000,Max=4000.000000),Z=(Min=600.000000,Max=1000.000000))
         StartVelocityRadialRange=(Min=5.000000,Max=1.000000)
         GetVelocityDirectionFrom=PTVD_StartPositionAndOwner
         VelocityScale(0)=(RelativeVelocity=(X=0.100000,Y=0.100000,Z=2.000000))
         VelocityScale(1)=(RelativeTime=0.200000,RelativeVelocity=(X=0.200000,Y=0.200000,Z=1.600000))
         VelocityScale(2)=(RelativeTime=0.400000,RelativeVelocity=(X=0.300000,Y=0.300000,Z=1.200000))
         VelocityScale(3)=(RelativeTime=0.600000,RelativeVelocity=(X=0.400000,Y=0.400000,Z=0.800000))
         VelocityScale(4)=(RelativeTime=0.800000,RelativeVelocity=(X=0.500000,Y=0.500000,Z=0.400000))
         VelocityScale(5)=(RelativeTime=1.000000,RelativeVelocity=(X=0.600000,Y=0.600000))
     End Object
     Emitters(0)=SpriteEmitter'DWeather.DWTwisterEmitter.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         UseDirectionAs=PTDU_Right
         UseColorScale=True
         UseRevolution=True
         UseRevolutionScale=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         DetermineVelocityByLocationDifference=True
         ScaleSizeZByVelocity=True
         UseVelocityScale=True
         Acceleration=(Z=2000.000000)
         ColorScale(0)=(Color=(B=192,G=192,R=192))
         ColorScale(1)=(RelativeTime=0.100000,Color=(B=160,G=160,R=160,A=255))
         ColorScale(2)=(RelativeTime=0.800000,Color=(B=128,G=128,R=128,A=192))
         ColorScale(3)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128))
         Opacity=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=200
         StartLocationShape=PTLS_Polar
         StartLocationPolarRange=(X=(Max=65536.000000),Y=(Min=16384.000000,Max=16384.000000),Z=(Min=64.000000,Max=96.000000))
         RevolutionsPerSecondRange=(Z=(Max=3.000000))
         RevolutionScale(0)=(RelativeRevolution=(Z=3.000000))
         RevolutionScale(1)=(RelativeTime=0.700000,RelativeRevolution=(Z=0.600000))
         RevolutionScale(2)=(RelativeTime=1.000000,RelativeRevolution=(Z=1.000000))
         SizeScale(1)=(RelativeTime=0.200000,RelativeSize=0.200000)
         SizeScale(2)=(RelativeTime=0.400000,RelativeSize=0.400000)
         SizeScale(3)=(RelativeTime=0.600000,RelativeSize=0.600000)
         SizeScale(4)=(RelativeTime=0.800000,RelativeSize=0.800000)
         SizeScale(5)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=20.000000,Max=20.000000),Y=(Min=20.000000,Max=20.000000),Z=(Min=20.000000,Max=20.000000))
         ScaleSizeByVelocityMultiplier=(X=0.001000)
         Texture=Texture'AW-2004Particles.Weapons.DustSmoke'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=1.400000,Max=1.900000)
         StartVelocityRange=(X=(Min=-4000.000000,Max=4000.000000),Y=(Min=-4000.000000,Max=4000.000000),Z=(Min=600.000000,Max=1000.000000))
         StartVelocityRadialRange=(Min=5.000000,Max=1.000000)
         GetVelocityDirectionFrom=PTVD_StartPositionAndOwner
         VelocityScale(0)=(RelativeVelocity=(X=0.100000,Y=0.100000,Z=2.000000))
         VelocityScale(1)=(RelativeTime=0.200000,RelativeVelocity=(X=0.200000,Y=0.200000,Z=1.600000))
         VelocityScale(2)=(RelativeTime=0.400000,RelativeVelocity=(X=0.300000,Y=0.300000,Z=1.200000))
         VelocityScale(3)=(RelativeTime=0.600000,RelativeVelocity=(X=0.400000,Y=0.400000,Z=0.800000))
         VelocityScale(4)=(RelativeTime=0.800000,RelativeVelocity=(X=0.500000,Y=0.500000,Z=0.400000))
         VelocityScale(5)=(RelativeTime=1.000000,RelativeVelocity=(X=0.600000,Y=0.600000))
     End Object
     Emitters(1)=SpriteEmitter'DWeather.DWTwisterEmitter.SpriteEmitter4'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter8
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseRandomSubdivision=True
         UseVelocityScale=True
         Acceleration=(Z=500.000000)
         Opacity=0.250000
         FadeOutStartTime=0.500000
         FadeInEndTime=0.350000
         MaxParticles=50
         StartLocationShape=PTLS_Polar
         StartLocationPolarRange=(X=(Max=65535.000000),Y=(Min=16384.000000,Max=16384.000000),Z=(Min=10.000000,Max=10.000000))
         UseRotationFrom=PTRS_Actor
         SizeScale(0)=(RelativeSize=0.300000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=50.000000,Max=90.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
         ParticlesPerSecond=50.000000
         InitialParticlesPerSecond=50.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'AW-2004Particles.Weapons.SmokePanels2'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.500000,Max=0.800000)
         StartVelocityRange=(X=(Min=70.000000,Max=70.000000))
         StartVelocityRadialRange=(Min=-600.000000,Max=-800.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.200000,RelativeVelocity=(X=0.350000,Y=0.350000,Z=0.350000))
         VelocityScale(2)=(RelativeTime=0.500000,RelativeVelocity=(X=0.100000,Y=0.100000,Z=0.100000))
         VelocityScale(3)=(RelativeTime=1.000000)
     End Object
     Emitters(2)=SpriteEmitter'DWeather.DWTwisterEmitter.SpriteEmitter8'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter69
         UseDirectionAs=PTDU_Normal
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Opacity=0.250000
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartLocationOffset=(Z=6.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
         StartSizeRange=(X=(Min=50.000000,Max=65.000000))
         Texture=Texture'AW-2004Particles.Energy.AirBlast'
         LifetimeRange=(Min=0.300000,Max=0.300000)
     End Object
     Emitters(3)=SpriteEmitter'DWeather.DWTwisterEmitter.SpriteEmitter69'

     bNoDelete=False
}
