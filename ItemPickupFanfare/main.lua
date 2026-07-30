-- ==========================================================================
--  ItemPickupFanfare - The Binding of Isaac: Repentance
--  Picking up items shows item name in large text with star particles!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("ItemPickupFanfare", 1)
local fanfareText = nil
local fanfareTimer = 0
local fanfareAlpha = 0
local FANFARE_DURATION = 60

mod:AddCallback(ModCallbacks.MC_POST_ITEM_PICKUP, function(_, collectibleType)
    local itemConfig = Isaac.GetItemConfig():GetCollectible(collectibleType)
    if itemConfig then
        fanfareText = itemConfig.Name
        fanfareTimer = 0
        fanfareAlpha = 1
        SFXManager():Play(SoundEffect.SOUND_HOLY, 0.7, 0, false, 1.0)

        local player = Isaac.GetPlayer(0)
        for i = 1, 16 do
            local angle = math.random() * math.pi * 2
            local speed = math.random(3, 7)
            local vel = Vector(math.cos(angle) * speed, math.sin(angle) * speed - 4)
            local spark = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPARKLE, 0,
                player.Position, vel, player)
            if spark then spark:SetTimeout(20) end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if not fanfareText or fanfareTimer >= FANFARE_DURATION then
        fanfareText = nil
        return
    end
    fanfareTimer = fanfareTimer + 1

    if fanfareTimer < 15 then
        fanfareAlpha = math.min(1, fanfareTimer / 15)
    elseif fanfareTimer > FANFARE_DURATION - 15 then
        fanfareAlpha = math.max(0, (FANFARE_DURATION - fanfareTimer) / 15)
    end

    local w, h = Isaac.GetScreenWidth(), Isaac.GetScreenHeight()
    local scale = 2 + math.sin(fanfareTimer * 0.2) * 0.2
    Isaac.RenderText(fanfareText, w / 2 - (#fanfareText * 8 * scale / 2),
        h * 0.3, 1, 0.8, 0.2, fanfareAlpha, scale)
end)

Isaac.DebugString("ItemPickupFanfare loaded! ITEM GET!")
