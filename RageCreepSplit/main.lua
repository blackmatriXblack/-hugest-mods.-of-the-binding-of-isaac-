-- =============================================================================
--  RageCreepSplit - The Binding of Isaac: Repentance
--  Rage Creeps (wall creep variant) split into 2 smaller wall creeps on death
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RageCreepSplit", 1)
local RAGE_CREEP_TYPE = 241    -- EntityType.ENTITY_RAGE_CREEP (Repentance wall creep)

function mod:onNpcDeath(_, npc)
    if npc.Type ~= RAGE_CREEP_TYPE then return end

    local pos = npc.Position
    local room = Game():GetRoom()

    -- Find nearest wall to position the child creeps on walls
    local nearestWall = room:GetNearestWall(pos)
    local wallNormal = room:GetWallNormal(nearestWall)

    for i = -1, 1, 2 do
        local wallPos = pos + (wallNormal * 20) + (Vector(-wallNormal.Y, wallNormal.X) * 40 * i)
        wallPos = room:GetClampedPosition(wallPos, 25)

        local baby = Isaac.Spawn(RAGE_CREEP_TYPE, 0, 0, wallPos, Vector.Zero, npc)
        if baby then
            baby.Scale = 0.7
            baby:AddEntityFlags(EntityFlag.FLAG_APPEAR)
        end
    end

    -- Spawn a small effect to indicate the split
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCKET_EXPLOSION, 0,
        pos, Vector.Zero, npc)
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.onNpcDeath)
Isaac.DebugString("RageCreepSplit loaded!")
