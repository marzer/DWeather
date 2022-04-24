// JCB mod for UT2004
//=========================================
// Author: JCBDigger
// Date: July 2004
// Home: http://games.DiscoverThat.co.uk
//=========================================
// Shadow classes are created by:
// © 2004 Matt 'SquirrelZero' Farber
// Wiki: http://wiki.beyondunreal.com/wiki/SquirrelZero/RealtimeShadows
//=========================================

class MutJCBShadows extends Mutator Config(jcbShadows);

// Default
var bool bAddRealShadows;   // Used for testing

var array<Effect_ShadowController> AddedShadows;  // keep track so they can be deleted

simulated function PostBeginPlay()
{
  local DeathMatch infoDM;
	Super.PostBeginPlay();
  infoDM = DeathMatch( Level.Game );
  if ( infoDM != None )
  {
	  // Allow stuff here
		//infoDM.bAllowVehicles = true;
  }
  SetTimer(1.66,false);
}

// Timer event worked to get multiplayer started on the client
// Only needs to be slow
simulated function Timer()
{
  AddShadowToEveryPawn();
  SetTimer(1.66,false);   // this should be frequent enough to catch new Pawns
}

simulated function AddShadowToEveryPawn()
{
  local xPawn pOther;
  // Only add shadows on the client
  if( bAddRealShadows && (Level.NetMode != NM_DedicatedServer))
  {
  	ForEach DynamicActors(class'xPawn',pOther)
  	{
  	  if ( !PawnAlreadyHasShadows(pOther) )
  	  {
    	  AddShadows(pOther);
    	}
  	}
  }
}

// Using this function will slow things down a bit
simulated function bool PawnAlreadyHasShadows(Pawn pOther)
{
  local int iNum;
  for ( iNum=0; iNum<AddedShadows.Length; iNum++ )
	{
	  if ( AddedShadows[iNum].Instigator == None )
	  {
	    //  Might as well get rid of orphans at the same time
	    AddedShadows[iNum].Destroy();
	    AddedShadows.Remove(iNum,1);
	  }
	  else if (AddedShadows[iNum].Instigator == pOther)
	  {
	    return true;
	  }
	}
	return false;
}

simulated function AddShadows(Pawn pOther)
{
  local int iIndex;
  DisableOriginalShadows(pOther);
  // Only add shadows on the client
  if( bAddRealShadows && (Level.NetMode != NM_DedicatedServer))
  {
    iIndex = AddedShadows.Length;
    AddedShadows[iIndex] = Spawn(class'Effect_ShadowController',pOther,'',pOther.Location);
    AddedShadows[iIndex].Instigator = pOther;
    AddedShadows[iIndex].Initialize();
  }
}

simulated function DisableOriginalShadows(Pawn pOther)
{
  if ( xPawn(pOther) != None )
  {
    xPawn(pOther).bPlayerShadows = false;
    xPawn(pOther).bBlobShadow = false;
    if ( xPawn(pOther).PlayerShadow != None )
    {
      xPawn(pOther).PlayerShadow.Destroy();
    }
  }
}

// TO DO test if these work client side?
simulated function DriverEnteredVehicle(Vehicle V, Pawn P)
{
	Super.DriverEnteredVehicle(V, P);
  DisableShadowsFor(P);
}

simulated function DriverLeftVehicle(Vehicle V, Pawn P)
{
	Super.DriverLeftVehicle(V, P);
  EnableShadowsFor(P);
}

simulated function DisableShadowsFor(Pawn pOther)
{
  local int iNum;
  for ( iNum=0; iNum<AddedShadows.Length; iNum++ )
	{
	  if ( AddedShadows[iNum].Instigator == pOther )
	  {
	    AddedShadows[iNum].bShadowActive = false;
	  }
	}
}

simulated function EnableShadowsFor(Pawn pOther)
{
  local int iNum;
  for ( iNum=0; iNum<AddedShadows.Length; iNum++ )
	{
	  if ( AddedShadows[iNum].Instigator == pOther )
	  {
	    AddedShadows[iNum].bShadowActive = true;    // better to have an Enable() in Effect_ShadowController class
	    AddedShadows[iNum].FillLights();
	  }
	}
}

// Remember no semicolons
defaultproperties
{
  GroupName="Shadows"
  FriendlyName="Real Time Shadows"
  Description="Real Time Shadows [UT2004]| The shadows are improvements on the original game ones and were created by Matt 'SquirrelZero' Farber. ||http://wiki.beyondunreal.com/wiki/SquirrelZero/RealtimeShadows ||games.||http://games.DiscoverThat.co.uk"
  IconMaterialName="MutatorArt.nosym"
  ConfigMenuClassName=""

  bAddToServerPackages=true   // may be fixed in v3204 but safer to add manually to ServerPackages in the ini file to ensure backwards compatible
  RemoteRole=ROLE_SimulatedProxy    // required for the simulated functions to run on the client
  bAlwaysRelevant=true              // required for the simulated functions to run on the client

  // Default
  bAddRealShadows=true   // disable adding shadows - used for testing
}
