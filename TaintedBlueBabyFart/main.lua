-- =============================================================================
--  TaintedBlueBabyFart - The Binding of Isaac: Repentance
--  Tainted ???: Poison farts also spawn 2 blue flies.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedBlueBabyFart", 1)
local TAINTED_BLUEBABY = 25

function mod:onPEffectUpdate(player)
    if player:GetPlayerType() ~= TAINTED_BLUEBABY then return end

    -- Check for poison fart effects (Toxic Shock / poison effects)
    local effects = player:GetEffects()
    local hasPoison = effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_TOXIC_SHOCK)
        or effects:HasNullEffect(NullItemID.ID_POISON)

    if hasPoison then
        local pos = player.Position
        for i = 1, 2 do
            local fly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 0, pos, RandomVector():Resized(3), player)
        end
        Isaac.DebugString("TaintedBlueBabyFart: 2 blue flies spawned.")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
Isaac.DebugString("TaintedBlueBabyFart loaded!")
