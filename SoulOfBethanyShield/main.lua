-- ==========================================================================
--  Soul of Bethany Shield - The Binding of Isaac: Repentance
--  Soul of Bethany wisps have double HP
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SoulOfBethanyShield", 1)
local game = Game()

local SOUL_BETHANY = CollectibleType.COLLECTIBLE_SOUL_OF_BETHANY
local wispsBoosted = {}

function mod:onUseItem(itemType, rng, player)
    if itemType ~= SOUL_BETHANY then return end

    -- After Soul of Bethany creates wisps, boost their HP
    -- Delayed by 1 frame to let wisps spawn
    local idx = player.InitSeed
    wispsBoosted[idx] = game:GetFrameCount()
end

function mod:onPlayerUpdate(player)
    local idx = player.InitSeed
    if not wispsBoosted[idx] then return end

    if game:GetFrameCount() - wispsBoosted[idx] < 5 then
        local entities = Isaac.GetRoomEntities()
        for _, ent in ipairs(entities) do
            if ent.Type == EntityType.ENTITY_FAMILIAR then
                local fam = ent:ToFamiliar()
                if fam and fam.Variant == FamiliarVariant.BETHANY_WISP
                    or fam.Variant == FamiliarVariant.LEMEGETON_WISP then
                    -- Double the wisp HP by giving them extra health
                    if fam.HitPoints < 6 then
                        fam.HitPoints = fam.HitPoints * 2
                    end
                end
            end
        end
        wispsBoosted[idx] = nil
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem, SOUL_BETHANY)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("SoulOfBethanyShield loaded!")
