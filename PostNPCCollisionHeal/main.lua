-- =============================================================================
--  PostNPCCollisionHeal - The Binding of Isaac: Repentance
--  10% chance to spawn a half red heart as "blood money" after NPC hit.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PostNPCCollisionHeal", 1)

function mod:onPostNPCCollision(npc, low)
    local player = Isaac.GetPlayer(0)
    if player:IsDead() then return end
    -- 10% "blood money" chance
    if math.random(1, 10) == 1 then
        local heartPos = player.Position + Vector(0, -30)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, heartPos, Vector.Zero, nil)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_COLLISION, mod.onPostNPCCollision)
Isaac.DebugString("PostNPCCollisionHeal loaded!")
