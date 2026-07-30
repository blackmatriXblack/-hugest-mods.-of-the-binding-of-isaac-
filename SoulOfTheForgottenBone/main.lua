-- ==========================================================================
--  Soul of the Forgotten Bone - The Binding of Isaac: Repentance
--  Soul of the Forgotten bone throw chains to 3 enemies
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SoulOfTheForgottenBone", 1)
local game = Game()

local SOUL_FORGOTTEN = CollectibleType.COLLECTIBLE_SOUL_OF_THE_FORGOTTEN

function mod:onUseItem(itemType, rng, player)
    if itemType ~= SOUL_FORGOTTEN then return end

    -- After the normal bone throw, spawn 2 extra chained bones
    -- targeting nearest enemies
    local entities = Isaac.GetRoomEntities()
    local enemies = {}
    for _, ent in ipairs(entities) do
        if ent:IsVulnerableEnemy() and ent:IsActiveEnemy() then
            local dist = (player.Position - ent.Position):Length()
            table.insert(enemies, {dist = dist, enemy = ent})
        end
    end
    table.sort(enemies, function(a, b) return a.dist < b.dist end)

    -- Spawn 2 additional bones targeting next enemies
    for i = 1, 2 do
        if enemies[i + 1] then
            local target = enemies[i + 1].enemy
            local dir = (target.Position - player.Position):Normalized()
            local bone = Isaac.Spawn(EntityType.ENTITY_EFFECT,
                EffectVariant.BONE_SPUR, 0,
                player.Position, dir * 10, player)
            if bone then
                bone:ToEffect().Target = target
                Isaac.DebugString("SoulOfTheForgottenBone: chained bone " .. i)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem, SOUL_FORGOTTEN)
Isaac.DebugString("SoulOfTheForgottenBone loaded!")
