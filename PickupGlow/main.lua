-- ==========================================================================
--  PickupGlow - The Binding of Isaac: Repentance
--  Valuable pickups — nickels, dimes, lucky pennies, gold hearts — have a golden glow!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("PickupGlow", 1)

local VALUABLE_PICKUPS = {
    [PickupVariant.PICKUP_COIN] = {subtypes = {CoinSubType.COIN_NICKEL, CoinSubType.COIN_DIME, CoinSubType.COIN_LUCKYPENNY}},
    [PickupVariant.PICKUP_HEART] = {subtypes = {HeartSubType.HEART_GOLDEN}},
    [PickupVariant.PICKUP_BOMB] = {subtypes = {BombSubType.BOMB_GOLDEN}},
    [PickupVariant.PICKUP_KEY] = {subtypes = {KeySubType.KEY_GOLDEN}},
}

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    for _, ent in pairs(Isaac.GetRoomEntities()) do
        local pickup = ent:ToPickup()
        if not pickup then goto continue end

        local isValuable = false
        local config = VALUABLE_PICKUPS[pickup.Variant]
        if config then
            for _, sub in ipairs(config.subtypes) do
                if pickup.SubType == sub then
                    isValuable = true
                    break
                end
            end
        end

        if isValuable then
            local pulse = 0.3 + math.sin(Game():GetFrameCount() * 0.08 + pickup.IndexSeed * 0.5) * 0.2
            pickup:SetColor(Color(1 + pulse, 0.9 + pulse, 0.3, 1, 0, 0, 0), 1, 1, false, true)

            if Game():GetFrameCount() % 45 < 22 then
                local spark = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPARKLE, 0,
                    pickup.Position + Vector(math.random(-5, 5), math.random(-8, -2)),
                    Vector(0, -2), pickup)
                if spark then spark:SetTimeout(8) end
            end
        end
        ::continue::
    end
end)

Isaac.DebugString("PickupGlow loaded! Shiny things glow!")
