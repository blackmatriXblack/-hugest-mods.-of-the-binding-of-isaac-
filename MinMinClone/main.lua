-- ==========================================================================
--  Min Min Clone - The Binding of Isaac: Repentance
--  Min-Min creates a fire clone at 50% HP that mimics her attacks.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MinMinClone", 1)
local clone_spawned = {}

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc)
    if npc.Type == EntityType.ENTITY_MIN_MIN and not clone_spawned[npc.InitSeed] then
        local hpPercent = npc.HitPoints / npc.MaxHitPoints
        if hpPercent <= 0.5 and hpPercent > 0 then
            clone_spawned[npc.InitSeed] = true
            local clone = Isaac.Spawn(EntityType.ENTITY_MIN_MIN, 0, 0,
                npc.Position + Vector(60, 0), Vector.Zero, npc)
            if clone then
                clone:AddEntityFlags(EntityFlag.FLAG_CHAMPION)
                clone:ToNPC().HitPoints = math.floor(npc.MaxHitPoints * 0.5)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_WAVE, 0,
                    clone.Position, Vector.Zero, npc)
            end
        end
    end
    return nil
end)

Isaac.DebugString("MinMinClone loaded!")
