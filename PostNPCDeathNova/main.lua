-- =============================================================================
--  PostNPCDeathNova — The Binding of Isaac: Repentance
--  MC_POST_NPC_DEATH: Dead enemies fire 4 homing tears in cardinal directions.
--  Uses Isaac.Spawn with EntityType.ENTITY_TEAR.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PostNPCDeathNova", 1)

local CARDINAL_DIRS = {
    Vector(0, -1),
    Vector(1, 0),
    Vector(0, 1),
    Vector(-1, 0),
}

function mod:onPostNPCDeath(npc)
    if not npc:Exists() then return end

    local pos = npc.Position
    local speed = 4
    local damage = 3.5

    for _, dir in ipairs(CARDINAL_DIRS) do
        local tear = Isaac.Spawn(
            EntityType.ENTITY_TEAR,
            TearVariant.BLUE,
            0,
            pos,
            dir * speed,
            nil
        )
        if tear then
            tear.CollisionDamage = damage
            -- Make tear homing
            tear:AddTearFlags(TearFlags.TEAR_HOMING)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.onPostNPCDeath)

Isaac.DebugString("PostNPCDeathNova loaded!")
