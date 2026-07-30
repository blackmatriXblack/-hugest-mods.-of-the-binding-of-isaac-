-- ==========================================================================
--  Trisagion Godhead - The Binding of Isaac: Repentance
--  Trisagion light beams gain Godhead homing aura around them
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TrisagionGodhead", 1)
local game = Game()

local TRISAGION = CollectibleType.COLLECTIBLE_TRISAGION
local GODHEAD = CollectibleType.COLLECTIBLE_GODHEAD

function mod:onPlayerUpdate(player)
    if not player or not player:HasCollectible(TRISAGION)
        or not player:HasCollectible(GODHEAD) then
        return
    end

    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        if ent.Type == EntityType.ENTITY_EFFECT then
            local eff = ent:ToEffect()
            if eff and eff.SpawnerEntity
                and eff.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
                if eff.Variant == EffectVariant.PLAYER_CREEP_HOLYWATER
                    or eff.Variant == EffectVariant.HOLY_MANTLE then
                    local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT,
                        EffectVariant.GODHEAD, 0, eff.Position,
                        Vector.Zero, player)
                    if aura then
                        aura:ToEffect().Scale = 0.8
                        aura:ToEffect().Timeout = 3
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("TrisagionGodhead loaded!")
