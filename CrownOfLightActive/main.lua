-- ==========================================================================
--  Crown of Light Active - The Binding of Isaac: Repentance
--  Crown of Light buff stays active for 5 seconds after taking damage
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("CrownOfLightActive", 1)
local game = Game()

local CROWN_OF_LIGHT = CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT
local damageTimers = {}

function mod:onTakeDamage(target, damageAmount, damageFlags, damageSource, countdown)
    local player = target:ToPlayer()
    if not player then return end
    if not player:HasCollectible(CROWN_OF_LIGHT) then return end

    damageTimers[player.InitSeed] = game:GetFrameCount() + 150
    local effects = player:GetEffects()
    effects:AddCollectibleEffect(CROWN_OF_LIGHT, true, 150)
end

function mod:onPlayerUpdate(player)
    if not player:HasCollectible(CROWN_OF_LIGHT) then return end
    local timer = damageTimers[player.InitSeed]
    if timer and game:GetFrameCount() < timer then
        local remaining = math.ceil((timer - game:GetFrameCount()) / 30)
        Isaac.RenderText("Crown Grace: " .. remaining .. "s",
            50, 110, 1, 1, 0.8, 0.3, 0.8)
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onTakeDamage)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("CrownOfLightActive loaded!")
