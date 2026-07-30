-- ==========================================================================
--  Soul of Jacob and Esau - The Binding of Isaac: Repentance
--  Soul of Jacob and Esau spawns both effects simultaneously
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SoulOfJacobAndEsau", 1)
local game = Game()

local SOUL_JACOB = CollectibleType.COLLECTIBLE_SOUL_OF_JACOB_AND_ESAU

function mod:onUseItem(itemType, rng, player)
    if itemType ~= SOUL_JACOB then return end

    -- Soul of Jacob and Esau normally spawns either Esau or Dark Esau
    -- This mod spawns BOTH: one as ally, one with enhanced effects
    local pos = player.Position

    -- Spawn Esau Jr as a familiar ally
    local esau = Isaac.Spawn(EntityType.ENTITY_FAMILIAR,
        FamiliarVariant.ESAU_JR, 0,
        pos + Vector(20, -10), Vector.Zero, player)

    -- Also trigger the Dark Esau effect (creates a shadow copy)
    -- that attacks enemies and provides the Anima Sola chain
    local darkEsau = Isaac.Spawn(EntityType.ENTITY_EFFECT,
        EffectVariant.DARK_ARTS, 0,
        pos + Vector(-20, 10), Vector.Zero, player)

    -- Grant temporary damage boost from having both effects
    player:AddDamage(3, 300) -- +3 damage for 10 seconds

    Isaac.DebugString("SoulOfJacobAndEsau: both effects spawned!")
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem, SOUL_JACOB)
Isaac.DebugString("SoulOfJacobAndEsau loaded!")
