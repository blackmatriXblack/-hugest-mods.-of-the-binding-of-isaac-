-- =============================================================================
--  Heretic Flame - The Binding of Isaac: Repentance
--  The Heretic's flame trails create crosses of fire (4-directional)
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("HereticFlame", 1)
local HERETIC_TYPE = 908

function mod:onNPCUpdate(npc)
    if npc.Type ~= HERETIC_TYPE then return end
    
    -- During flame trail attack state, spawn cross-pattern fire
    if npc.State == 8 and npc.StateFrame % 5 == 0 then
        local directions = {
            Vector(1, 0), Vector(-1, 0),
            Vector(0, 1), Vector(0, -1)
        }
        for _, dir in ipairs(directions) do
            local spawnPos = npc.Position + dir * 50
            local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0, spawnPos, Vector.Zero, npc)
            if fire then
                fire:ToEffect().Timeout = 120
                fire:ToEffect().Scale = 0.8
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, HERETIC_TYPE)
Isaac.DebugString("HereticFlame loaded!")
