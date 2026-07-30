-- ==========================================================================
--  TinyEverything - The Binding of Isaac: Repentance
--  ALL entities are 50% smaller — player, enemies, projectiles, and pickups!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TinyEverything", 1)
local SCALE = 0.5

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, function(_, entity)
    if entity.Type == EntityType.ENTITY_EFFECT then return end
    local spr = entity:GetSprite()
    if spr then
        spr.Scale = Vector(SCALE, SCALE)
    end
    if entity:ToPlayer() then
        entity.SpriteScale = Vector(SCALE, SCALE)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local player = Isaac.GetPlayer(0)
    if player then
        player.SpriteScale = Vector(SCALE, SCALE)
    end
end)

Isaac.DebugString("TinyEverything loaded! Everything is adorably small!")
