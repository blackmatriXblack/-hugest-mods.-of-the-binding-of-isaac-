-- =============================================================================
--  PedestalQualityGlow — The Binding of Isaac: Repentance
--  Item pedestals glow with color based on quality (Q0=gray, Q1=white, Q2=blue, Q3=purple, Q4=gold).
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PedestalQualityGlow", 1)

local QUALITY_COLORS = {
    [0] = Color(0.5, 0.5, 0.5, 1.0, 0, 0, 0),   -- gray
    [1] = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0),   -- white
    [2] = Color(0.3, 0.5, 1.0, 1.0, 0, 0, 0),   -- blue
    [3] = Color(0.7, 0.3, 1.0, 1.0, 0, 0, 0),   -- purple
    [4] = Color(1.0, 0.85, 0.1, 1.0, 0, 0, 0),  -- gold
}

function mod:ApplyPedestalGlow()
    local entities = Isaac.GetRoomEntities()
    for i = 0, entities.Size - 1 do
        local entity = entities:Get(i)
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            local pickup = entity:ToPickup()
            local itemConfig = Isaac.GetItemConfig()
            local collectible = itemConfig:GetCollectible(pickup.SubType)
            if collectible then
                local quality = collectible.Quality
                local color = QUALITY_COLORS[quality] or QUALITY_COLORS[0]
                pickup.Color = color
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.ApplyPedestalGlow)
Isaac.DebugString("PedestalQualityGlow loaded!")
