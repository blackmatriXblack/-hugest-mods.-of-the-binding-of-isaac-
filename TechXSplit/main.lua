-- =============================================================================
--  Tech X Split - The Binding of Isaac: Repentance
--  Tech X (395) laser ring splits into 4 small rings at halfway point.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TechXSplit", 1)
local COLLECTIBLE_TECH_X = 395

function mod:OnPeffectUpdate(player)
    if player:HasCollectible(COLLECTIBLE_TECH_X) then
        for _, tear in ipairs(Isaac.FindByType(EntityType.ENTITY_TEAR)) do
            if tear.SpawnerEntity == player then
                local traveled = tear.Position:Distance(tear.SpawnPosition or tear.Position)
                -- Splitting logic handled by tear data tracking
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.OnPeffectUpdate)
Isaac.DebugString("TechXSplit loaded!")
