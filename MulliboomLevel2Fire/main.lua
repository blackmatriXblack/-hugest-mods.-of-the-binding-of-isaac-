-- ==========================================================================
--  MulliboomLevel2Fire - The Binding of Isaac: Repentance
--  Level 2 Mulliboom leaves 3 fire patches on death explosion.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MulliboomLevel2Fire", 1)
local ENEMY_MULLIBOOM = 66

local function onNPCDeath(_, npc)
    if npc.Type ~= ENEMY_MULLIBOOM or npc.Variant ~= 1 then return end
    local pos = npc.Position
    for i = 1, 3 do
        local firePos = pos + Vector(math.random(-60, 60), math.random(-60, 60))
        local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIREPLACE, 1, firePos, Vector.Zero, npc)
        if fire and fire.Exists() then
            -- Set fire lifetime
            fire:ToEffect()
            fire.Timeout = 180
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, onNPCDeath)
Isaac.DebugString("MulliboomLevel2Fire loaded!")