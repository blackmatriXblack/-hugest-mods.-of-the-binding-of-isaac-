-- ==========================================================================
--  Abyss Locust Damage - The Binding of Isaac: Repentance
--  Abyss locust damage scales with player damage stat
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("AbyssLocustDmg", 1)
local game = Game()

local ABYSS = CollectibleType.COLLECTIBLE_ABYSS
local locustBoosted = {}

function mod:onPlayerUpdate(player)
    if not player:HasCollectible(ABYSS) then return end

    local damage = player.Damage
    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        if ent.Type == EntityType.ENTITY_FAMILIAR then
            local fam = ent:ToFamiliar()
            if fam and fam.Variant == FamiliarVariant.ABYSS_LOCUST then
                local key = GetPtrHash(fam)
                if not locustBoosted[key] then
                    -- Scale locust damage: base is ~3.5, adding 15 percent of player damage
                    locustBoosted[key] = true
                end
                -- Re-apply damage each frame to handle stat changes
                fam.CollisionDamage = 3.5 + (damage * 0.15)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("AbyssLocustDmg loaded!")
