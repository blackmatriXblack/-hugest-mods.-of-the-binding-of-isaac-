-- ==========================================================================
--  FlamingHopperLeap - The Binding of Isaac: Repentance
--  Flaming Hopper leaves fire where it lands after leaps
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("FlamingHopperLeap", 1)
local game = Game()
local HOPPER_TYPE = EntityType.ENTITY_HOPPER
local FLAMING_VARIANT = 3

function mod:leapUpdate(_, npc)
    if npc.Type ~= HOPPER_TYPE or npc.Variant ~= FLAMING_VARIANT then return end
    -- When hopper is airborne (y velocity is negative), mark previous position
    if npc.Velocity.Y < -2 then
        local prevPos = npc.Position - npc.Velocity
        -- Spawn a temp marker at takeoff
    end
    -- When landing (velocity was high positive and now low)
    if npc.Velocity.Y > 5 and npc.Position.Y > 100 then
        Isaac.GridSpawn(GridEntityType.GRID_FIRE, 0, npc.Position, true)
        -- Also spawn fire in a small cross pattern
        for i = 0, 3 do
            local angle = i * math.pi / 2
            local firePos = npc.Position + Vector(math.cos(angle) * 40, math.sin(angle) * 40)
            Isaac.GridSpawn(GridEntityType.GRID_FIRE, 0, firePos, true)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.leapUpdate, HOPPER_TYPE)
Isaac.DebugString("FlamingHopperLeap loaded!")
