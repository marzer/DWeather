// ============================================================================
// DWTimedTrigger
// Copyright 2002 by Mychaeel <mychaeel@planetjailbreak.com>
// $Id: TimedTrigger.uc,v 1.1.1.1 2003/01/01 23:40:10 mychaeel Exp $
//
// Trigger that periodically fires a certain event. Can be activated and
// deactivated by being triggered itself. Trigger times are randomly chosen
// between a given minimum and maximum delay.
// ============================================================================

class DWTimedTrigger extends Triggers
  placeable;

var() bool bEnabled;          // trigger is enabled by default
var() bool bRepeating;        // event is fired repeatedly instead of just once
var() bool bUseInstigator;    // pawn enabling this trigger is event instigator
var() float MinDelaySeconds;  // minimum number of seconds between events
var() float MaxDelaySeconds;  // maximum number of seconds between events

event PostBeginPlay() {

  if (bEnabled)
    StartTimer();
  }

event Trigger(Actor ActorOther, Pawn PawnInstigator) {

  bEnabled = !bEnabled;

  if (bEnabled)
    StartTimer();
  else
    SetTimer(0.0, false);

  if (bUseInstigator)
    Instigator = PawnInstigator;
  }

event Timer() {

  TriggerEvent(Event, Self, Instigator);

  if (bRepeating)
    StartTimer();
  }

function StartTimer() {

  if (MinDelaySeconds <= 0.0)
    MinDelaySeconds = 0.0001;  // small but non-zero

  if (MaxDelaySeconds < MinDelaySeconds)
    MaxDelaySeconds = MinDelaySeconds;

  SetTimer(MinDelaySeconds + FRand() * (MaxDelaySeconds - MinDelaySeconds), false);
  }

defaultproperties
{
     bEnabled=True
     bRepeating=True
     Texture=Texture'DWeather-tex.Icons.timedtrigger'
}
