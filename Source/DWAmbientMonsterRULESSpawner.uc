//=============================================================================
// DWAmbientMonsterRULESSpawner.
//=============================================================================
class DWAmbientMonsterRULESSpawner extends Actor;

function PostBeginPlay()
{
    SetGameRules();
}

function SetGameRules()
{
    local GameRules G;

    if (Invasion(Level.Game)!=none)
    return;

    G = spawn(class'DWAmbientMonsterRULES');

    if ( Level.Game.GameRulesModifiers == None )
    {
        Level.Game.GameRulesModifiers = G;
    }
    else
    {
        Level.Game.GameRulesModifiers.AddGameRules(G);
    }
}

defaultproperties
{
}
