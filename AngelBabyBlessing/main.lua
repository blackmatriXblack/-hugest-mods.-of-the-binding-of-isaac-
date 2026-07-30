-- =============================================================================
--  AngelBabyBlessing — The Binding of Isaac: Repentance
--  Angel Babies (Type=41.10) heal nearby enemies with a holy aura.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("AngelBabyBlessing", 1)
local game = Game()
local HEAL_RADIUS = 100
local HEAL_AMOUNT = 2

function mod:onPostUpdate()
    local room = game:GetRoom()
    local entities = Isaac.GetRoomEntities()
    for _, angel in ipairs(entities) do
        if angel.Type == 41 and angel.Variant == 10 then
            for _, other in ipairs(entities) do
                if other:IsVulnerableEnemy() and other.Index ~= angel.Index then
                    local dist = (other.Position - angel.Position):Length()
                    if dist < HEAL_RADIUS then
                        other:AddHealth(HEAL_AMOUNT)
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onPostUpdate)
Isaac.DebugString("AngelBabyBlessing loaded!")
