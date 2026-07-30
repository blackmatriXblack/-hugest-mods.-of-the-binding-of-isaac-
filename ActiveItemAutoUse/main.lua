local mod = RegisterMod("ActiveItemAutoUse", 1)
local game = Game()
local timer = 0

function mod:onUpdate()
    timer = timer + 1
    if timer >= 300 then
        timer = 0
        local player = Isaac.GetPlayer(0)
        player:UseActiveItem(0, true, false, 0, 0)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
