-- =============================================================================
--  HeartUpgrader — The Binding of Isaac: Repentance
--  Half red hearts have 25% chance to upgrade to full hearts or soul hearts.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("HeartUpgrader", 1)

local UPGRADE_CHANCE = 0.25

function mod:UpgradeHeartPickup(pickup, variant, subtype)
    -- Half red heart is variant 10 subtype 1
    if variant == 10 and subtype == 1 then
        if math.random() < UPGRADE_CHANCE then
            if math.random() < 0.5 then
                -- Upgrade to full heart (variant 10 subtype 0)
                pickup:Morph(EntityType.ENTITY_PICKUP, 10, 0, false, false, false)
            else
                -- Upgrade to soul heart (variant 10 subtype 2)
                pickup:Morph(EntityType.ENTITY_PICKUP, 10, 2, false, false, false)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.UpgradeHeartPickup)
Isaac.DebugString("HeartUpgrader loaded!")
