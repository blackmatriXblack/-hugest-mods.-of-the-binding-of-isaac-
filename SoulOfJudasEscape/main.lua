-- ==========================================================================
--  Soul of Judas Escape - The Binding of Isaac: Repentance
--  Soul of Judas also grants brief flight during Dark Arts effect
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SoulOfJudasEscape", 1)
local game = Game()

local SOUL_JUDAS = CollectibleType.COLLECTIBLE_SOUL_OF_JUDAS
local flightActive = {}
local flightTimer = {}

function mod:onUseItem(itemType, rng, player)
    if itemType ~= SOUL_JUDAS then return end

    local idx = player.InitSeed
    flightActive[idx] = true
    flightTimer[idx] = game:GetFrameCount() + 150 -- 5 seconds flight

    -- Grant flight during dark arts effect
    if not player:CanFly() then
        player:AddNullCostume(NullItemID.ID_FLIGHT)
    end

    Isaac.DebugString("SoulOfJudasEscape: flight granted")
end

function mod:onPlayerUpdate(player)
    local idx = player.InitSeed
    if flightActive[idx] then
        if game:GetFrameCount() > flightTimer[idx] then
            flightActive[idx] = false
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem, SOUL_JUDAS)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("SoulOfJudasEscape loaded!")
