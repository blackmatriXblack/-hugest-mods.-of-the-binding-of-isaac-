-- ==========================================================================
--  Reap Creep Clone - The Binding of Isaac: Repentance
--  Reap Creep clones itself at 25% HP — clone has 50% original HP.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("ReapCreepClone", 1)
local clone_spawned = {}

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc)
    if npc.Type == EntityType.ENTITY_REAP_CREEP and not clone_spawned[npc.InitSeed] then
        local hpPercent = npc.HitPoints / npc.MaxHitPoints
        if hpPercent <= 0.25 and hpPercent > 0 then
            clone_spawned[npc.InitSeed] = true
            local clone = Isaac.Spawn(EntityType.ENTITY_REAP_CREEP, 0, 0,
                npc.Position + Vector(40, -40), Vector(-2, 0), npc)
            if clone then
                clone:ToNPC().HitPoints = math.floor(npc.MaxHitPoints * 0.5)
                clone:AddEntityFlags(EntityFlag.FLAG_CHAMPION)
            end
        end
    end
    return nil
end)

Isaac.DebugString("ReapCreepClone loaded!")
