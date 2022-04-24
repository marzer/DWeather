//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DWLightingBANG extends ONSRocketProjectile;

#exec OBJ LOAD FILE=..\Sounds\VMVehicleSounds-S.uax

replication
{
    reliable if ( Role == ROLE_Authority )
        KillMeNow;
}

simulated function PostBeginPlay()
{
	SetTimer(0.05, true);
	Super.PostBeginPlay();
}

simulated function KillMeNow()
{
	Landed(Vect(0,0,1));
	SetTimer(0.0, false);
}

simulated function Timer()
{
	KillMeNow();
}

defaultproperties
{
     Damage=600.000000
     DamageRadius=550.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'DWeather.DamTypeLightning'
     DrawScale=0.500000
}
