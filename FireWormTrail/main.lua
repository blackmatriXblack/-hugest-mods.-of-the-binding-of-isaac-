-- ==========================================================================
--  FireWormTrail - The Binding of Isaac: Repentance
--  Fire Worm leaves permanent fire trail that fills room over time
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("FireWormTrail", 1)
local game = Game()
local WORM_TYPE = EntityType.ENTITY_ROUND_WORM
local FIRE_VARIANT = 4

function mod:trailUpdate(_, npc)
    if npc.Type ~= WORM_TYPE or npc.Variant ~= FIRE_VARIANT then return end
    if npc.Velocity:Length() > 1 and npc.FrameCount % 5 == 0 then
        Isaac.GridSpawn(GridEntityType.GRID_FIRE, 0, npc.Position, true)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.trailUpdate, WORM_TYPE)
Isaac.DebugString("FireWormTrail loaded!")
