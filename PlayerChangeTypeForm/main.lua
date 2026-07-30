-- =============================================================================
--  PlayerChangeTypeForm — The Binding of Isaac: Repentance
--  MC_POST_PLAYER_CHANGE_TYPE: When transforming (eg. Guppy), gain a
--  temporary damage shield for 5 seconds.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PlayerChangeTypeForm", 1)

local SHIELD_DURATION = 150 -- 5 seconds at 30fps
local SHIELD_END_FRAME = {}

function mod:onPostPlayerChangeType(player, oldType, newType)
    if not player:Exists() then return end
    if oldType == newType then return end

    local idx = GetPtrHash(player)
    SHIELD_END_FRAME[idx] = Isaac.GetFrameCount() + SHIELD_DURATION
    player:SetColor(Color(0.4, 0.4, 1.0, 1.0, 0, 0, 0), 150, 1)
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_CHANGE_TYPE, mod.onPostPlayerChangeType)

function mod:onPlayerTakeDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if not player then return end

    local idx = GetPtrHash(player)
    local endFrame = SHIELD_END_FRAME[idx]
    if endFrame and Isaac.GetFrameCount() < endFrame then
        return false -- Cancel damage
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onPlayerTakeDamage)

Isaac.DebugString("PlayerChangeTypeForm loaded!")
