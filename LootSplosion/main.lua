-- ==========================================================================
--  LootSplosion - The Binding of Isaac: Repentance
--  Room clear rewards explode outward from center like a pinata!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("LootSplosion", 1)
local pendingLoot = {}
local lootTimer = 0

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_CLEAR, function()
    local room = Game():GetRoom()
    local center = room:GetCenterPos()
    local ents = Isaac.GetRoomEntities()
    local pickups = {}

    for _, ent in pairs(ents) do
        if ent:ToPickup() and not ent:IsShopItem() then
            table.insert(pickups, ent)
        end
    end

    if #pickups == 0 then return end

    pendingLoot = pickups
    lootTimer = 30

    for i, pickup in ipairs(pickups) do
        local angle = (i / #pickups) * math.pi * 2 + math.random() * 0.5
        local power = 6 + math.random(3, 9)
        pickup.Velocity = Vector(math.cos(angle) * power, math.sin(angle) * power - 4)
    end

    SFXManager():Play(SoundEffect.SOUND_CHEST_DROP, 0.6, 0, false, 1.1)
    for i = 1, 12 do
        local angle = math.random() * math.pi * 2
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPARKLE, 0,
            center, Vector(math.cos(angle) * 3, math.sin(angle) * 3 - 2), nil):SetTimeout(15)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if lootTimer > 0 then
        lootTimer = lootTimer - 1
        if lootTimer == 0 then
            pendingLoot = {}
        end
    end
end)

Isaac.DebugString("LootSplosion loaded! PIÑATA TIME!")
