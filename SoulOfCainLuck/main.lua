-- ==========================================================================
--  Soul of Cain Luck - The Binding of Isaac: Repentance
--  Soul of Cain also grants +5 luck for the current room
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SoulOfCainLuck", 1)
local game = Game()

local SOUL_CAIN = CollectibleType.COLLECTIBLE_SOUL_OF_CAIN
local luckBonus = {}

function mod:onUseItem(itemType, rng, player)
    if itemType ~= SOUL_CAIN then return end

    local idx = player.InitSeed
    -- Grant +5 luck for current room
    player:AddLuck(5)
    luckBonus[idx] = true

    -- Visual indicator
    Isaac.Spawn(EntityType.ENTITY_EFFECT,
        EffectVariant.LUCK_FOOTPRINT, 0,
        player.Position + Vector(0, -30),
        Vector.Zero, player)

    -- Show luck value
    Isaac.RenderText("LUCK UP! (+5)",
        180, 140, 1, 0.2, 1, 0.3, 1)

    Isaac.DebugString("SoulOfCainLuck: +5 luck granted")
end

function mod:onNewRoom()
    -- Remove luck bonus when leaving room
    local player = Isaac.GetPlayer(0)
    if player then
        local idx = player.InitSeed
        if luckBonus[idx] then
            player:AddLuck(-5)
            luckBonus[idx] = false
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem, SOUL_CAIN)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("SoulOfCainLuck loaded!")
