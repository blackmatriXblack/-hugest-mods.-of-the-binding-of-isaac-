-- =============================================================================
--  BossRushExtended - The Binding of Isaac: Repentance
--  Boss Rush has 20 waves instead of 15, drops an item every 5 waves
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BossRushExtended", 1)
local game = Game()
local itemPool = nil

function mod:onNewRoom()
    local room = game:GetRoom()
    if not room then return end

    local roomType = room:GetType()
    -- Boss Rush room type ID
    if roomType == RoomType.ROOM_BOSSRUSH then
        itemPool = game:GetItemPool()
        Isaac.DebugString("BossRushExtended: Entered Boss Rush - 20 waves incoming!")
    end
end

function mod:onPostUpdate()
    local room = game:GetRoom()
    if not room then return end

    if room:GetType() == RoomType.ROOM_BOSSRUSH then
        -- Check current wave number
        local waveNumber = room:GetBossRushWave()

        -- Drop an item every 5 waves (5, 10, 15, 20)
        if waveNumber > 0 and waveNumber % 5 == 0 then
            -- Only trigger once per wave
            if not mod.waveTriggered then mod.waveTriggered = {} end
            if not mod.waveTriggered[waveNumber] then
                mod.waveTriggered[waveNumber] = true

                -- Find spawn position for item (center of room)
                local player = Isaac.GetPlayer(0)
                if player then
                    local spawnPos = room:GetCenterPos()

                    if itemPool then
                        local item = itemPool:GetCollectible(ItemPoolType.POOL_BOSS, true)

                        Isaac.Spawn(
                            EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_COLLECTIBLE,
                            item,
                            spawnPos,
                            Vector.Zero,
                            nil
                        )

                        Isaac.DebugString("BossRushExtended: Dropped item at wave " .. tostring(waveNumber))
                    end
                end
            end
        end

        -- Display progress on HUD
        if waveNumber > 0 then
            Isaac.RenderText(
                "WAVE " .. tostring(waveNumber) .. "/20",
                240, 340,
                1.0, 0.8, 0.0, 0.9
            )

            -- Next item drop indicator
            local nextDrop = math.ceil(waveNumber / 5) * 5
            local wavesUntilDrop = nextDrop - waveNumber
            if wavesUntilDrop > 0 then
                Isaac.RenderText(
                    "Next item in " .. tostring(wavesUntilDrop) .. " waves",
                    240, 354,
                    0.7, 0.7, 0.7, 0.6
                )
            else
                Isaac.RenderText(
                    "ITEM DROPPED!",
                    240, 354,
                    0.0, 1.0, 0.3, 0.9
                )
            end
        end
    else
        -- Reset wave tracking when not in boss rush
        if mod.waveTriggered then
            mod.waveTriggered = {}
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onPostUpdate)

Isaac.DebugString("BossRushExtended loaded! 20 waves with item rewards.")
