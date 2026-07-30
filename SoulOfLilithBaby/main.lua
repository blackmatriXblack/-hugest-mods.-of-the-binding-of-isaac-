-- ==========================================================================
--  Soul of Lilith Baby - The Binding of Isaac: Repentance
--  Soul of Lilith spawns 2 familiars instead of 1
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SoulOfLilithBaby", 1)
local game = Game()

local SOUL_LILITH = CollectibleType.COLLECTIBLE_SOUL_OF_LILITH
local lastUseFrame = 0

function mod:onUseItem(itemType, rng, player)
    if itemType ~= SOUL_LILITH then return end
    if game:GetFrameCount() - lastUseFrame < 2 then return end

    lastUseFrame = game:GetFrameCount()

    -- Soul of Lilith normally spawns 1 random familiar
    -- This mod spawns a second one alongside it
    local pos = player.Position
    local familiars = {
        FamiliarVariant.BROTHER_BOBBY,
        FamiliarVariant.SISTER_MAGGY,
        FamiliarVariant.LITTLE_GISH,
        FamiliarVariant.LITTLE_STEVEN,
        FamiliarVariant.ROBO_BABY,
        FamiliarVariant.LITTLE_CHAD,
        FamiliarVariant.LITTLE_CHUBBY,
        FamiliarVariant.DEMON_BABY,
        FamiliarVariant.GHOST_BABY,
        FamiliarVariant.HARLEQUIN_BABY,
    }

    local extraFamiliar = familiars[(rng:Next() % #familiars) + 1]
    Isaac.Spawn(EntityType.ENTITY_FAMILIAR, extraFamiliar,
        0, pos + Vector(RandomFloat() * 20 - 10, RandomFloat() * 20 - 10),
        Vector.Zero, player)

    Isaac.DebugString("SoulOfLilithBaby: spawned extra familiar")
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem, SOUL_LILITH)
Isaac.DebugString("SoulOfLilithBaby loaded!")
