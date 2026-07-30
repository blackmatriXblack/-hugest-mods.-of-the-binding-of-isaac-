-- ==========================================================================
--  StoveEnemyBurn - The Binding of Isaac: Repentance
--  Stove enemy cooks nearby pickups into better versions
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("StoveEnemyBurn", 1)
local game = Game()
local STOVE_TYPE = EntityType.ENTITY_STOVE

function mod:burnUpdate(_, npc)
    if npc.Type ~= STOVE_TYPE then return end
    if npc.FrameCount % 300 == 0 then
        local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP, -1, -1, false, false)
        for _, pickup in ipairs(pickups) do
            if npc.Position:Distance(pickup.Position) < 80 and pickup.Variant < 90 then
                local newPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, 0, 0, pickup.Position, Vector.Zero, npc)
                if newPickup then
                    newPickup:ToPickup():Morph(pickup.Type, math.min(pickup.Variant + 1, 90), true, true, true)
                    pickup:Remove()
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.burnUpdate, STOVE_TYPE)
Isaac.DebugString("StoveEnemyBurn loaded!")
