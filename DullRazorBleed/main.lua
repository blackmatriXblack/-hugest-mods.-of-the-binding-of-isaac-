-- ==========================================================================
--  Dull Razor Bleed - The Binding of Isaac: Repentance
--  Dull Razor also triggers on-damage effects without losing HP
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("DullRazorBleed", 1)
local game = Game()

local DULL_RAZOR = CollectibleType.COLLECTIBLE_DULL_RAZOR
local triggered = false

function mod:onUseItem(itemType, rng, player)
    if itemType ~= DULL_RAZOR then return end
    if triggered then
        triggered = false
        return
    end

    -- Trigger on-damage items without actual HP loss
    triggered = true

    -- Check for common on-damage items and trigger their effects
    if player:HasCollectible(CollectibleType.COLLECTIBLE_OLD_BANDAGE) then
        -- Spawn red hearts as if hit
        local pos = player.Position
        for i = 1, 2 do
            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF,
                pos + Vector(RandomFloat() * 40 - 20, RandomFloat() * 40 - 20),
                Vector(RandomFloat() - 0.5, RandomFloat() - 0.5) * 3, player)
        end
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_POLAROID)
        or player:HasCollectible(CollectibleType.COLLECTIBLE_NEGATIVE) then
        -- Trigger invincibility shield for 5 seconds
        local effects = player:GetEffects()
        effects:AddCollectibleEffect(
            CollectibleType.COLLECTIBLE_CELTIC_CROSS, true, 150)
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_HABIT) then
        -- Give 1 charge to all active items
        for slot = 0, 3 do
            local item = player:GetActiveItem(slot)
            if item ~= CollectibleType.COLLECTIBLE_NULL then
                local charge = player:GetActiveCharge(slot)
                player:SetActiveCharge(slot, charge + 1)
            end
        end
    end

    Isaac.DebugString("DullRazorBleed: triggered on-damage effects")
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem, DULL_RAZOR)
Isaac.DebugString("DullRazorBleed loaded!")
