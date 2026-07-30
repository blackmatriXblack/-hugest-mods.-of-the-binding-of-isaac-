-- =============================================================================
--  BedroomHeal - The Binding of Isaac: Repentance
--  Entering any Bedroom fully restores the player's health to full
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BedroomHeal", 1)

local function IsBedroom()
    local room = Game():GetRoom()
    local roomType = room:GetType()
    return roomType == RoomType.ROOM_BEDROOM
end

local function HealPlayerOnEntry()
    if not IsBedroom() then return end

    for p = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(p)
        if player and player:Exists() then
            -- Fully restore red hearts and soul hearts
            local maxHearts = player:GetMaxHearts()
            player:AddHearts(maxHearts * 2)  -- Fill red hearts

            -- Restore all soul/black hearts
            local soulHearts = player:GetSoulHearts()
            local maxSoul = player:GetMaxHearts()  -- Max soul cap

            -- Give soul hearts to fill any missing slots
            player:AddSoulHearts(maxSoul)

            -- Visual feedback
            local effect = Isaac.Spawn(
                EntityType.ENTITY_EFFECT,
                EffectVariant.HEART,
                0,
                player.Position,
                Vector.Zero,
                player
            )

            -- Also restore bone hearts (Forgotten)
            player:AddBoneHearts(1)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, HealPlayerOnEntry)
Isaac.DebugString("BedroomHeal loaded!")
