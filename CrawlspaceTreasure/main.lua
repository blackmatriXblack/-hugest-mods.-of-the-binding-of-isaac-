-- =============================================================================
--  CrawlspaceTreasure - The Binding of Isaac: Repentance
--  Crawlspaces have a 30% chance to contain an extra item pedestal as a hidden reward
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CrawlspaceTreasure", 1)

local function IsCrawlspace()
    local level = Game():GetLevel()
    -- Crawlspace stage is LevelStage.STAGE0 or we detect by room characteristics
    -- Crawlspaces often use a special stage or subtype
    return level:GetStage() == LevelStage.STAGE0
end

local function SpawnCrawlspaceItem()
    if not IsCrawlspace() then return end

    -- 30% chance to spawn an extra item pedestal
    local rng = RNG()
    rng:SetSeed(Game():GetRoom():GetAwardSeed(), 1)

    if rng:RandomInt(100) < 30 then
        local room = Game():GetRoom()
        local center = room:GetCenterPos()

        -- Spawn the extra item at a slightly offset position
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            0,
            Vector(center.X + 20, center.Y),
            Vector.Zero,
            nil
        )

        -- Visual feedback: sparkle effect
        local effect = Isaac.Spawn(
            EntityType.ENTITY_EFFECT,
            EffectVariant.SUPER_MAGNET,
            0,
            center,
            Vector.Zero,
            nil
        )
        if effect then
            effect:SetTimeout(60)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, SpawnCrawlspaceItem)
Isaac.DebugString("CrawlspaceTreasure loaded!")
