-- =============================================================================
--  BoilExplode - The Binding of Isaac: Repentance
--  Boil/Walking Boil explodes into 6 blood shots on death
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BoilExplode", 1)
local BOIL_TYPE = 209 -- EntityType.ENTITY_BOIL

local function onNPCDeath(entity)
    if entity.Type ~= BOIL_TYPE then
        return
    end

    local pos = entity.Position
    for i = 1, 6 do
        local angle = (i - 1) * (math.pi * 2 / 6) + math.random() * 0.3
        local dir = Vector(math.cos(angle), math.sin(angle))
        local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0,
            pos, dir * 6, entity)
        if tear then
            tear.CollisionDamage = 2.0
            tear.Scale = 1.3
        end
    end

    -- Extra visual burst
    local burst = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 0, pos, Vector(0, 0), entity)
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, onNPCDeath)
Isaac.DebugString("BoilExplode loaded!")
