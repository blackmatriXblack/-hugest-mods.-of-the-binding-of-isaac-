-- ==========================================================================
--  EvilTwinShadow - The Binding of Isaac: Repentance
--  Evil Twin spawns a shadow copy of itself when player enters room
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("EvilTwinShadow", 1)
local game = Game()
local EVIL_TWIN_TYPE = EntityType.ENTITY_EVIL_TWIN

function mod:spawnShadow(_, entity)
    if entity.Type ~= EVIL_TWIN_TYPE then return end
    local room = game:GetRoom()
    local shadow = Isaac.Spawn(EntityType.ENTITY_EVIL_TWIN, 0, 0, entity.Position + Vector(60, 0), Vector.Zero, entity)
    if shadow then
        shadow:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
        local data = shadow:GetData()
        data.IsShadowClone = true
        shadow.SpriteScale = Vector(0.8, 0.8)
        shadow:GetSprite().Color = Color(0.2, 0.2, 0.3, 0.6, 0, 0, 0)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.spawnShadow, EVIL_TWIN_TYPE)
Isaac.DebugString("EvilTwinShadow loaded!")
