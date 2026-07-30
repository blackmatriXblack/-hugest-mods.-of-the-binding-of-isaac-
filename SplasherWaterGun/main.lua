-- ==========================================================================
--  SplasherWaterGun - The Binding of Isaac: Repentance
--  Splasher shoots water streams that push player away
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SplasherWaterGun", 1)
local game = Game()
local SPLASHER_TYPE = EntityType.ENTITY_SPLASHER

function mod:waterUpdate(_, npc)
    if npc.Type ~= SPLASHER_TYPE then return end
    local player = game:GetPlayer(0)
    if not player then return end
    if npc.FrameCount % 40 == 0 and npc.Position:Distance(player.Position) < 350 then
        local params = ProjectileParams()
        params.Variant = ProjectileVariant.PROJECTILE_TEAR
        params.Color = Color(0.3, 0.5, 1, 1, 0, 0, 0)
        local dir = (player.Position - npc.Position):Normalized()
        npc:FireProjectiles(npc.Position, dir:Resized(5), params)
    end
end

function mod:waterCollision(projectile, entity)
    if not projectile.SpawnerEntity or projectile.SpawnerEntity.Type ~= SPLASHER_TYPE then return end
    if entity:ToPlayer() then
        entity.Velocity = entity.Velocity + (projectile.Velocity:Normalized() * 4)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.waterUpdate, SPLASHER_TYPE)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.waterCollision)
Isaac.DebugString("SplasherWaterGun loaded!")
