-- TrinketEveryFloor: Spawns a random trinket at player position on each new floor
local mod = RegisterMod("TrinketEveryFloor", 1)

function mod:onNewLevel()
    local player = Isaac.GetPlayer(0)
    local game = Game()
    local trinket = game:GetItemPool():GetTrinket()
    Isaac.Spawn(5, 350, trinket, player.Position, Vector(0, 0), nil)
    Isaac.DebugString("TrinketEveryFloor: Random trinket spawned!")
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
Isaac.DebugString("TrinketEveryFloor loaded! Trinket on every floor.")
