-- ==========================================================================
--  Soul of the Lost Mantle - The Binding of Isaac: Repentance
--  Soul of the Lost effect grants Holy Mantle shield for 1 room
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SoulOfTheLostMantle", 1)
local game = Game()

local SOUL_LOST = CollectibleType.COLLECTIBLE_SOUL_OF_THE_LOST
local mantleGiven = {}

function mod:onUseItem(itemType, rng, player)
    if itemType ~= SOUL_LOST then return end

    local idx = player.InitSeed
    if not mantleGiven[idx] then
        -- Grant Holy Mantle shield effect
        local effects = player:GetEffects()
        effects:AddCollectibleEffect(
            CollectibleType.COLLECTIBLE_HOLY_MANTLE,
            false, -1) -- -1 means until room change
        mantleGiven[idx] = true

        -- Visual feedback
        Isaac.Spawn(EntityType.ENTITY_EFFECT,
            EffectVariant.HOLY_MANTLE, 0,
            player.Position, Vector.Zero, player)

        Isaac.DebugString("SoulOfTheLostMantle: mantle granted")
    end
end

function mod:onNewRoom()
    -- Reset mantle state per room
    mantleGiven = {}
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem, SOUL_LOST)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("SoulOfTheLostMantle loaded!")
