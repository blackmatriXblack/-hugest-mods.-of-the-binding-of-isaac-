-- ==========================================================================
--  Purgatory Crack - The Binding of Isaac: Repentance
--  Purgatory cracks deal 2x damage to bosses
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("PurgatoryCrack", 1)
local game = Game()

local PURGATORY = CollectibleType.COLLECTIBLE_PURGATORY

function mod:onNPCUpdate(npc)
    if not npc:IsVulnerableEnemy() then return end

    local player = Isaac.GetPlayer(0)
    if not player or not player:HasCollectible(PURGATORY) then return end

    -- Purgatory creates cracks on the ground that explode after a delay
    -- Check if this enemy is near a purgatory crack effect
    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        if ent.Type == EntityType.ENTITY_EFFECT
            and ent.Variant == EffectVariant.CRACK_THE_SKY then
            local dist = (npc.Position - ent.Position):Length()
            if dist < 60 then
                local isBoss = npc:IsBoss()
                if isBoss then
                    -- Double the crack damage for bosses
                    local bossMult = 2.0
                    npc:TakeDamage(player.Damage * bossMult * 3, 0,
                        EntityRef(player), 0)
                    Isaac.DebugString("PurgatoryCrack: boss damage x2")
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
Isaac.DebugString("PurgatoryCrack loaded!")
