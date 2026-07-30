-- Soul Heart per enemy kill
local mod = RegisterMod("SoulHeartFarmer", 1)
function mod:onEntityKill(entity)
    if entity == nil or not entity:IsEnemy() then return end
    local player = Isaac.GetPlayer(0)
    if player then player:AddSoulHearts(2) end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
Isaac.DebugString("Soul Heart Farmer loaded! +1 soul heart per enemy kill.")
