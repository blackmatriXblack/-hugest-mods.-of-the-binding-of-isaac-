-- Double bomb explosion radius
local mod = RegisterMod("BombUpdateMod", 1)
local game = Game()

function mod:onBombUpdate(bomb)
    if bomb then
        bomb.RadiusMultiplier = 2
    end
end

mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.onBombUpdate)
Isaac.DebugString("BombUpdateMod loaded! Doubles bomb explosion radius.")
