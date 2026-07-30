-- KeyBombFarmer: Enemies drop 1 key and 1 bomb on kill
local mod = RegisterMod("KeyBombFarmer", 1)

function mod:onEntityKill(entity)
    local player = Isaac.GetPlayer(0)
    if entity:IsVulnerableEnemy() then
        player:AddKeys(1)
        player:AddBombs(1)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
Isaac.DebugString("KeyBombFarmer loaded! Enemies drop keys and bombs.")
