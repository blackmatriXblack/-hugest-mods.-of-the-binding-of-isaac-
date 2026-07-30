-- =============================================================================
--  MulligoonSpawner - The Binding of Isaac: Repentance
--  Mulligoon enemies explode into 3 Mulligans on death
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MulligoonSpawner", 1)
local MULLIGOON_TYPE = 254
local MULLIGAN_TYPE = 23

function mod:onNpcDeath(_, npc)
    if npc.Type ~= MULLIGOON_TYPE then return end
    local pos = npc.Position
    local room = Game():GetRoom()

    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TEAR_POOF_B, 0, pos, Vector.Zero, npc)

    for i = 1, 3 do
        local angle = (i / 3) * math.pi * 2 + math.random() * 0.3
        local dist = 30 + math.random() * 20
        local spawnPos = pos + Vector(math.cos(angle) * dist, math.sin(angle) * dist)
        spawnPos = room:GetClampedPosition(spawnPos, 20)
        local mulligan = Isaac.Spawn(MULLIGAN_TYPE, 0, 0, spawnPos, RandomVector():Resized(2 + math.random() * 2), npc)
        if mulligan then
            mulligan:AddEntityFlags(EntityFlag.FLAG_APPEAR)
            mulligan.Scale = 0.75
            mulligan.HitPoints = mulligan.MaxHitPoints * 0.6
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.onNpcDeath)
Isaac.DebugString("MulligoonSpawner loaded!")
