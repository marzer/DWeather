//=============================================================================
// DWAmbientMonsterRULES
//=============================================================================
class DWAmbientMonsterRULES extends GameRules;

function ScoreKill(Controller Killer, Controller Killed)
{
    if ( (Killer != None) && (Killed != None) && (! Killed.SameTeamAs(Killer)) )
    {
        if ( killer.PlayerReplicationInfo != none && MonsterController(Killed)!=none )
        {
            Killer.PlayerReplicationInfo.Score -= 1;
        }
    }
    if ( NextGameRules != None )
    {
        NextGameRules.ScoreKill(Killer,Killed);
    }
}

defaultproperties
{
}
