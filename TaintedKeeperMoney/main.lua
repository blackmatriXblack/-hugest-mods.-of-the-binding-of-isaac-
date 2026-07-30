-- =============================================================================
--  TaintedKeeperMoney - The Binding of Isaac: Repentance
--  Tainted Keeper: Enemies drop 1 extra coin on death.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedKeeperMoney", 1)
local TAINTED_KEEPER = 33

function mod:onEntityKill(entity)
    if entity:IsEnemy() then
        local player = Isaac.GetPlayer(0)
        if player and player:GetPlayerType() == TAINTED_KEEPER then
            local pos = entity.Position
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, pos, RandomVector():Resized(2), player)
            Isaac.DebugString("TaintedKeeperMoney: Extra coin dropped!")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
Isaac.DebugString("TaintedKeeperMoney loaded!")
