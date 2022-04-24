class DWWeatherEmitter extends xWeatherEffect;

var transient array<WeatherPcl> pclFull;
var private bool bFadeOut;
var private bool bFadeIn;
var config int fadeSize;

replication
{
    reliable if(Role==ROLE_Authority) 
        bFadeIn, bFadeOut;
}

function Trigger( actor Other, pawn EventInstigator )
{
	bFadeOut=!bFadeOut;
	bFadeIn=!bFadeIn;
}


//The native code uses the pcl array for rendering, we want to increase/decrease the array size
//based on whether we are fading in or out.
simulated function tick(float delta) {
    local int i, relativeFade;
    if ( Level.NetMode != NM_DedicatedServer) {
	    if (pclFull.length==0)
		pclFull=pcl;
	    i=pcl.length;
	    if (bFadeOut && i > 0) {
		pcl.remove(pcl.length-fadeSize, fadeSize);
	    } else if (bFadeIn && i < pclFull.length) {
		relativeFade=i+fadeSize;
		while(i<relativeFade) {
		  pcl[i]=pclFull[i++];	
		}
		
	    }	
     }
    super.tick(delta);	

}

defaultproperties
{
     bFadeIn=True
     fadeSize=50
     WeatherType=WT_Rain
     numParticles=3000
     maxPclEyeDist=800.000000
     numCols=2.000000
     numRows=2.000000
     spawnVecU=(X=280.000000)
     spawnVecV=(Z=280.000000)
     spawnVel=(Y=-0.300000)
     Position=(X=(Min=-800.000000),Y=(Min=-800.000000))
     Speed=(Min=800.000000,Max=900.000000)
     Life=(Min=0.300000,Max=0.500000)
     Size=(Min=0.800000,Max=1.500000)
     bHighDetail=False
     Skins(0)=FinalBlend'EmitterTextures.MultiFrame.RainFB'
}
