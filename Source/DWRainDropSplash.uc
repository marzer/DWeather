class DWRainDropSplash extends Emitter
	notplaceable;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseDirectionAs=PTDU_Up
        UseColorScale=True
        UniformSize=True
        ScaleSizeXByVelocity=True
        Acceleration=(Z=-180.000000)
        ColorScale(0)=(Color=(B=245,G=240,R=137))
        ColorScale(1)=(RelativeTime=0.800000,Color=(B=223,G=231,R=88))
        ColorScale(2)=(RelativeTime=1.000000)
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=0.400000,RelativeSize=0.700000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.300000)
        StartSizeRange=(X=(Min=0.200000,Max=0.250000))
        ScaleSizeByVelocityMultiplier=(X=0.010000,Y=0.010000)
        InitialParticlesPerSecond=10000.000000
        Texture=Texture'AW-2004Particles.Energy.SparkHead'
        LifetimeRange=(Min=0.200000,Max=0.200000)
        StartVelocityRange=(X=(Min=-30.000000,Max=30.000000),Y=(Min=-30.000000,Max=30.000000),Z=(Min=85.000000,Max=140.000000))
    End Object
    Emitters(0)=SpriteEmitter'DWeather.DWRainDropSplash.SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        UseColorScale=True
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        BlendBetweenSubdivisions=True
        Acceleration=(Z=-150.000000)
        ColorScale(0)=(Color=(B=255,G=250,R=200))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=250,R=200))
        FadeOutStartTime=0.500000
        MaxParticles=2
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=1.000000,Max=1.500000),Z=(Min=10.000000,Max=10.000000))
        InitialParticlesPerSecond=500.000000
        Texture=Texture'XGame.Water.xWaterDrops2'
        TextureUSubdivisions=1
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.000000,Max=0.200000)
        StartVelocityRange=(X=(Min=-24.000000,Max=24.000000),Y=(Min=-24.000000,Max=24.000000),Z=(Min=70.000000,Max=115.000000))
    End Object
    Emitters(1)=SpriteEmitter'DWeather.DWRainDropSplash.SpriteEmitter3'
    
    bLightChanged=true
	bNoDelete=false
	CullDistance=1500
}