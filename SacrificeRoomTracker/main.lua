-- =============================================================================
--  SacrificeRoomTracker - The Binding of Isaac: Repentance
--  Displays remaining sacrifice room uses and rewards on screen
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SacrificeRoomTracker", 1)
local game = Game()
local sacrificeCount = 0
local maxSacrifices = 12
local inSacrificeRoom = false
local sacrificeCooldown = 0

function mod:onNewRoom()
    local room = game:GetRoom()
    if not room then return end

    -- Check if current room is a sacrifice room
    local roomType = room:GetType()
    inSacrificeRoom = (roomType == RoomType.ROOM_SACRIFICE)

    if inSacrificeRoom and not sacrificeCooldown then
        -- Reset when entering fresh
    end
    sacrificeCooldown = 0
end

function mod:onPlayerEffectUpdate(player)
    if not inSacrificeRoom then return end

    -- Detect when player takes spike damage (sacrifice room spikes)
    if sacrificeCooldown <= 0 and player:IsFrame(1, 0) then
        -- Check if player is on spikes by detecting damage taken
        -- We use a heuristic: if HP just decreased in a sacrifice room
    end

    if sacrificeCooldown > 0 then
        sacrificeCooldown = sacrificeCooldown - 1
    end
end

function mod:onEntityTakeDmg(target, amount, flags, source, countdown)
    if not inSacrificeRoom then return end
    if target.Type ~= EntityType.ENTITY_PLAYER then return end
    if amount <= 0 then return end

    local player = target:ToPlayer()
    if not player then return end

    -- Count sacrifice room spike damage
    sacrificeCount = sacrificeCount + 1
    sacrificeCooldown = 60  -- 1 second cooldown to prevent double counting

    Isaac.DebugString("SacrificeRoomTracker: Use #" .. tostring(sacrificeCount))
end

function mod:onPostRender()
    if not inSacrificeRoom then return end

    -- Calculate remaining uses
    local remaining = math.max(0, maxSacrifices - sacrificeCount)

    -- Draw sacrifice tracker panel
    local x = 8
    local y = 280

    Isaac.RenderText(
        "SACRIFICE ROOM TRACKER",
        x, y,
        0.9, 0.2, 0.2, 0.85
    )

    Isaac.RenderText(
        "Uses: " .. tostring(sacrificeCount) .. "/" .. tostring(maxSacrifices),
        x, y + 14,
        1.0, 0.8, 0.3, 0.8
    )

    Isaac.RenderText(
        "Remaining: " .. tostring(remaining),
        x, y + 28,
        0.7, 0.7, 0.7, 0.7
    )

    -- Show expected reward for next use
    local nextUse = sacrificeCount + 1
    local rewardText = "?"

    if nextUse == 1 then
        rewardText = "50% coin"
    elseif nextUse == 2 then
        rewardText = "50% coin"
    elseif nextUse == 3 then
        rewardText = "67% Angel Room"
    elseif nextUse == 4 then
        rewardText = "50% chest"
    elseif nextUse == 5 then
        rewardText = "33% Angel item"
    elseif nextUse == 6 then
        rewardText = "67% teleport to Dark Room"
    elseif nextUse == 7 then
        rewardText = "33% soul heart"
    elseif nextUse == 8 then
        rewardText = "100% troll bombs"
    elseif nextUse == 9 then
        rewardText = "50% Uriel"
    elseif nextUse == 10 then
        rewardText = "50% 7 soul hearts"
    elseif nextUse == 11 then
        rewardText = "50% Gabriel"
    elseif nextUse == 12 then
        rewardText = "50% teleport to Dark Room"
    end

    Isaac.RenderText(
        "Next: " .. rewardText,
        x, y + 42,
        0.5, 0.9, 0.5, 0.7
    )

    -- Progress bar
    local barWidth = 100
    local barHeight = 8
    local filledWidth = math.floor(barWidth * sacrificeCount / maxSacrifices)

    Isaac.RenderText(
        "[",
        x, y + 56,
        0.5, 0.5, 0.5, 0.8
    )

    for i = 1, barWidth do
        local char = (i <= filledWidth) and "=" or "-"
        local r, g = 0.0, 0.0
        if i <= filledWidth then
            local ratio = i / barWidth
            r = 1.0 - ratio * 0.5
            g = 0.2 + ratio * 0.6
        end
        Isaac.RenderText(
            char,
            x + 8 + i * 1.5, y + 56,
            r, g, 0.2, 0.7
        )
    end

    Isaac.RenderText(
        "]",
        x + 8 + barWidth * 1.5, y + 56,
        0.5, 0.5, 0.5, 0.8
    )
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerEffectUpdate)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)

Isaac.DebugString("SacrificeRoomTracker loaded!")
