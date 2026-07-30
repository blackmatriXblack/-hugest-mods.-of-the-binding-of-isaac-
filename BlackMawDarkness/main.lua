-- =============================================================================
--  BlackMawDarkness -- The Binding of Isaac: Repentance
--  Black Maws (Type=55) darken the room when they spawn.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BlackMawDarkness", 1)
local game = Game()

function mod:onEntitySpawn(entity)
    if entity.Type ~= 55 then return end
    local room = game:GetRoom()
    local center = room:GetCenterPos()
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARKNESS, 0, center, Vector.Zero, nil)
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onEntitySpawn)
Isaac.DebugString("BlackMawDarkness loaded!")
